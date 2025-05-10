(** Module for extracting data from commit JSON objects. *)

val extract_data_from_commit : commits:Yojson.Safe.t list -> Types.commit list
(** [extract_data_from_commit commits] extracts and prints SHA, author, and date from a
    list of commit JSON objects. *)
