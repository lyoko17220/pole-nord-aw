PROJECT_NAME 	= polenordinfo
SITE_PATH 		= www/

# set binary
docker-compose 	= docker-compose -f config/docker/docker-compose.yml -p $(PROJECT_NAME)
hugo = $(docker-compose) run --rm hugo


.DEFAULT_GOAL := help
.PHONY: help install uninstall reinstall build up start stop rm pull ps logs go

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: pull up ## Install project for the first time

uninstall: stop rm ## Uninstall project

reinstall: uninstall install ## Reinstall project

up: ## (Re-)Create containers
	@$(docker-compose) up -d --remove-orphans

start: ## Start containers
	@$(docker-compose) start $(container)

stop: ## Stop containers
	@$(docker-compose) stop $(container)

rm: ## Remove containers
	@$(docker-compose) rm -v $(container)

pull: ## Update containers
	@$(docker-compose) pull $(container)

ps: ## List containers status
	@$(docker-compose) ps $(container)

logs: ## Show containers logs
	@$(docker-compose) logs -f $(container)

go: ## Start container terminal
	docker exec -ti $(PROJECT_NAME)_$(container)_1 /bin/bash

build: ## Build containers
	@$(docker-compose) build