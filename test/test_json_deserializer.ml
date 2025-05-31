let list_commits_json =
  ref
    "[\n\
    \  {\n\
    \    \"url\": \
     \"https://api.github.com/repos/octocat/Hello-World/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\
    \    \"sha\": \"6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\
    \    \"node_id\": \
     \"MDY6Q29tbWl0NmRjYjA5YjViNTc4NzVmMzM0ZjYxYWViZWQ2OTVlMmU0MTkzZGI1ZQ==\",\n\
    \    \"html_url\": \
     \"https://github.com/octocat/Hello-World/commit/6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\
    \    \"comments_url\": \
     \"https://api.github.com/repos/octocat/Hello-World/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e/comments\",\n\
    \    \"commit\": {\n\
    \      \"url\": \
     \"https://api.github.com/repos/octocat/Hello-World/git/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\
    \      \"author\": {\n\
    \        \"name\": \"Monalisa Octocat\",\n\
    \        \"email\": \"support@github.com\",\n\
    \        \"date\": \"2011-04-14T16:00:49Z\"\n\
    \      },\n\
    \      \"committer\": {\n\
    \        \"name\": \"Monalisa Octocat\",\n\
    \        \"email\": \"support@github.com\",\n\
    \        \"date\": \"2011-04-14T16:00:49Z\"\n\
    \      },\n\
    \      \"message\": \"Fix all the bugs\",\n\
    \      \"tree\": {\n\
    \        \"url\": \
     \"https://api.github.com/repos/octocat/Hello-World/tree/6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\
    \        \"sha\": \"6dcb09b5b57875f334f61aebed695e2e4193db5e\"\n\
    \      },\n\
    \      \"comment_count\": 0,\n\
    \      \"verification\": {\n\
    \        \"verified\": false,\n\
    \        \"reason\": \"unsigned\",\n\
    \        \"signature\": null,\n\
    \        \"payload\": null,\n\
    \        \"verified_at\": null\n\
    \      }\n\
    \    },\n\
    \    \"author\": {\n\
    \      \"login\": \"octocat\",\n\
    \      \"id\": 1,\n\
    \      \"node_id\": \"MDQ6VXNlcjE=\",\n\
    \      \"avatar_url\": \"https://github.com/images/error/octocat_happy.gif\",\n\
    \      \"gravatar_id\": \"\",\n\
    \      \"url\": \"https://api.github.com/users/octocat\",\n\
    \      \"html_url\": \"https://github.com/octocat\",\n\
    \      \"followers_url\": \"https://api.github.com/users/octocat/followers\",\n\
    \      \"following_url\": \
     \"https://api.github.com/users/octocat/following{/other_user}\",\n\
    \      \"gists_url\": \"https://api.github.com/users/octocat/gists{/gist_id}\",\n\
    \      \"starred_url\": \
     \"https://api.github.com/users/octocat/starred{/owner}{/repo}\",\n\
    \      \"subscriptions_url\": \"https://api.github.com/users/octocat/subscriptions\",\n\
    \      \"organizations_url\": \"https://api.github.com/users/octocat/orgs\",\n\
    \      \"repos_url\": \"https://api.github.com/users/octocat/repos\",\n\
    \      \"events_url\": \"https://api.github.com/users/octocat/events{/privacy}\",\n\
    \      \"received_events_url\": \
     \"https://api.github.com/users/octocat/received_events\",\n\
    \      \"type\": \"User\",\n\
    \      \"site_admin\": false\n\
    \    },\n\
    \    \"committer\": {\n\
    \      \"login\": \"octocat\",\n\
    \      \"id\": 1,\n\
    \      \"node_id\": \"MDQ6VXNlcjE=\",\n\
    \      \"avatar_url\": \"https://github.com/images/error/octocat_happy.gif\",\n\
    \      \"gravatar_id\": \"\",\n\
    \      \"url\": \"https://api.github.com/users/octocat\",\n\
    \      \"html_url\": \"https://github.com/octocat\",\n\
    \      \"followers_url\": \"https://api.github.com/users/octocat/followers\",\n\
    \      \"following_url\": \
     \"https://api.github.com/users/octocat/following{/other_user}\",\n\
    \      \"gists_url\": \"https://api.github.com/users/octocat/gists{/gist_id}\",\n\
    \      \"starred_url\": \
     \"https://api.github.com/users/octocat/starred{/owner}{/repo}\",\n\
    \      \"subscriptions_url\": \"https://api.github.com/users/octocat/subscriptions\",\n\
    \      \"organizations_url\": \"https://api.github.com/users/octocat/orgs\",\n\
    \      \"repos_url\": \"https://api.github.com/users/octocat/repos\",\n\
    \      \"events_url\": \"https://api.github.com/users/octocat/events{/privacy}\",\n\
    \      \"received_events_url\": \
     \"https://api.github.com/users/octocat/received_events\",\n\
    \      \"type\": \"User\",\n\
    \      \"site_admin\": false\n\
    \    },\n\
    \    \"parents\": [\n\
    \      {\n\
    \        \"url\": \
     \"https://api.github.com/repos/octocat/Hello-World/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\
    \        \"sha\": \"6dcb09b5b57875f334f61aebed695e2e4193db5e\"\n\
    \      }\n\
    \    ]\n\
    \  }\n\
     ]"

