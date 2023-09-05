docker_run=docker-compose run --rm

default: help

.PHONY: build

help: ## Show this help
	@echo "Targets:"
	@fgrep -h "##" $(MAKEFILE_LIST) | grep ":" | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/\(.*\):.*##[ \t]*/    \1 ## /' | sort | column -t -s '##'
	@echo

build: ## Build docker image
	docker-compose build --no-cache

build-jar: ## Build application
	$(docker_run) --entrypoint="bash gradlew build" app

up-pubsub-emulator: ## Start pubsub emulator
	docker-compose up -d pubsub-emulator

up: ## Build and start containers
	docker-compose up -d --build

down: ## Stop containers and remove them
	docker-compose down

start: ## Start existing containers
	docker-compose start

stop: ## Stop containers
	docker-compose stop

restart: down up ## Restart containers

test: ## Run tests
	$(docker_run) \
		-e SPRING_PROFILES_ACTIVE=test \
		--entrypoint="bash gradlew build test" \
		app

test-ci: ## Run tests in CI
	$(docker_run) \
		-e SPRING_PROFILES_ACTIVE=test \
		-v /tmp:/code/build \
		-v /tmp:/code/.gradle \
		--entrypoint="bash gradlew build test jacocoTestCoverageVerification" \
		app

sh: ## Run shell in new container
	$(docker_run) --entrypoint="bash" app

ssh: ## Run shell in running container
	docker-compose exec app bash

logs: ## Show logs
	docker-compose logs -f app
