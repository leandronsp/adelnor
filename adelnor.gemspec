Gem::Specification.new do |spec|
  spec.name        = 'adelnor'
  spec.version     = '0.0.2'
  spec.summary     = 'Adelnor HTTP server'
  spec.description = 'A dead simple, yet Rack-compatible, HTTP server written in Ruby'
  spec.authors     = ['Leandro Proença']
  spec.email       = 'leandronsp@gmail.com'
  spec.files       = Dir['lib/**/*'] + %w(Gemfile Gemfile.lock README.md adelnor.gemspec)
  spec.homepage    = 'https://github.com/leandronsp/adelnor'
  spec.license     = 'MIT'
end
