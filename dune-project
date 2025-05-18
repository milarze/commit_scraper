(lang dune 3.17)

(name commit_scraper)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Ezra Lim")

(maintainers "Ezra Lim")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name commit_scraper)
 (synopsis "Scrape commit messages and diffs from a repository in Github")
 (description "Use the Github API to extract commit messages and diffs from a repository. The resulting data can be used for training a model to generate commit messages.")
 (depends
  (ocaml (>= 4.14.0))
  (lwt (>= 5.0.0))
  (cohttp (>= 4.0.0))
  (cohttp-lwt-unix (>= 4.0.0))
  (tls-lwt (>= 2.0.1))
  (yojson (>= 1.7.0))
  (alcotest :with-test))
 (tags
  ("commit"
   "scraper"
   "github"
   "api"
   "diffs")))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
