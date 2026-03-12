# How are we going to generate stack.yaml and stack.yaml.lock files?
#
# Choices are:
#  - dhall2stack = via a temporary ghc-x.y.z.dhall2stack.yaml
#  - dhall2yaml2stack = via a temporary ghc-x.y.z.dhall2yaml2stack.yaml
STACK_VIA ?= dhall2stack

# How are we going to generate the cabal.project file?
#
# Choices are:
#  - dhall2config = via a temporary ghc-x.y.z.dhall2config.project
#  - dhall2cabal = via a temporary ghc-x.y.z.dhall2cabal.project
#
# dhall2config is good when upgrading to a new GHC version. The
# <pkg-group>.config files will show how many in a group are yet to be upgraded.
# With the cabal imports it is possible to try things out quickly by editing the
# config files themselves if you want to momentarily sidestep Updo's make cabal
# project generation.
#
# dhall2cabal is good if you want the cabal project to closely match the layout
# of the stack project when that is generated using dhall2stack.

# dhall2cabal is also good if you need to use cabal < 3.8 where everything needs
# to be in one file. To achieve this, the
# project-dhall/project-dhall2cabal.dhall template will need to bring in the
# contents of the stackage import like this:
#
# ${../../project-stackage/$(STACKAGE_VERSION).config as Text}
CABAL_VIA ?= dhall2config

# Updo Dhall gives us these targets:
#  - dhall2stack-projects
#  - dhall2cabal-projects
#  - dhall2config-projects
#  - project-sha256maps
include updo/temp/Makefile
include updo/project-skeleton/Makefile
include updo/project-dhall/dhall2config.mk
include updo/project-version/dhall2stack.mk
include updo/project-version/dhall2cabal.mk
include updo/project-version/dhall2config.mk
include updo/project-nix/Makefile
include updo/ghc-version-projects.mk
ifneq ($(GHC_UPGRADE),)
ifeq ($(GHC_VERSION),$(GHC_UPGRADE))
$(warning GHC_VERSION=$(GHC_VERSION))
$(warning GHC_UPGRADE=$(GHC_UPGRADE))
$(warning If these variables were allowed to be equal, we would see pairs of warnings:)
$(warning - warning: overriding recipe for target)
$(warning - warning: ignoring old recipe for target)
$(warning GHC_UPGRADE can be undefined and should be undefined when upgrading is finished.)
$(error Targets are not distinct)
endif
include updo/project-upgrade/dhall2stack.mk
include updo/project-upgrade/dhall2cabal.mk
include updo/project-upgrade/dhall2config.mk
include updo/ghc-upgrade-projects.mk
endif

.PHONY: clean
clean:
	rm -f \
	  ghc-*.stack.* \
	  ghc-*.dhall2config.* \
	  ghc-*.dhall2cabal.* \
	  ghc-*.dhall2stack.* \
	  ghc-*.stack2cabal.* \
	  ghc-*.cabal2stack.* \
	  ghc-*.dhall2yaml2stack.* \
	  ghc-*.sha256map.nix

# Generating a ghc-x.y.z prefixed stack lock file is the same recipe for all GHC
# versions, irrespective of whether it is an upgrade project or not.
ghc-%.dhall2stack.yaml.lock: ghc-%.dhall2stack.yaml
	stack build  --test --no-run-tests --bench --no-run-benchmarks --dry-run --stack-yaml $<
	