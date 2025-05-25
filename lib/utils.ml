open Str

let is_valid_repo_name ~(repo : string) = string_match (regexp "^[^/]+/[^/]+$") repo 0
