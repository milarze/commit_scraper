val get_commits : repo:string -> token:string -> Yojson.Safe.t
(** [get_commits ~repo ~token] fetches commits from the specified [repo] using the
    provided [token]. *)

val list_commits_url : repo:string -> string
(** [get_url ~repo] constructs the URL for fetching commits from the specified [repo]. *)

val body : repo:string -> token:string -> string Lwt.t
(** [body ~repo ~token] fetches the body of the response from the specified [repo] using
    the provided [token]. *)

val is_valid_repo_name : repo:string -> bool
(** [is_valid_repo_name repo] checks if the given [repo] name is valid. A valid repository
    name should match the pattern "username/reponame". *)
