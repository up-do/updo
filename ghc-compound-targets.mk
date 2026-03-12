.PHONY: cabal-projects
cabal: \
  ghc-$(GHC_VERSION).$(CABAL_VIA).project \
  ghc-$(GHC_UPGRADE).$(CABAL_VIA).project

.PHONY: stack-projects
stack: \
  ghc-$(GHC_VERSION).$(STACK_VIA).yaml \
  ghc-$(GHC_VERSION).$(STACK_VIA).yaml.lock \
  ghc-$(GHC_UPGRADE).$(STACK_VIA).yaml \
  ghc-$(GHC_UPGRADE).$(STACK_VIA).yaml.lock

.PHONY: dhall2cabal-projects
dhall2cabal-projects: \
  ghc-$(GHC_VERSION).dhall2cabal.project \
  ghc-$(GHC_UPGRADE).dhall2cabal.project

.PHONY: dhall2config-projects
dhall2config-projects: \
  ghc-$(GHC_VERSION).dhall2config.project \
  ghc-$(GHC_UPGRADE).dhall2config.project

.PHONY: dhall2stack-projects
dhall2stack-projects: \
  ghc-$(GHC_VERSION).dhall2stack.yaml \
  ghc-$(GHC_VERSION).dhall2stack.yaml.lock \
  ghc-$(GHC_UPGRADE).dhall2stack.yaml \
  ghc-$(GHC_UPGRADE).dhall2stack.yaml.lock

project-sha256maps: \
  ghc-$(GHC_VERSION).sha256map.nix \
  ghc-$(GHC_UPGRADE).sha256map.nix

# All the kinds of project files we might want to generate.
#
# These are alternative methods we could include but don't.
#  - dhall2yaml2stack-projects
.PHONY: all-possible-projects
all-possible-projects: \
  projects \
  dhall2config-projects \
  dhall2cabal-projects \
  dhall2stack-projects
