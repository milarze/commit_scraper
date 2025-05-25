open Commit_scraper.Domain_types
open Lwt.Syntax

(* Mock IO implementation for testing *)
module MockIO = struct
  let file_content = ref ""
  let file_open = ref false

  let reset () = 
    file_content := "";
    file_open := false

  let get_content () = !file_content
  let is_open () = !file_open

  let open_file _filename =
    if !file_open then Lwt.fail_with "File already open"
    else (
      file_open := true;
      file_content := "";
      (* Use /dev/null for a real channel that discards output *)
      Lwt_io.open_file ~mode:Lwt_io.Output "/dev/null")

  let write channel str =
    if not !file_open then Lwt.fail_with "File not open"
    else (
      file_content := !file_content ^ str;
      (* Write to the actual channel too to maintain compatibility *)
      Lwt_io.write channel str)

  let close channel =
    if not !file_open then Lwt.fail_with "File not open"
    else (
      file_open := false;
      Lwt_io.close channel)
end

(* Create a testable module using the MockIO *)
module TestWriter = Commit_scraper.Data_writer.Make (MockIO)

(* Test helpers *)
let lwt_run f () = Lwt_main.run (f ())

(* Tests *)
let test_initialize () =
  MockIO.reset ();

  let* () = TestWriter.initialize "test.txt" in
  Alcotest.(check bool) "File should be open after initialize" true (MockIO.is_open ());

  Lwt.return_unit

let test_write_commit () =
  MockIO.reset ();

  let* () = TestWriter.initialize "test.txt" in
  let* () =
    TestWriter.write_commit
      { sha = "abc123"; author = "Test Author"; date = "2024-01-01"; message = "Test commit"; diff = "some diff content" }
  in

  let content = MockIO.get_content () in
  let expected_json = {|{"message":"Test commit","diff":"some diff content"}|} in
  Alcotest.(check string) "Content should match expected JSON" expected_json content;

  Lwt.return_unit

let test_write_multiple_commits () =
  MockIO.reset ();

  let* () = TestWriter.initialize "test.txt" in
  let* () =
    TestWriter.write_commit { sha = "abc123"; author = "Author 1"; date = "2024-01-01"; message = "First commit"; diff = "diff 1" }
  in
  let* () =
    TestWriter.write_commit { sha = "def456"; author = "Author 2"; date = "2024-01-02"; message = "Second commit"; diff = "diff 2" }
  in

  let content = MockIO.get_content () in
  let expected_json = {|{"message":"First commit","diff":"diff 1"}{"message":"Second commit","diff":"diff 2"}|} in
  Alcotest.(check string) "Content should contain both commits" expected_json content;

  Lwt.return_unit

let test_close () =
  MockIO.reset ();

  let* () = TestWriter.initialize "test.txt" in
  let* () = TestWriter.close () in

  Alcotest.(check bool) "File should be closed after close" false (MockIO.is_open ());

  Lwt.return_unit

let test_write_after_close_fails () =
  MockIO.reset ();

  let* () = TestWriter.initialize "test.txt" in
  let* () = TestWriter.close () in

  Lwt.try_bind
    (fun () ->
      TestWriter.write_commit { sha = "abc123"; author = "Test Author"; date = "2024-01-01"; message = "Test commit"; diff = "diff" })
    (fun _ -> Alcotest.fail "Expected exception when writing to closed file")
    (fun _ ->
      (* Exception expected *)
      Lwt.return_unit)

(* Test runner *)
let () =
  let open Alcotest in
  run "File Writer Tests"
    [
      ( "initialize",
        [ test_case "Initialize file writer" `Quick (lwt_run test_initialize) ] );
      ( "write_commit",
        [
          test_case "Write single commit" `Quick (lwt_run test_write_commit);
          test_case "Write multiple commits" `Quick (lwt_run test_write_multiple_commits);
        ] );
      ( "close",
        [
          test_case "Close file writer" `Quick (lwt_run test_close);
          test_case "Write after close fails" `Quick
            (lwt_run test_write_after_close_fails);
        ] );
    ]
