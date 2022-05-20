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

run.tests:
	@docker-compose run --rm ruby ruby -Itest test/all.rb

##### Gem #####
gem.publish:
	@docker-compose run \
		--rm \
		ruby \
		bash -c "bin/gem-publish ${version}"

gem.yank:
	@docker-compose run \
		--rm \
		ruby \
		bash -c "bin/gem-yank ${version}"
