SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

UPDO_TMP ?= .updo

define COPY_CONSTRAINTS =
mkdir -p $(dir $(UPDO_TMP)/ghc-$*)
if [ -e $< ]; then
  cp $< $@
else
  cp ./updo/empty/constraints.dhall $@
fi
endef

$(UPDO_TMP)/ghc-%/constraints.dhall: project-dhall/ghc-%/constraints.dhall; $(COPY_CONSTRAINTS)

define COPY_SOURCE_PKGS =
mkdir -p $(dir $(UPDO_TMP)/ghc-$*)
if [ -e $< ]; then
  cp $< $@
else
  cp ./updo/empty/source-pkgs.dhall $@
fi
endef

$(UPDO_TMP)/ghc-%/deps-external.dhall: project-dhall/ghc-%/deps-external.dhall; $(COPY_SOURCE_PKGS)
$(UPDO_TMP)/ghc-%/deps-internal.dhall: project-dhall/ghc-%/deps-internal.dhall; $(COPY_SOURCE_PKGS)
$(UPDO_TMP)/ghc-%/forks-external.dhall: project-dhall/ghc-%/forks-external.dhall; $(COPY_SOURCE_PKGS)
$(UPDO_TMP)/ghc-%/forks-internal.dhall: project-dhall/ghc-%/forks-internal.dhall; $(COPY_SOURCE_PKGS)

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
