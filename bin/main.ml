let () =
  let message = Commit_scraper.Api_client.hello "World" in
  print_endline message;

  let url =
    Commit_scraper.Api_client.get_commits ~repo:"ezralim/commit_scraper"
      ~token:"your_token_here"
  in
  print_endline url
(* You can add more functionality here, such as parsing the response from the API. *)
