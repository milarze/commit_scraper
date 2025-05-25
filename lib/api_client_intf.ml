open Domain_types

module type S = sig
  val list_commits :
    repo:string ->
    ?page:int ->
    ?per_page:int ->
    unit ->
    (commit_summary list * string option) result Lwt.t
  (** [list_commits ~repo ~page ~per_page ()] lists commits from the given repository.

      @param repo The repository to list commits from.
      @param page The page number to retrieve (default: 1).
      @param per_page The number of commits per page (default: 30).
      @return A result containing a list of commits or an error message. *)

  val get_commit_details :
    repo:string -> sha:string -> unit -> commit_details result Lwt.t
  (** [get_commit_details ~repo ~sha ()] retrieves details of a specific commit.

      @param repo The repository to retrieve commit details from.
      @param sha The SHA of the commit to retrieve.
      @return A result containing commit details or an error message. *)
end
