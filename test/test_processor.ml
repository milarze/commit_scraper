open Commit_scraper.Domain_types

let lwt_run f () = Lwt_main.run (f ())

let api_error_testable =
  Alcotest.testable
    (fun fmt e ->
      Format.fprintf fmt "%s"
        (match e with
        | RateLimitExceeded -> "RateLimitExceeded"
        | NotFound -> "NotFound"
        | Unauthorized -> "Unauthorized"
        | NetworkError s -> Printf.sprintf "NetworkError(%s)" s
        | JsonParsingError s -> Printf.sprintf "ParseError(%s)" s
        | InvalidRepoName s -> Printf.sprintf "InvalidRepoName(%s)" s))
    ( = )

(* Actual tests *)
let test_process_commit () =
  Api_mocks.MockApiClient.set_mock_commits
    [
      {
        sha = "abc123";
        message = "Test commit 1";
        diff = "diff1";
        author = "Alice";
        date = "2023-02-04";
      };
    ];
  Writer_mocks.MockWriter.reset ();

  (* Create processor with mock implementations *)
  let module Processor =
    Commit_scraper.Processor.Make (Api_mocks.MockApiClient) (Writer_mocks.MockWriter)
  in
  Lwt.bind (Processor.process_commit ~repo:"repo" ~sha:"abc123") (function
    | Error e ->
        Alcotest.fail (Printf.sprintf "Expected successful commit processing, got error")
    | Ok commit ->
        (* Check the commit was written *)
        let written = Writer_mocks.MockWriter.get_written_commits () in
        Alcotest.(check int) "should write 1 commit" 1 (List.length written);
        Alcotest.(check string) "written commit sha" "abc123" (List.nth written 0).sha;

        Lwt.return_unit)

let test_process_commit_not_found () =
  Api_mocks.MockApiClient.set_mock_commits
    [
      {
        sha = "abc123";
        message = "Test commit 1";
        diff = "diff1";
        author = "Alice";
        date = "2023-02-04";
      };
    ];
  Writer_mocks.MockWriter.reset ();

  let module Processor =
    Commit_scraper.Processor.Make (Api_mocks.MockApiClient) (Writer_mocks.MockWriter)
  in
  Lwt.bind (Processor.process_commit ~repo:"repo" ~sha:"nonexistent") (function
    | Error e ->
        Alcotest.(check api_error_testable) "should return NotFound" NotFound e;
        Lwt.return_unit
    | Ok _ -> Alcotest.fail "Expected NotFound error, got success")

let test_process_batch () =
  Api_mocks.MockApiClient.set_mock_commits
    [
      {
        sha = "abc123";
        message = "Test commit 1";
        diff = "diff1";
        author = "Alice";
        date = "2023-01-01";
      };
      {
        sha = "def456";
        message = "Test commit 2";
        diff = "diff2";
        author = "Bob";
        date = "2023-01-02";
      };
      {
        sha = "ghi789";
        message = "Test commit 3";
        diff = "diff3";
        author = "Charlie";
        date = "2023-01-03";
      };
    ];
  Writer_mocks.MockWriter.reset ();

  let module Processor =
    Commit_scraper.Processor.Make (Api_mocks.MockApiClient) (Writer_mocks.MockWriter)
  in
  Lwt.bind
    (Processor.process_batch ~repo:"repo"
       ~commit_summaries:[ { sha = "abc123" }; { sha = "def456" } ])
    (function
      | Error e ->
          Alcotest.fail (Printf.sprintf "Expected successful batch processing, got error")
      | Ok commits ->
          (* Check processed commits *)
          Alcotest.(check int) "should process 2 commits" 2 (List.length commits);

          (* Check written commits *)
          let written = Writer_mocks.MockWriter.get_written_commits () in
          Alcotest.(check int) "should write 2 commits" 2 (List.length written);
          Alcotest.(check string) "first commit sha" "abc123" (List.nth written 0).sha;
          Alcotest.(check string) "second commit sha" "def456" (List.nth written 1).sha;

          Lwt.return_unit)

let test_process_batch_with_error () =
  Api_mocks.MockApiClient.set_mock_commits
    [
      {
        sha = "abc123";
        message = "Test commit 1";
        diff = "diff1";
        author = "Alice";
        date = "2023-01-01";
      };
      {
        sha = "def456";
        message = "Test commit 2";
        diff = "diff2";
        author = "Bob";
        date = "2023-01-02";
      };
    ];
  Writer_mocks.MockWriter.reset ();

  let module Processor =
    Commit_scraper.Processor.Make (Api_mocks.MockApiClient) (Writer_mocks.MockWriter)
  in
  Lwt.bind
    (Processor.process_batch ~repo:"repo"
       ~commit_summaries:
         [ { sha = "abc123" }; { sha = "nonexistent" }; { sha = "def456" } ])
    (function
      | Error e ->
          Alcotest.(check api_error_testable) "should return NotFound" NotFound e;

          (* Check we processed and wrote only the first commit before the error *)
          let written = Writer_mocks.MockWriter.get_written_commits () in
          Alcotest.(check int)
            "should write 1 commit before failure" 1 (List.length written);
          Alcotest.(check string) "written commit sha" "abc123" (List.nth written 0).sha;

          Lwt.return_unit
      | Ok _ -> Alcotest.fail "Expected NotFound error, got success")

