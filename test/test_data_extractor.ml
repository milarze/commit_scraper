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

let test_extract_commit () =
  let json =
    Yojson.Safe.from_string
      "{\"sha\": \"abc123\", \"commit\": {\"author\": {\"name\": \"Alice\", \"date\": \
       \"2023-01-01T00:00:00Z\"}, \"message\": \"Initial commit\"}, \"files\": \
       [{\"patch\": \"hello\"}, {\"patch\": \"world\"}]}"
  in
  let commit = extract_commit ~commit_json:json in
  check (option testable_commit) "Extracted commit data"
    (Some
       {
         sha = "abc123";
         author = "Alice";
         date = "2023-01-01T00:00:00Z";
         message = "Initial commit";
         diff = "hello\nworld";
       })
    commit

let test_extract_commit_with_missing_fields () =
  let json =
    Yojson.Safe.from_string
      "{\"commit\": {\"author\": {\"name\": \"Alice\", \"date\": \
       \"2023-01-01T00:00:00Z\"}, \"message\": \"Initial commit\"}, \"files\": \
       [{\"patch\": \"hello\"}, {\"patch\": \"world\"}]}"
  in
  let commit = extract_commit ~commit_json:json in
  check (option testable_commit) "Commit with missing SHA is None" None commit;
  let json =
    Yojson.Safe.from_string
      "{\"sha\": \"abc123\", \"commit\": {\"message\": \"Initial commit\"}, \"files\": \
       [{\"patch\": \"hello\"}, {\"patch\": \"world\"}]}"
  in
  let commit = extract_commit ~commit_json:json in
  check (option testable_commit) "Commit with missing author is None" None commit;
  let json =
    Yojson.Safe.from_string
      "{\"sha\": \"abc123\", \"commit\": {\"author\": {\"name\": \"Alice\"}, \
       \"message\": \"Initial commit\"}, \"files\": [{\"patch\": \"hello\"}, {\"patch\": \
       \"world\"}]}"
  in
  let commit = extract_commit ~commit_json:json in
  check (option testable_commit) "Commit with missing date is None" None commit;
  let json =
    Yojson.Safe.from_string
      "{\"sha\": \"abc123\", \"commit\": {\"author\": {\"name\": \"Alice\", \"date\": \
       \"2023-01-01T00:00:00Z\"}}, \"files\": [{\"patch\": \"hello\"}, {\"patch\": \
       \"world\"}]}"
  in
  let commit = extract_commit ~commit_json:json in
  check (option testable_commit) "Commit with missing message is None" None commit;
  let json =
    Yojson.Safe.from_string
      "{\"sha\": \"abc123\", \"commit\": {\"author\": {\"name\": \"Alice\", \"date\": \
       \"2023-01-01T00:00:00Z\"}, \"message\": \"Initial commit\"}}"
  in
  let commit = extract_commit ~commit_json:json in
  check (option testable_commit) "Commit with missing files is None" None commit

(* Run the tests *)

let () =
  run "DataExtractor Tests"
    [
      ( "extract_commit",
        [ test_case "Extract single commit data" `Quick test_extract_commit ] );
      ( "extract_commit_missing_fields",
        [
          test_case "Extract commit with missing fields" `Quick
            test_extract_commit_with_missing_fields;
        ] );
    ]
