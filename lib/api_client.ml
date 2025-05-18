open Lwt
open Cohttp_lwt_unix
open Str

(** Check if the given repository name is valid. A valid repository name should match the
    pattern "username/reponame".

    @param repo The repository name in the format "username/reponame".
    @return true if the repository name is valid, false otherwise. *)
let is_valid_repo_name ~(repo : string) = string_match (regexp "^[^/]+/[^/]+$") repo 0

(** Create a request header with the provided token. The header is used for authentication
    when making requests to the GitHub API.

    @param token The GitHub token for authentication.
    @return A Cohttp header with the authorization token. *)
let request_headers ~(token : string) : Cohttp.Header.t =
  let headers = Cohttp.Header.init_with "Authorization" ("Bearer " ^ token) in
  Cohttp.Header.add headers "Accept" "application/vnd.github.v3+json"

let extract_url (link : string) : string option =
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

(** Get the URL that requests a list of commits from Github.

    @param repo The repository name in the format "username/reponame".
    @return
      The URL for the list of commits in the format
      "https://api.github.com/repos/username/reponame/commits". *)
let list_commits_url ~(repo : string) : string =
  if is_valid_repo_name ~repo then
    Printf.sprintf "https://api.github.com/repos/%s/commits" repo
  else
    failwith
      (Printf.sprintf "Invalid repository format: %s. Expected format: username/reponame"
         repo)

(** Get the commit URL from the repo and commit SHA. The URL is formatted to point to the
    GitHub API endpoint for a specific commit. Example:
    "https://api.github.com/repos/username/reponame/commits/commit_sha"

    @param repo The repository name in the format "username/reponame".
    @param commit_sha The SHA of the commit.
    @return
      The URL for the commit in the format
      "https://api.github.com/repos/username/reponame/commits/commit_sha". *)
let get_commit_url ~(repo : string) ~(commit_sha : string) =
  if is_valid_repo_name ~repo then
    Printf.sprintf "https://api.github.com/repos/%s/commits/%s" repo commit_sha
  else
    failwith
      (Printf.sprintf "Invalid repository format: %s. Expected format: username/reponame"
         repo)

(** Make a GET request to the specified URL with the provided headers. The response is a
    tuple containing the HTTP response and the response body as a string.

    @param headers The request headers.
    @param url The URL to make the GET request to.
    @return A tuple containing the HTTP response and the response body as a string. *)
let get_request ~(headers : Cohttp.Header.t) ~(url : string) : Cohttp.Response.t * string
    =
  let uri = Uri.of_string url in
  Lwt_main.run
    ( Client.get ~headers uri >>= fun (resp, body) ->
      body |> Cohttp_lwt.Body.to_string >|= fun body_string -> (resp, body_string) )
