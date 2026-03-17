UPDO_TMP ?= .updo

$(UPDO_TMP)/ghc-%/constraints.dhall: project-dhall/ghc-%/constraints.dhall
	mkdir -p $(UPDO_TMP)/ghc-$*
	if [ -e ./project-dhall/ghc-$*/constraints.dhall ]; then
		cp ./project-dhall/ghc-$*/constraints.dhall $@
	else
		cp ./updo/empty/constraints.dhall $@
	fi

$(UPDO_TMP)/ghc-%.dhall: project-dhall/ghc-%.dhall
	mkdir -p $(dir $(UPDO_TMP)/ghc-$*)
	if [ -e ./project-dhall/ghc-$*.dhall ]; then
		cp ./project-dhall/ghc-$*.dhall $@
	else
		cp ./updo/empty/ghc-$*.dhall $@
	fi

.PHONY: pkgs-sorted
pkgs-sorted: $(UPDO_TMP)/pkgs-sorted.dhall

.PHONY: pkgs-upgrade-done
pkgs-upgrade-done: $(UPDO_TMP)/pkgs-upgrade-done.dhall

ifeq ($(PKGS_SORTED_HS_EXE), true)
PKGS_SORTED_HS := updo-pkgs-sorted
else
PKGS_SORTED_HS := ./updo/project-dhall/pkgs-sorted.hs
endif

$(UPDO_TMP)/pkgs-sorted.dhall: \
  project-dhall/pkg-groups.dhall \
  project-dhall/pkgs/*.dhall
	mkdir -p $(@D) && $(PKGS_SORTED_HS) > $@

$(UPDO_TMP)/pkgs-upgrade-done.dhall: \
  project-dhall/pkgs/*.dhall \
  $(UPDO_TMP)/pkgs-sorted.dhall \
  project-dhall/pkgs-upgrade-todo.dhall
	./updo/project-dhall/pkgs-upgrade-done.hs \
	  ./$(UPDO_TMP)/pkgs-sorted.dhall \
	  ./project-dhall/pkgs-upgrade-todo.dhall \
	  > $@
