UPDO_TMP ?= .updo

define COPY_CONSTRAINTS =
mkdir -p $(dir $(UPDO_TMP)/ghc-$*) && cp $$CONSTRAINT_FILE $@
endef

define COPY_SOURCE_PKGS =
mkdir -p $(dir $(UPDO_TMP)/ghc-$*) && cp $$SOURCE_PKGS_FILE $@
endef

$(UPDO_TMP)/ghc-%/constraints.dhall:
	[ -e project-dhall/ghc-$*/constraints.dhall ] \
		&& export CONSTRAINT_FILE=project-dhall/ghc-$*/constraints.dhall \
		|| export CONSTRAINT_FILE=./updo/empty/constraints.dhall
	$(COPY_CONSTRAINTS)

$(UPDO_TMP)/ghc-%/deps-external.dhall:
	[ -e project-dhall/ghc-$*/deps-external.dhall ] \
		&& export SOURCE_PKGS_FILE=project-dhall/ghc-$*/deps-external.dhall \
		|| export SOURCE_PKGS_FILE=./updo/empty/source-pkgs.dhall
	$(COPY_SOURCE_PKGS)

$(UPDO_TMP)/ghc-%/deps-internal.dhall:
	[ -e project-dhall/ghc-$*/deps-internal.dhall ] \
		&& export SOURCE_PKGS_FILE=project-dhall/ghc-$*/deps-internal.dhall \
		|| export SOURCE_PKGS_FILE=./updo/empty/source-pkgs.dhall
	$(COPY_SOURCE_PKGS)

$(UPDO_TMP)/ghc-%/forks-external.dhall:
	[ -e project-dhall/ghc-$*/forks-internal.dhall ] \
		&& export SOURCE_PKGS_FILE=project-dhall/ghc-$*/forks-internal.dhall \
		|| export SOURCE_PKGS_FILE=./updo/empty/source-pkgs.dhall
	$(COPY_SOURCE_PKGS)

$(UPDO_TMP)/ghc-%/forks-internal.dhall:
	[ -e project-dhall/ghc-$*/forks-internal.dhall ] \
		&& export SOURCE_PKGS_FILE=project-dhall/ghc-$*/forks-internal.dhall \
		|| export SOURCE_PKGS_FILE=./updo/empty/source-pkgs.dhall
	$(COPY_SOURCE_PKGS)

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
