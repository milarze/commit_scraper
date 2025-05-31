# Commit Scraper

This is a simple tool to extract commit messages from a Github repository.
It uses the Github API to fetch commit messages and diffs and stores themin
a JSON file at the path given.

## Installation

Requires OCaml and Dune to be installed.

Pull the repository:

```bash
git clone https://github.com/milarze/commit_scraper.git
```

Navigate to the directory:

```bash
cd commit_scraper
```

Install the dependencies:

```bash
opam install -y . --deps-only
```

Build the project:

```bash
dune build
```

The executable will be available at `_build/install/default/bin/commit_scraper.exe`.

Copy the executable to a directory in your PATH:

```bash
cp _build/install/default/bin/commit_scraper.exe /usr/local/bin/commit_scraper
```

## Usage

Requires a Github Personal Access token with access to read the target
repository.

The tool automatically writes a JSONL file with commit messages and diffs
to a sub-directory in the current directory, following the format:
`./<owner>/<repo>_commits.jsonl`

```bash
commit_scraper --repo <owner/repo> --token <token>
```

### Using Specific Output File

You can specify a different output file using the `--output` option:

```bash
commit_scraper --repo <owner/repo> --token <token> --output <output_file>
```
