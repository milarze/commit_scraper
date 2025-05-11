val get_commits : repo:string -> token:string -> Yojson.Safe.t
(** [get_commits ~repo] fetches commits from the specified [repo] using the provided
    [token]. *)

val list_commits_url : repo:string -> string
(** [get_url ~repo] constructs the URL for fetching commits from the specified [repo]. *)

val list_commits_body : repo:string -> token:string -> string Lwt.t
(** [body ~repo ~token] fetches the body of the response from the specified [repo] using
    the provided [token]. *)

val is_valid_repo_name : repo:string -> bool
(** [is_valid_repo_name repo] checks if the given [repo] name is valid. A valid repository
    name should match the pattern "username/reponame". *)

val get_commit : repo:string -> token:string -> commit_sha:string -> Yojson.Safe.t
(** [get_commit ~repo ~commit_sha] fetches the commit data from the specified [repo] using
    the provided [commit_sha]. The response is a JSON object containing the commit
    details, including the SHA, author, date, message, and diff. *)
