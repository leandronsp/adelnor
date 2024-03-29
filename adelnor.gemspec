# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name        = 'adelnor'
  spec.version     = '0.0.8'
  spec.summary     = 'Adelnor HTTP server'
  spec.description = 'A dead simple, yet Rack-compatible, HTTP server written in Ruby'
  spec.authors     = ['Leandro Proença']
  spec.email       = 'leandronsp@gmail.com'
  spec.files       = Dir['lib/**/*'] + %w[Gemfile Gemfile.lock README.md adelnor.gemspec]
  spec.homepage    = 'https://github.com/leandronsp/adelnor'
  spec.license     = 'MIT'

  spec.add_runtime_dependency 'async', '~> 2.6'
  spec.add_runtime_dependency 'rack', '~> 2.2'

  spec.required_ruby_version = '~> 3.0'
end
