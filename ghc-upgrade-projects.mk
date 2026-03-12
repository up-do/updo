# Project (and related sha256map) files used in ongoing upgrade, not in production.
.PHONY: upgrade-projects
upgrade-projects: \
  project-nix/ghc-$(GHC_UPGRADE)/sha256map.nix \
  stack.upgrade.yaml \
  stack.upgrade.yaml.lock \
  cabal.upgrade.project \
  ghc-$(GHC_UPGRADE).dhall2stack.yaml \
  ghc-$(GHC_UPGRADE).dhall2stack.yaml.lock \
  ghc-$(GHC_UPGRADE).dhall2cabal.project

cabal.upgrade.project: ghc-$(GHC_UPGRADE).$(CABAL_VIA).project
	cp $^ $@

stack.upgrade.yaml: ghc-$(GHC_UPGRADE).$(STACK_VIA).yaml
	cp $< $@

stack.upgrade.yaml.lock: stack.upgrade.yaml
	stack build --test --no-run-tests --bench --no-run-benchmarks --dry-run --stack-yaml $<