let list_commits_invalid_json =
  ref
    "[\n\n\
    \      {\n\n\
    \        \"url\": \
     \"https://api.github.com/repos/octocat/Hello-World/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\n\
    \        \"sha\": \"6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\n\
    \        \"node_id\": \
     \"MDY6Q29tbWl0NmRjYjA5YjViNTc4NzVmMzM0ZjYxYWViZWQ2OTVlMmU0MTkzZGI1ZQ==\",\n\n\
    \        \"html_url\": null,\n\n\
    \      }\n\n\
    \    ]"

let github_commit =
  ref
    "{\n\
    \  \"url\": \
     \"https://api.github.com/repos/octocat/Hello-World/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\
    \  \"sha\": \"6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\
    \  \"node_id\": \
     \"MDY6Q29tbWl0NmRjYjA5YjViNTc4NzVmMzM0ZjYxYWViZWQ2OTVlMmU0MTkzZGI1ZQ==\",\n\
    \  \"html_url\": \
     \"https://github.com/octocat/Hello-World/commit/6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\
    \  \"comments_url\": \
     \"https://api.github.com/repos/octocat/Hello-World/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e/comments\",\n\
    \  \"commit\": {\n\
    \    \"url\": \
     \"https://api.github.com/repos/octocat/Hello-World/git/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\
    \    \"author\": {\n\
    \      \"name\": \"Monalisa Octocat\",\n\
    \      \"email\": \"mona@github.com\",\n\
    \      \"date\": \"2011-04-14T16:00:49Z\"\n\
    \    },\n\
    \    \"committer\": {\n\
    \      \"name\": \"Monalisa Octocat\",\n\
    \      \"email\": \"mona@github.com\",\n\
    \      \"date\": \"2011-04-14T16:00:49Z\"\n\
    \    },\n\
    \    \"message\": \"Fix all the bugs\",\n\
    \    \"tree\": {\n\
    \      \"url\": \
     \"https://api.github.com/repos/octocat/Hello-World/tree/6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\
    \      \"sha\": \"6dcb09b5b57875f334f61aebed695e2e4193db5e\"\n\
    \    },\n\
    \    \"comment_count\": 0,\n\
    \    \"verification\": {\n\
    \      \"verified\": false,\n\
    \      \"reason\": \"unsigned\",\n\
    \      \"signature\": null,\n\
    \      \"payload\": null,\n\
    \      \"verified_at\": null\n\
    \    }\n\
    \  },\n\
    \  \"author\": {\n\
    \    \"login\": \"octocat\",\n\
    \    \"id\": 1,\n\
    \    \"node_id\": \"MDQ6VXNlcjE=\",\n\
    \    \"avatar_url\": \"https://github.com/images/error/octocat_happy.gif\",\n\
    \    \"gravatar_id\": \"\",\n\
    \    \"url\": \"https://api.github.com/users/octocat\",\n\
    \    \"html_url\": \"https://github.com/octocat\",\n\
    \    \"followers_url\": \"https://api.github.com/users/octocat/followers\",\n\
    \    \"following_url\": \
     \"https://api.github.com/users/octocat/following{/other_user}\",\n\
    \    \"gists_url\": \"https://api.github.com/users/octocat/gists{/gist_id}\",\n\
    \    \"starred_url\": \"https://api.github.com/users/octocat/starred{/owner}{/repo}\",\n\
    \    \"subscriptions_url\": \"https://api.github.com/users/octocat/subscriptions\",\n\
    \    \"organizations_url\": \"https://api.github.com/users/octocat/orgs\",\n\
    \    \"repos_url\": \"https://api.github.com/users/octocat/repos\",\n\
    \    \"events_url\": \"https://api.github.com/users/octocat/events{/privacy}\",\n\
    \    \"received_events_url\": \
     \"https://api.github.com/users/octocat/received_events\",\n\
    \    \"type\": \"User\",\n\
    \    \"site_admin\": false\n\
    \  },\n\
    \  \"committer\": {\n\
    \    \"login\": \"octocat\",\n\
    \    \"id\": 1,\n\
    \    \"node_id\": \"MDQ6VXNlcjE=\",\n\
    \    \"avatar_url\": \"https://github.com/images/error/octocat_happy.gif\",\n\
    \    \"gravatar_id\": \"\",\n\
    \    \"url\": \"https://api.github.com/users/octocat\",\n\
    \    \"html_url\": \"https://github.com/octocat\",\n\
    \    \"followers_url\": \"https://api.github.com/users/octocat/followers\",\n\
    \    \"following_url\": \
     \"https://api.github.com/users/octocat/following{/other_user}\",\n\
    \    \"gists_url\": \"https://api.github.com/users/octocat/gists{/gist_id}\",\n\
    \    \"starred_url\": \"https://api.github.com/users/octocat/starred{/owner}{/repo}\",\n\
    \    \"subscriptions_url\": \"https://api.github.com/users/octocat/subscriptions\",\n\
    \    \"organizations_url\": \"https://api.github.com/users/octocat/orgs\",\n\
    \    \"repos_url\": \"https://api.github.com/users/octocat/repos\",\n\
    \    \"events_url\": \"https://api.github.com/users/octocat/events{/privacy}\",\n\
    \    \"received_events_url\": \
     \"https://api.github.com/users/octocat/received_events\",\n\
    \    \"type\": \"User\",\n\
    \    \"site_admin\": false\n\
    \  },\n\
    \  \"parents\": [\n\
    \    {\n\
    \      \"url\": \
     \"https://api.github.com/repos/octocat/Hello-World/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\
    \      \"sha\": \"6dcb09b5b57875f334f61aebed695e2e4193db5e\"\n\
    \    }\n\
    \  ],\n\
    \  \"stats\": {\n\
    \    \"additions\": 104,\n\
    \    \"deletions\": 4,\n\
    \    \"total\": 108\n\
    \  },\n\
    \  \"files\": [\n\
    \    {\n\
    \      \"filename\": \"file1.txt\",\n\
    \      \"additions\": 10,\n\
    \      \"deletions\": 2,\n\
    \      \"changes\": 12,\n\
    \      \"status\": \"modified\",\n\
    \      \"raw_url\": \
     \"https://github.com/octocat/Hello-World/raw/7ca483543807a51b6079e54ac4cc392bc29ae284/file1.txt\",\n\
    \      \"blob_url\": \
     \"https://github.com/octocat/Hello-World/blob/7ca483543807a51b6079e54ac4cc392bc29ae284/file1.txt\",\n\
    \      \"patch\": \"@@ -29,7 +29,7 @@\n\
     .....\"\n\
    \    }\n\
    \  ]\n\
     }\n"

