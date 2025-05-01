open Lwt
open Cohttp_lwt_unix
open Str
open Yojson

let is_valid_repo_name ~repo = string_match (regexp "^[^/]+/[^/]+$") repo 0

(* This function constructs the URL for fetching commits from the specified repository. *)
(* It takes a repository name as input and returns the corresponding URL. *)
(* The URL is formatted to point to the GitHub API endpoint for commits. *)
(* Example: "https://api.github.com/repos/username/reponame/commits" *)
let get_url ~repo =
  if is_valid_repo_name ~repo then
    Printf.sprintf "https://api.github.com/repos/%s/commits" repo
  else
    failwith
      (Printf.sprintf "Invalid repository format: %s. Expected format: username/reponame"
         repo)

let body ~repo ~token =
  print_endline (Printf.sprintf "Fetching commits from %s\n" repo);
  print_endline (Printf.sprintf "Using token: %s\n" token);
  let uri = get_url ~repo in
  Client.get (Uri.of_string uri) >>= fun (_, body) -> Cohttp_lwt.Body.to_string body

(** * Get the commits from a repo using the provided token. *)
let get_commits ~repo ~token =
  let response_string = Lwt_main.run (body ~repo ~token) in
  Safe.from_string response_string
