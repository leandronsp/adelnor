sample.server:
	@docker-compose run \
		--rm \
		--service-ports \
		ruby \
		ruby sample-app/run

bundle.install:
	@docker-compose run --rm ruby bundle install

bash:
	@docker-compose run --rm ruby bash

##### Gem #####
gem.build:
	@docker-compose run \
		--rm \
		ruby \
		gem build adelnor.gemspec

gem.install:
	@docker-compose run \
		--rm \
		ruby \
		gem install ./adelnor-0.0.1.gem

gem.signin:
	@docker-compose run \
		--rm \
		ruby \
		gem signin

gem.push:
	@docker-compose run \
		--rm \
		ruby \
		gem push adelnor-0.0.1.gem
