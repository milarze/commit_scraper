open Alcotest
open Commit_scraper.Api_client

let test_list_commits_url () =
  check string "username/reponame"
    "https://api.github.com/repos/username/reponame/commits"
    (list_commits_url ~repo:"username/reponame");
  check string "user-name/repo-name"
    "https://api.github.com/repos/user-name/repo-name/commits"
    (list_commits_url ~repo:"user-name/repo-name");
  check string "user_name/repo_name"
    "https://api.github.com/repos/user_name/repo_name/commits"
    (list_commits_url ~repo:"user_name/repo_name")

let test_list_commits_url_invalid () =
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

let test_valid_repo_name () =
  check bool "Valid repository name" true (is_valid_repo_name ~repo:"username/reponame");
  check bool "Valid repository name" true (is_valid_repo_name ~repo:"user-name/repo-name");
  check bool "Valid repository name" true (is_valid_repo_name ~repo:"user_name/repo_name");
  check bool "Valid repository name" true (is_valid_repo_name ~repo:"user.name/repo.name");
  check bool "Valid repository name" true (is_valid_repo_name ~repo:"user-name/repo.name");
  check bool "Valid repository name" true (is_valid_repo_name ~repo:"user.name/repo-name");
  check bool "Invalid repository name" false (is_valid_repo_name ~repo:"invalid-repo");
  check bool "Invalid repository name" false
    (is_valid_repo_name ~repo:"invalid/repo/name");
  check bool "Invalid repository name" false
    (is_valid_repo_name ~repo:"invalid_repo_name")

let test_extract_next_page_url () =
  (let headers = Cohttp.Header.init () in
   let headers =
     Cohttp.Header.add headers "Link" "<https://api.github.com/next>; rel=\"next\""
   in
   match extract_next_page_url ~headers with
   | Some url -> check string "Next page URL" "https://api.github.com/next" url
   | None -> failwith "No next page URL found");
  (let headers = Cohttp.Header.init () in
   let headers =
     Cohttp.Header.add headers "Link" "<https://api.github.com/prev>; rel=\"prev\""
   in
   match extract_next_page_url ~headers with
   | Some _ -> failwith "Expected no next page URL, but got one"
   | None -> check string "No next page URL" "None" "None");
  (let headers = Cohttp.Header.init () in
   let headers =
     Cohttp.Header.add headers "Link"
       "<https://api.github.com/next>; rel=\"next\", <https://api.github.com/prev>; \
        rel=\"prev\""
   in
   match extract_next_page_url ~headers with
   | Some url -> check string "Next page URL" "https://api.github.com/next" url
   | None -> failwith "No next page URL found");
  let headers = Cohttp.Header.init () in
  let headers =
    Cohttp.Header.add headers "Link" "https://api.github.com/next; rel=\"next\""
  in
  match extract_next_page_url ~headers with
  | Some _ -> failwith "Expected no next page URL, but got one"
  | None -> check string "No next page URL" "None" "None"

let () =
  run "ApiClient"
    [
      ( "test_list_commits_url",
        [ test_case "Valid list commits url" `Quick test_list_commits_url ] );
      ( "test_list_commits_url_invalid",
        [ test_case "Invalid repository" `Quick test_list_commits_url_invalid ] );
      ( "test_valid_repo_name",
        [ test_case "Valid repository name" `Quick test_valid_repo_name ] );
      ( "test_extract_next_page_url",
        [ test_case "Extract next page URL" `Quick test_extract_next_page_url ] );
    ]
