## Updo Docs

From the root of the repository, run:

### Watching

```
$ quarto preview docs
Preparing to preview

Watching files for changes
Browse at http://localhost:3054/
Listening on http://127.0.0.1:3054/
Opening in existing browser session.
GET: /
```

### Building

```
$ quarto render docs
[ 1/11] targets.qmd
[ 2/11] index.qmd
[ 3/11] install.qmd
[ 4/11] templates.qmd
[ 5/11] gotchas.qmd
[ 6/11] upgrade.qmd
[ 7/11] acks.qmd
[ 8/11] nix.qmd
[ 9/11] config.qmd
[10/11] boot.qmd
[11/11] clean.qmd

Output created: _site/index.html
```

### Deploying

```
$ git checkout main
... (make changes and commit on main)
$ quarto render docs
$ git checkout site
$ cp -a docs/_site/. .
... (commit changes brought over from main via copy from _site)
$ git push
```
