SHELL = /bin/bash
.ONESHELL:
.DEFAULT_GOAL: help

help: ## Prints available commands
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[.a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

sample.server: ## Runs a sample server in the port 3000
	@docker-compose run \
		--rm \
		--service-ports \
		ruby \
		ruby sample-app/run

bundle.install: ## Installs the Ruby gems
	@docker-compose run --rm ruby bundle install

bash: ## Creates a container Bash
	@docker-compose run --rm ruby bash

run.tests: ## Runs Unit tests
	@docker-compose run --rm ruby ruby -Itest test/all.rb

ci: ## Runs Unit tests in CI
	bundle lock --add-platform x86_64-linux
	bundle install
	ruby -Itest test/all.rb

##### Gem #####
gem.publish: ## Publishes the gem to https://rubygems.org (auth required)
	@docker-compose run \
		--rm \
		ruby \
		bash -c "bin/gem-publish ${version}"

gem.yank: ## Removes a specific version from the Rubygems
	@docker-compose run \
		--rm \
		ruby \
		bash -c "bin/gem-yank ${version}"