let github_commit_invalid_json =
  ref
    "{\n\
    \  \"url\": \
     \"https://api.github.com/repos/octocat/Hello-World/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\
    \  \"node_id\": \
     \"MDY6Q29tbWl0NmRjYjA5YjViNTc4NzVmMzM0ZjYxYWViZWQ2OTVlMmU0MTkzZGI1ZQ==\",\n\
    \  \"html_url\": \
     \"https://github.com/octocat/Hello-World/commit/6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\
    \  \"comments_url\": \
     \"https://api.github.com/repos/octocat/Hello-World/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e/comments\",\n\
    \  \"commit\": {\n\
    \    \"url\": \
     \"https://api.github.com/repos/octocat/Hello-World/git/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\
    \    \"author\": {\n\
    \      \"name\": \"Monalisa Octocat\",\n\
    \      \"email\": \"mona@github.com\",\n\
    \      \"date\": \"2011-04-14T16:00:49Z\"\n\
    \    },\n\
    \    \"committer\": {\n\
    \      \"name\": \"Monalisa Octocat\",\n\
    \      \"email\": \"mona@github.com\",\n\
    \      \"date\": \"2011-04-14T16:00:49Z\"\n\
    \    },\n\
    \    \"message\": \"Fix all the bugs\",\n\
    \    \"tree\": {\n\
    \      \"url\": \
     \"https://api.github.com/repos/octocat/Hello-World/tree/6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\
    \      \"sha\": \"6dcb09b5b57875f334f61aebed695e2e4193db5e\"\n\
    \    },\n\
    \    \"comment_count\": 0,\n\
    \    \"verification\": {\n\
    \      \"verified\": false,\n\
    \      \"reason\": \"unsigned\",\n\
    \      \"signature\": null,\n\
    \      \"payload\": null,\n\
    \      \"verified_at\": null\n\
    \    }\n\
    \  },\n\
    \  \"author\": {\n\
    \    \"login\": \"octocat\",\n\
    \    \"id\": 1,\n\
    \    \"node_id\": \"MDQ6VXNlcjE=\",\n\
    \    \"avatar_url\": \"https://github.com/images/error/octocat_happy.gif\",\n\
    \    \"gravatar_id\": \"\",\n\
    \    \"url\": \"https://api.github.com/users/octocat\",\n\
    \    \"html_url\": \"https://github.com/octocat\",\n\
    \    \"followers_url\": \"https://api.github.com/users/octocat/followers\",\n\
    \    \"following_url\": \
     \"https://api.github.com/users/octocat/following{/other_user}\",\n\
    \    \"gists_url\": \"https://api.github.com/users/octocat/gists{/gist_id}\",\n\
    \    \"starred_url\": \"https://api.github.com/users/octocat/starred{/owner}{/repo}\",\n\
    \    \"subscriptions_url\": \"https://api.github.com/users/octocat/subscriptions\",\n\
    \    \"organizations_url\": \"https://api.github.com/users/octocat/orgs\",\n\
    \    \"repos_url\": \"https://api.github.com/users/octocat/repos\",\n\
    \    \"events_url\": \"https://api.github.com/users/octocat/events{/privacy}\",\n\
    \    \"received_events_url\": \
     \"https://api.github.com/users/octocat/received_events\",\n\
    \    \"type\": \"User\",\n\
    \    \"site_admin\": false\n\
    \  },\n\
    \  \"committer\": {\n\
    \    \"login\": \"octocat\",\n\
    \    \"id\": 1,\n\
    \    \"node_id\": \"MDQ6VXNlcjE=\",\n\
    \    \"avatar_url\": \"https://github.com/images/error/octocat_happy.gif\",\n\
    \    \"gravatar_id\": \"\",\n\
    \    \"url\": \"https://api.github.com/users/octocat\",\n\
    \    \"html_url\": \"https://github.com/octocat\",\n\
    \    \"followers_url\": \"https://api.github.com/users/octocat/followers\",\n\
    \    \"following_url\": \
     \"https://api.github.com/users/octocat/following{/other_user}\",\n\
    \    \"gists_url\": \"https://api.github.com/users/octocat/gists{/gist_id}\",\n\
    \    \"starred_url\": \"https://api.github.com/users/octocat/starred{/owner}{/repo}\",\n\
    \    \"subscriptions_url\": \"https://api.github.com/users/octocat/subscriptions\",\n\
    \    \"organizations_url\": \"https://api.github.com/users/octocat/orgs\",\n\
    \    \"repos_url\": \"https://api.github.com/users/octocat/repos\",\n\
    \    \"events_url\": \"https://api.github.com/users/octocat/events{/privacy}\",\n\
    \    \"received_events_url\": \
     \"https://api.github.com/users/octocat/received_events\",\n\
    \    \"type\": \"User\",\n\
    \    \"site_admin\": false\n\
    \  },\n\
    \  \"parents\": [\n\
    \    {\n\
    \      \"url\": \
     \"https://api.github.com/repos/octocat/Hello-World/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e\",\n\
    \      \"sha\": \"6dcb09b5b57875f334f61aebed695e2e4193db5e\"\n\
    \    }\n\
    \  ],\n\
    \  \"stats\": {\n\
    \    \"additions\": 104,\n\
    \    \"deletions\": 4,\n\
    \    \"total\": 108\n\
    \  },\n\
    \  \"files\": [\n\
    \    {\n\
    \      \"filename\": \"file1.txt\",\n\
    \      \"additions\": 10,\n\
    \      \"deletions\": 2,\n\
    \      \"changes\": 12,\n\
    \      \"status\": \"modified\",\n\
    \      \"raw_url\": \
     \"https://github.com/octocat/Hello-World/raw/7ca483543807a51b6079e54ac4cc392bc29ae284/file1.txt\",\n\
    \      \"blob_url\": \
     \"https://github.com/octocat/Hello-World/blob/7ca483543807a51b6079e54ac4cc392bc29ae284/file1.txt\",\n\
    \      \"patch\": \"@@ -29,7 +29,7 @@\n\
     .....\"\n\
    \    }\n\
    \  ]\n\
     }\n"

