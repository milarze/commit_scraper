open Domain_types

module type S = sig
  val write_commit : commit -> unit Lwt.t
  (** [write_commit commit] writes the commit data to a file or database.

      @param commit The commit data to write.
      @return A unit result indicating success or failure. *)

  val close : unit -> unit Lwt.t
  (** [close ()] closes any open resources, such as file handles or database connections.

      @return A unit result indicating success or failure. *)
end
