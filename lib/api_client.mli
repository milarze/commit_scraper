val get_commits : repo:string -> token:string -> string
(** [get_commits ~repo ~token] fetches commits from the specified [repo] using the
    provided [token]. *)

val get_url : repo:string -> string
(** [get_url ~repo] constructs the URL for fetching commits from the specified [repo]. *)

val body : repo:string -> token:string -> string Lwt.t
(** [body ~repo ~token] fetches the body of the response from the specified [repo] using
    the provided [token]. *)
