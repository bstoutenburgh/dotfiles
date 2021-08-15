.PHONY: help bootstrap bootstrap-check bootstrap-install desktop headless requirements
.DEFAULT_GOAL := help

# Shell that make should use
# Make changes to path persistent
# https://stackoverflow.com/a/13468229/13577666
SHELL := /bin/bash
PATH := $(PATH)

LOCAL_BIN = $(shell echo $$HOME/.local/bin)

# Source for conditional: https://stackoverflow.com/a/2741747/13577666
ifneq (,$(findstring $(LOCAL_BIN),$(PATH)))
	# Found: all set; do nothing, $(LOCAL_BIN) is on PATH
	PATH := $(PATH);
else
	# Not found: adding $(LOCAL_BIN) to PATH for this shell session
export PATH := $(LOCAL_BIN):$(PATH); @echo $(PATH)
endif

help:
# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
# adds anything that has a double # comment to the phony help list
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ".:*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'

bootstrap: ## Installs needed dependencies
bootstrap: bootstrap-install requirements

bootstrap-check: ## Check that PATH and requirements are correct
	@ansible --version | grep "python version"

bootstrap-install: ## Apt and python/pipx setups
	bash scripts/bootstrap.sh

desktop: ## Run the desktop playbook
	ansible-playbook --ask-become-pass desktop.yml --verbose

desktop-check: ## Run the desktop playbook with --check
	ansible-playbook --ask-become-pass desktop.yml --verbose --check

headless: ## Run the headless playbook
	ansible-playbook --ask-become-pass headless.yml --verbose

headless-check: ## Run the headless playbook with --check
	ansible-playbook --ask-become-pass headless.yml --verbose --check

requirements: ## Install ansible role/collection requirements
	ansible-galaxy install -r requirements-galaxy.yml
