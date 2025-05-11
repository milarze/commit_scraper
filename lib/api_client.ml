open Lwt
open Cohttp_lwt_unix
open Str
open Yojson

(** Check if the given repository name is valid. A valid repository name should match the
    pattern "username/reponame".
    @param repo The repository name in the format "username/reponame".
    @return true if the repository name is valid, false otherwise. *)
let is_valid_repo_name ~repo = string_match (regexp "^[^/]+/[^/]+$") repo 0

(** Create a request header with the provided token. The header is used for authentication
    when making requests to the GitHub API.
    @param token The GitHub token for authentication.
    @return A Cohttp header with the authorization token. *)
let request_headers ~token =
  let headers = Cohttp.Header.init_with "Authorization" ("Bearer " ^ token) in
  Cohttp.Header.add headers "Accept" "application/vnd.github.v3+json"

(** Extract the URL from the link response header part.
    @param link The link part with the angle brackets. <https://api.github.com/...>
    @return The URL if it exists, otherwise None. https://api.github.com/... *)
let extract_url link =
  if Str.string_match (Str.regexp "<\\([^>]+\\)>") link 0 then (
    let matched_url = Str.matched_group 1 link in
    Printf.printf "Matched URL: %s\n" matched_url;
    Some matched_url)
  else None

(** Extract the next page URL from the response headers. The next page URL is provided in
    the "Link" header of the response.
    @param headers The response headers.
    @return The next page URL if it exists, None otherwise. *)
let extract_next_page_url ~(headers : Cohttp.Header.t) : string option =
  match Cohttp.Header.get headers "Link" with
  | Some link_header ->
      let links = Str.split (Str.regexp ",") link_header in
      Option.bind
        (List.find_opt
           (fun link ->
             let parts = Str.split (Str.regexp ";") link in
             List.exists (fun part -> String.trim part = "rel=\"next\"") parts)
           links)
        extract_url
  | None -> None

(** Make a GET request to the specified URL with the provided headers.
    @param headers The request headers.
    @param url The URL to fetch.
    @return a pair with an optional next url string and the response body. *)
let get_request_body ~(headers : Cohttp.Header.t) ~(url : string) :
    (string option * string) Lwt.t =
  let uri = Uri.of_string url in
  Client.get ~headers uri >>= fun (resp, body) ->
  let headers = Cohttp.Response.headers resp in
  let next_page_url = extract_next_page_url ~headers in
  Cohttp_lwt.Body.to_string body >|= fun body_string -> (next_page_url, body_string)

(** Get the URL for fetching commits from the specified repository. *)

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

(** Get the commits from a repo using the provided token.
    @param repo The repository name in the format "username/reponame"
    @param token The GitHub token for authentication.
    @return
      A list of commits in JSON format. Each commit is represented as a JSON object
      containing the commit details, including the SHA, author, date, message, and diff.
      Reference:
      https://docs.github.com/en/rest/commits/commits?apiVersion=2022-11-28#list-commits
*)
let get_commits ~(repo : string) ~(token : string) : Safe.t list =
  Printf.printf "Fetching commits from %s\n" repo;
  let rec fetch_all_commits ~url ~token acc : Safe.t list Lwt.t =
    Printf.printf "Fetching commits from %s\n" url;
    get_request_body ~headers:(request_headers ~token) ~url
    >>= fun (next_page_url, body) ->
    let json = Yojson.Safe.from_string body in
    let commits = Yojson.Safe.Util.to_list json in
    let all_commits = List.rev_append acc commits in
    match next_page_url with
    | Some url -> fetch_all_commits ~url ~token all_commits
    | None -> Lwt.return (List.rev all_commits)
  in
  let url = list_commits_url ~repo in
  Lwt_main.run (fetch_all_commits ~url ~token [])

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

let get_commit_body ~repo ~token ~commit_sha : string Lwt.t =
  let uri = get_commit_url ~repo ~commit_sha in
  get_request_body ~headers:(request_headers ~token) ~url:uri >|= fun (_, body_string) ->
  body_string

(** Get the commit from the repo using the provided token and commit SHA.

    @param repo The repository name in the format "username/reponame"
    @param commit_sha The SHA of the commit.
    @param token The GitHub token for authentication.

    @return
      The commit data in JSON format. The response is a JSON object containing the commit
      details, including the SHA, author, date, message, and diff. Reference:
      https://docs.github.com/en/rest/commits/commits?apiVersion=2022-11-28#get-a-commit
*)
let get_commit ~repo ~token ~commit_sha : Safe.t =
  let response_string = Lwt_main.run (get_commit_body ~repo ~token ~commit_sha) in
  Safe.from_string response_string
