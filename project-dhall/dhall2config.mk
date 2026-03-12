ifeq ($(PKG_GROUPS_HS_EXE), true)
PKG_GROUPS_HS := updo-pkg-groups
else
PKG_GROUPS_HS := ./updo/project-dhall/pkg-groups.hs
endif

project-cabal/pkgs.config: \
  updo/text-templates/cabal/pkg-groups.dhall \
  project-dhall/pkg-groups.dhall \
  $(patsubst project-dhall/pkgs/%.dhall, project-cabal/pkgs/%.config, $(wildcard project-dhall/pkgs/*.dhall))
  ifeq ($(CABAL_RELATIVITY), ImportRelative)
	echo 'let f = ./updo/types/CabalRelativity.dhall in ./$< f.CabalImportRelative ./project-dhall/pkg-groups.dhall' | dhall text --output $@
  else
	echo 'let f = ./updo/types/CabalRelativity.dhall in ./$< f.CabalProjectRelative ./project-dhall/pkg-groups.dhall' | dhall text --output $@
  endif

generate-pkg-configs: \
  project-dhall/pkg-groups.dhall \
  project-dhall/pkgs-upgrade-todo.dhall
  ifeq ($(CABAL_RELATIVITY), ImportRelative)
	mkdir -p project-cabal/pkgs && $(PKG_GROUPS_HS) "let f = ./updo/types/CabalRelativity.dhall in f.CabalImportRelative" "$(GHC_VERSION)" "$(GHC_UPGRADE)"
  else
	mkdir -p project-cabal/pkgs && $(PKG_GROUPS_HS) "let f = ./updo/types/CabalRelativity.dhall in f.CabalProjectRelative" "$(GHC_VERSION)" "$(GHC_UPGRADE)"
  endif

# Mirror packages (package groups) from dhall to config with
# generate-pkg-configs doing the work once for all package groups.
#
# The "target: prerequisites ;" explicitly defines an empty recipe.
# SEE: https://www.gnu.org/software/make/manual/html_node/Empty-Recipes.html
project-cabal/pkgs/%.config: project-dhall/pkgs/%.dhall generate-pkg-configs ;

# Mirror constraints from dhall to config. Any revisions in the constraints are
# stripped, like this for example:
# - hedgehog-quickcheck ==0.1.1@rev:4
# + hedgehog-quickcheck ==0.1.1
project-cabal/ghc-%/constraints.config: \
  updo/text-templates/cabal/package.dhall \
  $(UPDO_TMP)/ghc-%/constraints.dhall
	mkdir -p $(@D)
	mkdir -p $(UPDO_TMP)/ghc-$*
	echo "let f = ./$< in f.constraints ./$(UPDO_TMP)/ghc-$*/constraints.dhall" \
	| dhall text | sed -E "s/@(rev|sha256):.*$$//" >$(UPDO_TMP)/ghc-$*/constraints.config
	[ ! -s $(UPDO_TMP)/ghc-$*/constraints.config ] || cp $(UPDO_TMP)/ghc-$*/constraints.config $@

# Mirror source repositories from dhall to config.
project-cabal/ghc-%.config: \
  updo/text-templates/cabal/package.dhall \
  $(UPDO_TMP)/ghc-%.dhall
	mkdir -p $(@D)
	echo "let f = ./$< in f.repo-items ./$(UPDO_TMP)/ghc-$*.dhall" \
	| dhall text --output $(UPDO_TMP)/ghc-$*.config
	[ ! -s $(UPDO_TMP)/ghc-$*.config ] || cp $(UPDO_TMP)/ghc-$*.config $@
