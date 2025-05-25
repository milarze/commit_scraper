type sha = string
type author = string
type date = string
type commit_message = string
type commit_diff = string

type commit = {
  sha : sha;
  author : author;
  date : date;
  message : commit_message;
  diff : commit_diff;
}

type pagination = { page : int; per_page : int; next_page_url : string option }
type commit_summary = { sha : sha }

type commit_details = {
  sha : sha;
  author : author;
  date : date;
  message : commit_message;
  diff : commit_diff;
}

type api_error =
  | InvalidRepoName of string
  | RateLimitExceeded
  | Unauthorized
  | NotFound
  | NetworkError of string
  | JsonParsingError of string

type 'a result = ('a, api_error) Result.t

let string_of_api_error = function
  | InvalidRepoName repo -> Printf.sprintf "Invalid repository name: %s" repo
  | RateLimitExceeded -> "Rate limit exceeded"
  | Unauthorized -> "Unauthorized access"
  | NotFound -> "Resource not found"
  | NetworkError msg -> Printf.sprintf "Network error: %s" msg
  | JsonParsingError msg -> Printf.sprintf "JSON parsing error: %s" msg