let test_process_all_commits_single_page () =
  Api_mocks.MockApiClient.set_mock_commits
    [
      {
        sha = "abc123";
        message = "Test commit 1";
        diff = "diff1";
        author = "Alice";
        date = "2023-01-01";
      };
      {
        sha = "def456";
        message = "Test commit 2";
        diff = "diff2";
        author = "Bob";
        date = "2023-01-02";
      };
    ];
  Writer_mocks.MockWriter.reset ();

  let module Processor =
    Commit_scraper.Processor.Make (Api_mocks.MockApiClient) (Writer_mocks.MockWriter)
  in
  Lwt.bind (Processor.process_all_commits ~repo:"repo" ~per_page:100 ()) (function
    | Error e ->
        Alcotest.fail (Printf.sprintf "Expected successful processing, got error")
    | Ok commits ->
        Alcotest.(check int) "should process 2 commits" 2 (List.length commits);

        let written = Writer_mocks.MockWriter.get_written_commits () in
        Alcotest.(check int) "should write 2 commits" 2 (List.length written);

        Lwt.return_unit)

let test_process_all_commits_multiple_pages () =
  let commits =
    List.init 150 (fun i ->
        {
          sha = Printf.sprintf "sha%d" i;
          message = Printf.sprintf "Commit %d" i;
          diff = Printf.sprintf "diff%d" i;
          author = Printf.sprintf "Author %d" i;
          date = Printf.sprintf "2023-01-%02d" ((i mod 31) + 1);
        })
  in

  Api_mocks.MockApiClient.set_mock_commits commits;
  Writer_mocks.MockWriter.reset ();

  let module Processor =
    Commit_scraper.Processor.Make (Api_mocks.MockApiClient) (Writer_mocks.MockWriter)
  in
  Lwt.bind (Processor.process_all_commits ~repo:"repo" ~per_page:100 ()) (function
    | Error e ->
        Alcotest.fail (Printf.sprintf "Expected successful processing, got error")
    | Ok processed ->
        Alcotest.(check int) "should process 150 commits" 150 (List.length processed);

        let written = Writer_mocks.MockWriter.get_written_commits () in
        Alcotest.(check int) "should write 150 commits" 150 (List.length written);

        Lwt.return_unit)

let test_process_all_commits_with_max_pages () =
  let commits =
    List.init 250 (fun i ->
        {
          sha = Printf.sprintf "sha%d" i;
          message = Printf.sprintf "Commit %d" i;
          diff = Printf.sprintf "diff%d" i;
          author = Printf.sprintf "Author %d" i;
          date = Printf.sprintf "2023-01-%02d" ((i mod 31) + 1);
        })
  in

  Api_mocks.MockApiClient.set_mock_commits commits;
  Writer_mocks.MockWriter.reset ();

  let module Processor =
    Commit_scraper.Processor.Make (Api_mocks.MockApiClient) (Writer_mocks.MockWriter)
  in
  Lwt.bind
    (Processor.process_all_commits ~repo:"repo" ~per_page:100 ~max_pages:(Some 2) ())
    (function
    | Error e ->
        Alcotest.fail (Printf.sprintf "Expected successful processing, got error")
    | Ok processed ->
        Alcotest.(check int)
          "should process 200 commits (2 pages)" 200 (List.length processed);

        let written = Writer_mocks.MockWriter.get_written_commits () in
        Alcotest.(check int) "should write 200 commits" 200 (List.length written);

        Lwt.return_unit)

(* Test runner *)
let () =
  let open Alcotest in
  run "Processor Tests"
    [
      ( "single commit",
        [
          test_case "Process single commit" `Quick (lwt_run test_process_commit);
          test_case "Process non-existent commit" `Quick
            (lwt_run test_process_commit_not_found);
        ] );
      ( "batch processing",
        [
          test_case "Process batch of commits" `Quick (lwt_run test_process_batch);
          test_case "Process batch with error" `Quick
            (lwt_run test_process_batch_with_error);
        ] );
      ( "pagination",
        [
          test_case "Process single page of commits" `Quick
            (lwt_run test_process_all_commits_single_page);
          test_case "Process multiple pages of commits" `Quick
            (lwt_run test_process_all_commits_multiple_pages);
          test_case "Process with max pages" `Quick
            (lwt_run test_process_all_commits_with_max_pages);
        ] );
    ]
