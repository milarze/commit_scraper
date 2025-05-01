open List

type commit = {
  sha : string;
  author : string;
  date : string;
  message : string;
  diff : string;
}

let extract_commit ~commit =
  let open Yojson.Safe.Util in
  let sha = commit |> member "sha" |> to_string in
  let author =
    commit |> member "commit" |> member "author" |> member "name" |> to_string
  in
  let date = commit |> member "commit" |> member "author" |> member "date" |> to_string in
  let message = commit |> member "commit" |> member "message" |> to_string in
  let diff =
    commit
    |> member "files"
    |> to_list
    |> map (fun file -> file |> member "diff" |> to_string)
    |> String.concat "\n"
  in
  { sha; author; date; message }

let extract_data_from_commit ~commits = map (fun commit -> extract_commit ~commit) commits
