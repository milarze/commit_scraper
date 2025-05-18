val is_valid_repo_name : repo:string -> bool
(** [is_valid_repo_name repo] checks if the given [repo] name is valid. A valid repository
    name should match the pattern "username/reponame". *)

val request_headers : token:string -> Cohttp.Header.t
(** [request_headers ~token] creates a request header with the provided [token]. The
    header is used for authentication when making requests to the GitHub API. *)

val extract_next_page_url : headers:Cohttp.Header.t -> string option
(** [extract_next_page_url ~headers] extracts the next page URL from the response headers.
    The next page URL is provided in the "Link" header of the response. *)

val list_commits_url : repo:string -> string
(** [get_url ~repo] constructs the URL for fetching commits from the specified [repo]. *)

val get_commit_url : repo:string -> commit_sha:string -> string
(** [get_commit_url ~repo ~commit_sha] constructs the URL for fetching a specific commit
    from the specified [repo] using the given [commit_sha]. *)

val get_request : headers:Cohttp.Header.t -> url:string -> Cohttp.Response.t * string
(** [get_request ~headers ~url] makes a GET request to the specified [url] with the
    provided [headers]. The response is a tuple containing the HTTP response and the
    response body as a string. *)
