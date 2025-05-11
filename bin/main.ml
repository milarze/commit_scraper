open Commit_scraper.Data_extractor
open Commit_scraper.Api_client

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

let () =
  Printf.printf "Commit Scraper\n";
  Arg.parse speclist anon_func usage_msg;
  if !repo = "" || !token = "" then
    Printf.eprintf "Error: Both --repo and --token must be provided.\n%s" usage_msg
  else if not (is_valid_repo_name ~repo:!repo) then
    Printf.eprintf
      "Error: Invalid repository format. Expected format: username/reponame.\n%s"
      usage_msg
  else (
    Printf.printf "Fetching commits from %s\n" !repo;
    (* Fetch commits from the repository *)
    let json = get_commits ~repo:!repo ~token:!token in
    Printf.printf "Fetched %d commits\n" (List.length json);
    let commit_data =
      List.filter_map
        (fun commit ->
          let commit_sha =
            commit |> Yojson.Safe.Util.member "sha" |> Yojson.Safe.Util.to_string
          in
          let commit_json = get_commit ~repo:!repo ~token:!token ~commit_sha in
          extract_commit ~commit_json)
        json
    in
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
    Commit_scraper.Data_writer.write_data_to_file ~filename:filepath ~data:commit_data)
