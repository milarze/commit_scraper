open Commit_scraper.Domain_types

module MockApiClient = struct
  let mock_commits =
    ref
      [
        {
          sha = "abc123";
          message = "Test commit 1";
          author = "Alice";
          date = "2023-01-01";
          diff = "diff1";
        };
        {
          sha = "def456";
          message = "Test commit 2";
          author = "Bob";
          date = "2023-01-02";
          diff = "diff2";
        };
        {
          sha = "ghi789";
          message = "Test commit 3";
          author = "Charlie";
          date = "2023-01-03";
          diff = "diff3";
        };
      ]

  let set_mock_commits commits = mock_commits := commits

  let list_commits ~repo ?page:(p = 1) ?per_page:(pp = 100) () =
    let start_idx = (p - 1) * pp in
    let end_idx = min (start_idx + pp) (List.length !mock_commits) in
    if start_idx >= List.length !mock_commits then Lwt.return_ok ([], None)
    else
      let batch =
        List.init (end_idx - start_idx) (fun i ->
            let commit = List.nth !mock_commits (start_idx + i) in
            { sha = commit.sha (* other fields would go here *) })
      in
      let has_next = end_idx < List.length !mock_commits in
      let pagination =
        {
          page = p;
          per_page = pp;
          next_page_url = (if has_next then Some "next_url" else None);
        }
      in
      Lwt.return_ok (batch, if has_next then Some "next_url" else None)

  let get_commit_details ~repo ~sha () =
    match List.find_opt (fun c -> c.sha = sha) !mock_commits with
    | Some commit ->
        Lwt.return_ok
          {
            sha = commit.sha;
            message = commit.message;
            author = commit.author;
            date = commit.date;
            diff = commit.diff;
          }
    | None -> Lwt.return_error NotFound
end
