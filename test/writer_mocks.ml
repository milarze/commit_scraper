open Commit_scraper.Domain_types

module MockWriter = struct
  let written_commits : commit list ref = ref []
  let reset () = written_commits := []

  let write_commit commit =
    written_commits := commit :: !written_commits;
    Lwt.return_unit

  let close () = Lwt.return_unit
  let get_written_commits () = List.rev !written_commits
end
