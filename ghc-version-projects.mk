# Project (and related sha256map) files used in production, not in GHC upgrade.
.PHONY: projects
projects: \
  ghc-$(GHC_VERSION).sha256map.nix \
  stack.yaml \
  stack.yaml.lock \
  cabal.project

cabal.project: ghc-$(GHC_VERSION).$(CABAL_VIA).project
	cp $^ $@

stack.yaml: ghc-$(GHC_VERSION).$(STACK_VIA).yaml
	cp $< $@

stack.yaml.lock: stack.yaml
	stack build --test --no-run-tests --bench --no-run-benchmarks --dry-run --stack-yaml $<