let test_commit_summaries () =
  let open Commit_scraper.Github_commit_j in
  let summaries = commit_summaries_of_string !list_commits_json in
  Alcotest.(check int) "should have 1 commit summary" 1 (List.length summaries)

let test_commit_summaries_invalid_json () =
  let open Commit_scraper.Github_commit_j in
  match commit_summaries_of_string !list_commits_invalid_json with
  | _ -> Alcotest.fail "Expected parsing to fail, but it succeeded"
  | exception _ -> ()

let test_commit_details () =
  let open Commit_scraper.Github_commit_j in
  let commit = github_commit_of_string !github_commit in
  Alcotest.(check string)
    "should have correct sha" "6dcb09b5b57875f334f61aebed695e2e4193db5e" commit.sha;
  Alcotest.(check string)
    "should have correct author name" "Monalisa Octocat" commit.commit.author.name

let test_commit_details_invalid_json () =
  let open Commit_scraper.Github_commit_j in
  match github_commit_of_string !github_commit_invalid_json with
  | _ -> Alcotest.fail "Expected parsing to fail, but it succeeded"
  | exception _ -> ()

let () =
  let open Alcotest in
  run "Commit Scraper Tests"
    [
      ( "Commit Summaries",
        [
          test_case "Test Commit Summaries" `Quick test_commit_summaries;
          test_case "Test Commit Summaries Invalid JSON" `Quick
            test_commit_summaries_invalid_json;
        ] );
      ( "Commit Details",
        [
          test_case "Test Commit Details" `Quick test_commit_details;
          test_case "Test Commit Details Invalid JSON" `Quick
            test_commit_details_invalid_json;
        ] );
    ]
