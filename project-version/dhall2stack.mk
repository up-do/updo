config-version: \
  $(UPDO_TMP)/ghc-$(GHC_VERSION)/constraints.dhall \
  $(UPDO_TMP)/ghc-$(GHC_VERSION)/deps-external.dhall \
  $(UPDO_TMP)/ghc-$(GHC_VERSION)/deps-internal.dhall \
  $(UPDO_TMP)/ghc-$(GHC_VERSION)/forks-external.dhall \
  $(UPDO_TMP)/ghc-$(GHC_VERSION)/forks-internal.dhall

define LET_FN_SNIPPET =
"let f = project-dhall/ghc-$(GHC_VERSION)/snippet.dhall ? updo/project-skeleton/ghc-x.y.z/stack-snippet.dhall in f $(STACKAGE_VERSION) "
endef

ghc-$(GHC_VERSION).dhall2stack.yaml: \
  updo/project-skeleton/ghc-x.y.z/text-templates/dhall2stack.dhall \
  $(UPDO_TMP)/pkgs-sorted.dhall \
  config-version \
  updo/text-templates/stack/*.dhall
	echo '(./$< ./$(UPDO_TMP)/pkgs-sorted.dhall "$(STACKAGE_VERSION)")' \
  | dhall text \
  | xargs $(LET_FN_SNIPPET) \
  | dhall text --output $@
