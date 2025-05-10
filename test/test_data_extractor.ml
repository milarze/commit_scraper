open Alcotest
open Commit_scraper.Data_extractor
open Commit_scraper.Types

let testable_commit =
  let pp fmt commit =
    Format.fprintf fmt "{ sha: %s; author: %s; date: %s; message: %s, diff: %s }"
      commit.sha commit.author commit.date commit.message commit.diff
  in
  let equal c1 c2 =
    c1.sha = c2.sha
    && c1.author = c2.author
    && c1.date = c2.date
    && c1.message = c2.message
    && c1.diff = c2.diff
  in
  Alcotest.testable pp equal

let test_extract_data_from_commit_successfully () =
  let json =
    Yojson.Safe.from_string
      "[{\"sha\": \"abc123\", \"commit\": {\"author\": {\"name\": \"Alice\", \"date\": \
       \"2023-01-01T00:00:00Z\"}, \"message\": \"Initial commit\"}, \"files\": \
       [{\"diff\": \"hello\"}, {\"diff\": \"world\"}]}]"
  in
  let commits = Yojson.Safe.Util.to_list json in
  let commit_data : Commit_scraper.Types.commit list =
    extract_data_from_commit ~commits
  in
  check (list testable_commit) "Extracted commit data"
    [
      {
        sha = "abc123";
        author = "Alice";
        date = "2023-01-01T00:00:00Z";
        message = "Initial commit";
        diff = "hello\nworld";
      };
    ]
    commit_data

let test_extract_data_from_commit_with_empty_files_list () =
  let json =
    Yojson.Safe.from_string
      "[{\"sha\": \"abc123\", \"commit\": {\"author\": {\"name\": \"Alice\", \"date\": \
       \"2023-01-01T00:00:00Z\"}, \"message\": \"Initial commit\"}, \"files\":[]}]"
  in
  let commits = Yojson.Safe.Util.to_list json in
  let commit_data : Commit_scraper.Types.commit list =
    extract_data_from_commit ~commits
  in
  check (list testable_commit) "Lists commit with empty string as diff"
    [
      {
        sha = "abc123";
        author = "Alice";
        date = "2023-01-01T00:00:00Z";
        message = "Initial commit";
        diff = "";
      };
    ]
    commit_data

let test_extract_data_from_commit_with_missing_files () =
  let json =
    Yojson.Safe.from_string
      "[{\"sha\": \"abc123\", \"commit\": {\"author\": {\"name\": \"Alice\", \"date\": \
       \"2023-01-01T00:00:00Z\"}, \"message\": \"Initial commit\"}}]"
  in
  let commits = Yojson.Safe.Util.to_list json in
  let commit_data : Commit_scraper.Types.commit list =
    extract_data_from_commit ~commits
  in
  check (list testable_commit) "Commits with missing files are filtered out" []
    commit_data

let test_extract_data_from_commit_with_missing_sha () =
  let json =
    Yojson.Safe.from_string
      "[{\"commit\": {\"author\": {\"name\": \"Alice\", \"date\": \
       \"2023-01-01T00:00:00Z\"}, \"message\": \"Initial commit\"}, \"files\": \
       [{\"diff\": \"hello\"}, {\"diff\": \"world\"}]}]"
  in
  let commits = Yojson.Safe.Util.to_list json in
  let commit_data : Commit_scraper.Types.commit list =
    extract_data_from_commit ~commits
  in
  check (list testable_commit) "Commits with missing SHA are filtered out" [] commit_data

let test_extract_data_from_commit_with_missing_author () =
  let json =
    Yojson.Safe.from_string
      "[{\"sha\": \"abc123\", \"commit\": {\"message\": \"Initial commit\"}, \"files\": \
       [{\"diff\": \"hello\"}, {\"diff\": \"world\"}]}]"
  in
  let commits = Yojson.Safe.Util.to_list json in
  let commit_data : Commit_scraper.Types.commit list =
    extract_data_from_commit ~commits
  in
  check (list testable_commit) "Commits with missing author are filtered out" []
    commit_data

let test_extract_data_from_commit_with_missing_date () =
  let json =
    Yojson.Safe.from_string
      "[{\"sha\": \"abc123\", \"commit\": {\"author\": {\"name\": \"Alice\"}, \
       \"message\": \"Initial commit\"}, \"files\": [{\"diff\": \"hello\"}, {\"diff\": \
       \"world\"}]}]"
  in
  let commits = Yojson.Safe.Util.to_list json in
  let commit_data : Commit_scraper.Types.commit list =
    extract_data_from_commit ~commits
  in
  check (list testable_commit) "Commits with missing date are filtered out" [] commit_data

let test_extract_data_from_commit_with_missing_message () =
  let json =
    Yojson.Safe.from_string
      "[{\"sha\": \"abc123\", \"commit\": {\"author\": {\"name\": \"Alice\", \"date\": \
       \"2023-01-01T00:00:00Z\"}}, \"files\": [{\"diff\": \"hello\"}, {\"diff\": \
       \"world\"}]}]"
  in
  let commits = Yojson.Safe.Util.to_list json in
  let commit_data : Commit_scraper.Types.commit list =
    extract_data_from_commit ~commits
  in
  check (list testable_commit) "Commits with missing message are filtered out" []
    commit_data

(* Run the tests *)

let () =
  run "DataExtractor Tests"
    [
      ( "extract_data_from_commit_successfully",
        [
          test_case "Extract commit data" `Quick
            test_extract_data_from_commit_successfully;
        ] );
      ( "extract_data_from_commit_empty_files_list",
        [
          test_case "Extract commit data with empty files list" `Quick
            test_extract_data_from_commit_with_empty_files_list;
        ] );
      ( "extract_data_from_commit_missing_files",
        [
          test_case "Extract commit data with missing files" `Quick
            test_extract_data_from_commit_with_missing_files;
        ] );
      ( "extract_data_from_commit_missing_sha",
        [
          test_case "Extract commit data with missing SHA" `Quick
            test_extract_data_from_commit_with_missing_sha;
        ] );
      ( "extract_data_from_commit_missing_author",
        [
          test_case "Extract commit data with missing author" `Quick
            test_extract_data_from_commit_with_missing_author;
        ] );
      ( "extract_data_from_commit_missing_date",
        [
          test_case "Extract commit data with missing date" `Quick
            test_extract_data_from_commit_with_missing_date;
        ] );
      ( "extract_data_from_commit_missing_message",
        [
          test_case "Extract commit data with missing message" `Quick
            test_extract_data_from_commit_with_missing_message;
        ] );
    ]
