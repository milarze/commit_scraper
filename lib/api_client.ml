open Domain_types
open Lwt.Syntax

module Make (H : sig
  val get : ?headers:(string * string) list -> string -> (int * string) Lwt.t
end) =
struct
  let base_url = "https://api.github.com/repos/"
  let user_agent = "CommitScraper/1.0"

  let default_headers =
    [ ("User-Agent", user_agent); ("Accept", "application/vnd.github.v3+json") ]

  let extract_url (link : string) : string option =
    if Str.string_match (Str.regexp "<\\([^>]+\\)>") link 0 then (
      let matched_url = Str.matched_group 1 link in
      Printf.printf "Matched URL: %s\n" matched_url;
      Some matched_url)
    else None

  let extract_next_page_url ~(header : string) : string option =
    let links = Str.split (Str.regexp ",") header in
    Option.bind
      (List.find_opt
         (fun link ->
           let parts = Str.split (Str.regexp ";") link in
           List.exists (fun part -> String.trim part = "rel=\"next\"") parts)
         links)
      extract_url

  let list_commits ~repo ?(page = 1) ?(per_page = 100) () =
    if not (Utils.is_valid_repo_name ~repo) then Lwt.return (Error (InvalidRepoName repo))
    else
      let url =
        Printf.sprintf "%s%s/commits?page=%d&per_page=%d" base_url repo page per_page
      in

      let* status, response = H.get ~headers:default_headers url in
      match status with
      | 200 ->
          let next_page_url = extract_next_page_url ~header:response in
          let commits = Github_commit_j.commit_summaries_of_string response in
          let commit_summaries =
            List.map
              (fun (commit_summary : Github_commit_t.commit_summary) ->
                { sha = commit_summary.sha })
              commits
          in
          Lwt.return (Ok (commit_summaries, next_page_url))
      | 404 -> Lwt.return (Error NotFound)
      | 401 -> Lwt.return (Error Unauthorized)
      | 429 -> Lwt.return (Error RateLimitExceeded)
      | _ -> Lwt.return (Error (NetworkError (string_of_int status)))

  let get_commit_details ~repo ~sha () =
    if not (Utils.is_valid_repo_name ~repo) then Lwt.return (Error (InvalidRepoName repo))
    else
      let url = Printf.sprintf "%s%s/commits/%s" base_url repo sha in

      let* status, body = H.get ~headers:default_headers url in
      match status with
      | 200 ->
          let github_commit = Github_commit_j.github_commit_of_string body in
          Lwt.return
            (Ok
               {
                 sha = github_commit.sha;
                 author = github_commit.commit.author.name;
                 date = github_commit.commit.author.date;
                 message = github_commit.commit.message;
                 diff =
                   github_commit.files
                   |> List.map (fun (file : Github_commit_t.file_change) ->
                          file.patch |> Option.value ~default:"")
                   |> String.concat "\n";
               })
      | 404 -> Lwt.return (Error NotFound)
      | 401 -> Lwt.return (Error Unauthorized)
      | 403 -> Lwt.return (Error RateLimitExceeded)
      | _ -> Lwt.return (Error (NetworkError (string_of_int status)))
end

module HttpClient = struct
  open Cohttp
  open Cohttp_lwt_unix

  let get ?(headers = []) url =
    let headers = Header.of_list headers in
    let* response, body = Client.get ~headers (Uri.of_string url) in
    let status = Response.status response in
    let* body_string = Cohttp_lwt.Body.to_string body in
    Lwt.return (Cohttp.Code.code_of_status status, body_string)
end

include Make (HttpClient)
