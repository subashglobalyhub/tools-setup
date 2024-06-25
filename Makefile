SHELL := /bin/bash

.DEFAULT_GOAL := help

docker-install: ## Install dependencies for the scanner
	@bash scripts/docker-install-setup.sh

other-install: ## Upload the scanned results.
	@bash scripts/other-install.sh

custom-task-arg: ## Upload the scanned results.
	@bash scripts/new-custom-task.sh $(ARGS)

tools-upgrade: ## Upgrade the scanner.
	@bash scripts/upgrade-install.sh

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@awk -F ':.*?## ' '/^[a-zA-Z0-9_-]+:.*?##/ {printf "  \033[1;32m%-20s\033[0m :  %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo -e "\033[1;31mNOTE: Please run every option starting with 'make'\033[0m"
	@echo -e "\033[1;34m E.g. make docker-install\033[0m"
	@echo ""

	@echo "support and contact details"
	@echo "Mail : subash.chaudhary@globalyhub.com""
	@echo "Phone: +977 9823827047"  