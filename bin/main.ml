open Commit_scraper.Data_extractor
open Commit_scraper.Api_client

let repo = ref ""
let token = ref ""

let speclist =
  [
    ("--repo", Arg.Set_string repo, "Repository name");
    ("--token", Arg.Set_string token, "GitHub token");
  ]

let usage_msg =
  "Usage: commit_scraper [options]\nOptions:\n\t --repo <repo> --token <token>"

let anon_func s = Printf.printf "Anonymous argument: %s\n" s

let () =
  Arg.parse speclist anon_func usage_msg;
  if !repo = "" || !token = "" then
    Printf.eprintf "Error: Both --repo and --token must be provided.\n%s" usage_msg
  else if not (is_valid_repo_name ~repo:!repo) then
    Printf.eprintf
      "Error: Invalid repository format. Expected format: username/reponame.\n%s"
      usage_msg
  else
    let commits = get_commits ~repo:!repo ~token:!token in
    let json = Yojson.Safe.Util.to_list commits in
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
    let filename =
      Str.global_replace (Str.regexp "/") "_" (Printf.sprintf "%s_commits.jsonl" !repo)
    in
    Commit_scraper.Data_writer.write_data_to_file ~filename ~data:commit_data
