open Lwt
open Cohttp_lwt_unix
open Str
open Yojson

let is_valid_repo_name ~repo = string_match (regexp "^[^/]+/[^/]+$") repo 0

(* This function constructs the URL for fetching commits from the specified repository. *)
(* It takes a repository name as input and returns the corresponding URL. *)
(* The URL is formatted to point to the GitHub API endpoint for commits. *)
(* Example: "https://api.github.com/repos/username/reponame/commits" *)
let list_commits_url ~repo =
  if is_valid_repo_name ~repo then
    Printf.sprintf "https://api.github.com/repos/%s/commits" repo
  else
    failwith
      (Printf.sprintf "Invalid repository format: %s. Expected format: username/reponame"
         repo)

let list_commits_body ~repo ~token =
  print_endline (Printf.sprintf "Fetching commits from %s\n" repo);
  print_endline (Printf.sprintf "Using token: %s\n" token);
  let uri = list_commits_url ~repo in
  let headers = Cohttp.Header.init_with "Authorization" ("Bearer " ^ token) in
  Client.get ~headers (Uri.of_string uri) >>= fun (_, body) ->
  Cohttp_lwt.Body.to_string body

(** * Get the commits from a repo using the provided token. *)
let get_commits ~repo ~token =
  let response_string = Lwt_main.run (list_commits_body ~repo ~token) in
  Safe.from_string response_string

(** Get the commit URL from the repo and commit SHA. The URL is formatted to point to the
    GitHub API endpoint for a specific commit. Example:
    "https://api.github.com/repos/username/reponame/commits/commit_sha"

    @param repo The repository name in the format "username/reponame".
    @param commit_sha The SHA of the commit.
    @return
      The URL for the commit in the format
      "https://api.github.com/repos/username/reponame/commits/commit_sha". *)
let get_commit_url ~repo ~commit_sha =
  if is_valid_repo_name ~repo then
    Printf.sprintf "https://api.github.com/repos/%s/commits/%s" repo commit_sha
  else
    failwith
      (Printf.sprintf "Invalid repository format: %s. Expected format: username/reponame"
         repo)

let get_commit_body ~repo ~token ~commit_sha =
  print_endline (Printf.sprintf "Fetching commit %s from %s\n" commit_sha repo);
  print_endline (Printf.sprintf "Using token: %s\n" token);
  let uri = get_commit_url ~repo ~commit_sha in
  let headers = Cohttp.Header.init_with "Authorization" ("Bearer " ^ token) in
  Client.get ~headers (Uri.of_string uri) >>= fun (_, body) ->
  Cohttp_lwt.Body.to_string body

(** Get the commit from the repo using the provided token and commit SHA.

    @param repo The repository name in the format "username/reponame"
    @param commit_sha The SHA of the commit.
    @param token The GitHub token for authentication.

    @return
      The commit data in JSON format. The response is a JSON object containing the commit
      details, including the SHA, author, date, message, and diff. Reference:
      https://docs.github.com/en/rest/commits/commits?apiVersion=2022-11-28#get-a-commit
*)
let get_commit ~repo ~token ~commit_sha =
  let response_string = Lwt_main.run (get_commit_body ~repo ~token ~commit_sha) in
  Safe.from_string response_string
