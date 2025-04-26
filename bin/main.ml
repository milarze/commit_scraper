let () =
  let response_body =
    Lwt_main.run
      (Commit_scraper.Api_client.body ~repo:"example/repo" ~token:"example_token")
  in
  print_endline response_body
