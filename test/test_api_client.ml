open Alcotest
open Commit_scraper.Api_client

let test_get_url () =
  check string "username/reponame"
    "https://api.github.com/repos/username/reponame/commits"
    (list_commits_url ~repo:"username/reponame");
  check string "user-name/repo-name"
    "https://api.github.com/repos/user-name/repo-name/commits"
    (list_commits_url ~repo:"user-name/repo-name");
  check string "user_name/repo_name"
    "https://api.github.com/repos/user_name/repo_name/commits"
    (list_commits_url ~repo:"user_name/repo_name")

let test_get_url_invalid () =
  check_raises "Invalid repository format: invalid-repo"
    (Failure "Invalid repository format: invalid-repo. Expected format: username/reponame")
    (fun () -> ignore (list_commits_url ~repo:"invalid-repo"));
  check_raises "Invalid repository format: invalid/repo/name"
    (Failure
       "Invalid repository format: invalid/repo/name. Expected format: username/reponame")
    (fun () -> ignore (list_commits_url ~repo:"invalid/repo/name"));
  check_raises "Invalid repository format: invalid_repo_name"
    (Failure
       "Invalid repository format: invalid_repo_name. Expected format: username/reponame")
    (fun () -> ignore (list_commits_url ~repo:"invalid_repo_name"))

let () =
  run "ApiClient"
    [
      ("test_get_url", [ test_case "Valid repository" `Quick test_get_url ]);
      ( "test_get_url_invalid",
        [ test_case "Invalid repository" `Quick test_get_url_invalid ] );
    ]
