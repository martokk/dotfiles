SHELL=/bin/sh
LOCAL_REPO := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

# route profile=core
ifeq ($(profile), core)
	PROFILE_PATHS := ./core

# route profile=dev
else ifeq ($(profile), dev)
	PROFILE_PATHS := ./core ./dev

# route profile=server

# route profile=linux
else
	PROFILE_PATHS := ./core ./dev ./linux
endif

EXCLUSIONS := README.md .gitignore Makefile
CANDIDATES := $(shell find $(PROFILE_PATHS) -not -path "*/.git/*" -not -name ".*swp" -type f | cut -d '/' -f 2- )
DOTFILES := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL := help


list:
	@echo '--------------------------------- '
	@echo ' MAKE LIST (*SIMULATED)                       '
	@echo '--------------------------------- '
	@echo '  PROFILE: $(profile)             '
	@echo '  LOCAL_REPO: ${LOCAL_REPO}       '
	@echo '  PROFILE_PATHS: ${PROFILE_PATHS} '
	@echo '--------------------------------- '

	@# @$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)


	@echo '   SOURCE FILE      ->      SYMLINK (*SIMULATED) '
	@$(foreach val, $(DOTFILES), echo $(val)'   -->   $(HOME)/'$(shell echo $(val) | cut -d '/' -f 2- );)
	@# @$(foreach val, $(DOTFILES), echo $(HOME)/$(shell echo $(val) | cut -d '/' -f 2- )'   -->   '$(val);)

install: clean ## Create symlink to home directory
	@echo '--------------------------------- '
	@echo ' MAKE INSTALL                     '
	@echo '--------------------------------- '
	@echo '  PROFILE: $(profile)             '
	@echo '  LOCAL_REPO: ${LOCAL_REPO}       '
	@echo '  PROFILE_PATHS: ${PROFILE_PATHS} '
	@echo '--------------------------------- '
	@echo '   SYMLINK      ->      SOURCE FILE '

	# Create Symlinks
	@$(foreach val, $(DOTFILES), mkdir -p $$(dirname $(HOME)/$(shell echo $(val) | cut -d '/' -f 2- )); ln -sfnv $(abspath $(val)) $(HOME)/$(shell echo $(val) | cut -d '/' -f 2- );)

	# Refresh Font Cache
	fc-cache -f

clean: ## Remove the dot files and this repo
	@echo 'Remove dot files in your home directory...'
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(shell echo $(val) | cut -d '/' -f 2- );)

remove: clean
	@echo 'Remove local repo...'
	-rm -rf $(DOTPATH)

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


