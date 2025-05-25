open Domain_types
open Lwt.Syntax

module Make
    (API : Api_client_intf.S)
    (Writer : sig
      val write_commit : commit -> unit Lwt.t
    end) =
struct
  let process_commit ~repo ~sha =
    let* commit_result = API.get_commit_details ~repo ~sha () in
    match commit_result with
    | Error e -> Lwt.return_error e
    | Ok commit_details ->
        let commit : commit =
          {
            sha = commit_details.sha;
            author = commit_details.author;
            date = commit_details.date;
            message = commit_details.message;
            diff = commit_details.diff;
          }
        in
        let* () = Writer.write_commit commit in
        Lwt.return_ok ()

  let rec process_batch ~repo ~(commit_summaries : commit_summary list) =
    match commit_summaries with
    | [] -> Lwt.return_ok []
    | summary :: rest -> (
        let* result = process_commit ~repo ~sha:summary.sha in
        match result with
        | Error e -> Lwt.return_error e
        | Ok commit -> (
            let* rest_result = process_batch ~repo ~commit_summaries:rest in
            match rest_result with
            | Error e -> Lwt.return_error e
            | Ok commits -> Lwt.return_ok (commit :: commits)))

  let rec process_all_commits ~repo ?(page = 1) ?(per_page = 100) ?(max_pages = None) () =
    let* commit_result = API.list_commits ~repo ~page ~per_page () in
    match commit_result with
    | Error e -> Lwt.return_error e
    | Ok (commits, next_page_url) -> (
        let* batch_result = process_batch ~repo ~commit_summaries:commits in
        match batch_result with
        | Error e -> Lwt.return_error e
        | Ok processed_commits -> (
            match (next_page_url, max_pages) with
            | Some _, Some n when page >= n -> Lwt.return_ok processed_commits
            | Some _, _ -> (
                let* next_result =
                  process_all_commits ~repo ~page:(page + 1) ~per_page ~max_pages ()
                in
                match next_result with
                | Error e -> Lwt.return_error e
                | Ok next_commits -> Lwt.return_ok (processed_commits @ next_commits))
            | None, _ -> Lwt.return_ok processed_commits))
end
