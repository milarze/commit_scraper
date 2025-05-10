open Types
(* Extract commit data from a JSON object *)

let extract_commit ~commit_json =
  let open Yojson.Safe.Util in
  try
    let sha = commit_json |> member "sha" |> to_string in
    let author =
      commit_json |> member "commit" |> member "author" |> member "name" |> to_string
    in
    let date =
      commit_json |> member "commit" |> member "author" |> member "date" |> to_string
    in
    let message = commit_json |> member "commit" |> member "message" |> to_string in
    let diff =
      commit_json
      |> member "files"
      |> to_list
      |> List.map (fun file -> file |> member "diff" |> to_string)
      |> String.concat "\n"
    in
    Some { sha; author; date; message; diff }
  with _ ->
    Printf.eprintf "Error: Missing fields in JSON object\n";
    Printf.eprintf "Dropping commit...\n";
    None

let extract_data_from_commit ~commits =
  List.filter_map (fun commit_json -> extract_commit ~commit_json) commits
