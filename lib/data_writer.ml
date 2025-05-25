(* lib/file_writer.ml *)

open Domain_types
open Lwt.Syntax

module Make (IO : sig
  val open_file : string -> Lwt_io.output_channel Lwt.t
  val write : Lwt_io.output_channel -> string -> unit Lwt.t
  val close : Lwt_io.output_channel -> unit Lwt.t
end) =
struct
  let output_channel = ref None

  let initialize filename =
    let* channel = IO.open_file filename in
    output_channel := Some channel;
    Lwt.return_unit

  let write_commit (commit : commit) =
    match !output_channel with
    | None -> Lwt.fail_with "Writer not initialized"
    | Some channel ->
        let json_string =
          Printf.sprintf {|{"message":"%s","diff":"%s"}|}
            (String.escaped commit.message)
            (String.escaped commit.diff)
        in
        IO.write channel json_string

  let close () =
    match !output_channel with
    | None -> Lwt.return_unit
    | Some channel ->
        let* () = IO.close channel in
        output_channel := None;
        Lwt.return_unit
end

(* Real file IO implementation *)
module RealIO = struct
  let open_file filename = Lwt_io.open_file ~mode:Lwt_io.Output filename
  let write channel str = Lwt_io.write channel str
  let close = Lwt_io.close
end

(* Instantiate the real file writer *)
include Make (RealIO)
