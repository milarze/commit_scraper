(** Write data to a file in JSONL format *)

let write_data_to_file ~(filename : string) ~(data : Types.commit list) =
  let oc = open_out filename in
  let write_line line =
    Printf.fprintf oc "%s\n" line;
    flush oc
  in
  List.iter
    (fun (commit : Types.commit) ->
      let json =
        Printf.sprintf {|"message":"%s","diff":"%s"}|}
          (String.escaped commit.message)
          (String.escaped commit.diff)
      in
      write_line json)
    data;
  close_out oc
