let hello name = "Hello, " ^ name ^ "!"
let get_url ~repo = Printf.sprintf "https://api.github.com/repos/%s/commits" repo

let get_commits ~repo ~token =
  let url = get_url ~repo in
  print_endline (Printf.sprintf "Fetching commits from %s\n" url);
  print_endline (Printf.sprintf "Using token: %s\n" token);
  url
