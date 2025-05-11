(** Module for extracting data from commit JSON objects. *)

val extract_commit : commit_json:Yojson.Safe.t -> Types.commit option
(** [extract_commit commit_json] extracts SHA, author, date, message, and diff from a
    commit JSON object.

    @param commit_json parsed as Yojson.Safe.t
    @return Some commit if all fields are present, None otherwise *)
