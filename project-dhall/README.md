# Updo Dhall

## Stack Project

A stack project is always one file, no imports are possible. The
`dhall2stack.mk` makefile targets are the project and its lock file.

* `ghc-x.y.z.dhall2stack.yaml`

## Cabal Project

The `dhall2cabal.mk` makefile has a target for the cabal project.

* `ghc-x.y.z.dhall2cabal.project`

## Cabal Project with Imports

The `dhall2config.mk` makefile has a target for the cabal project with imports.

* `ghc-x.y.z.dhallconfig.project`

This project file is mostly imports of `.config` files generated from the
`.dhall` configuration, something like:

```
import: project-stackage/stackage-resolver.config

import: project-cabal/pkgs.config

import: project-cabal/ghc-x.y.z/constraints.config
import: project-cabal/ghc-x.y.z/deps-external.config
import: project-cabal/ghc-x.y.z/deps-internal.config
import: project-cabal/ghc-x.y.z/forks-external.config
import: project-cabal/ghc-x.y.z/forks-internal.config

build-info: True
```

For this rule using `make --jobs`[^parallel-make] will speed up the recipe a
lot.

[^parallel-make]: https://www.gnu.org/software/make/manual/html_node/Parallel.html
