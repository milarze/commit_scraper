open Commit_scraper
open Lwt.Syntax
open Utils

let repo = ref ""
let token = ref ""
let out_file = ref ""

let speclist =
  [
    ("--repo", Arg.Set_string repo, "Repository name");
    ("--token", Arg.Set_string token, "GitHub token");
    ("--output", Arg.Set_string out_file, "Output file");
  ]

let usage_msg =
  "Usage: commit_scraper [options]\nOptions:\n\t --repo <repo> --token <token>"

let anon_func s = Printf.printf "Anonymous argument: %s\n" s

let split_repo repo =
  match String.split_on_char '/' repo with
  | [ username; reponame ] -> (username, reponame)
  | _ ->
      Printf.eprintf
        "Error: Invalid repository format. Expected format: username/reponame.\n";
      exit 1

let touch_file filename =
  let oc = open_out filename in
  Printf.fprintf oc "";
  close_out oc

let run ~repo ~output_file ~max_commits =
  (* Initialize writer *)
  let* () = Data_writer.initialize output_file in

  (* Create processor with real implementations *)
  let module Processor = Processor.Make (Api_client) (Data_writer) in
  (* Calculate max pages based on max_commits *)
  let max_pages =
    if max_commits <= 0 then None else Some ((max_commits + 99) / 100)
    (* Ceiling division by 100 *)
  in

  (* Process commits *)
  let* result = Processor.process_all_commits ~repo ~per_page:100 ~max_pages () in

  (* Close writer *)
  let* () = Data_writer.close () in

  (* Handle result *)
  match result with
  | Ok commits ->
      Printf.printf "Successfully processed %d commits\n" (List.length commits);
      Lwt.return_unit
  | Error e ->
      Printf.eprintf "Error: %s\n" (Domain_types.string_of_api_error e);
      Lwt.return_unit

let () =
  Printf.printf "Commit Scraper\n";
  Arg.parse speclist anon_func usage_msg;
  if !repo = "" || !token = "" then
    Printf.eprintf "Error: Both --repo and --token must be provided.\n%s" usage_msg
  else if not (is_valid_repo_name ~repo:!repo) then
    Printf.eprintf
      "Error: Invalid repository format. Expected format: username/reponame.\n%s"
      usage_msg
  else
    (* Write data to file in JSONL format *)
    let filepath =
      if !out_file <> "" then !out_file
      else
        let username, reponame = split_repo !repo in
        (try Unix.mkdir username 0o755
         with Unix.Unix_error (Unix.EEXIST, _, _) ->
           Printf.printf "Directory %s already exists.\n" username);
        Printf.sprintf "%s/%s_commits.jsonl" username reponame
    in
    touch_file filepath;
    Lwt_main.run (run ~repo:!repo ~output_file:filepath ~max_commits:0)
