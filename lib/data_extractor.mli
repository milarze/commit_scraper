(** Module for extracting data from commit JSON objects. *)
type commit = { sha : string; author : string; date : string; message : string }
(** Type representing a commit with SHA, author, date, and message. *)

val extract_data_from_commit : commits:Yojson.Safe.t list -> commit list
(** [extract_data_from_commit commits] extracts and prints SHA, author, and date from a
    list of commit JSON objects. *)
