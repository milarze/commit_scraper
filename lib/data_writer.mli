val write_data_to_file : filename:string -> data:Types.commit list -> unit
(** [write_data_to_file ~filename ~data] writes the commit data to a file in JSONL format.
    Each line in the file represents a commit with its SHA, author, date, message, and
    diff.

    @param filename to write to
    @param commits list to be written to the file
    @return unit *)
