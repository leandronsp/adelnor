# adelnor

![rubygems](https://badgen.net/rubygems/n/adelnor)
![rubygems](https://badgen.net/rubygems/v/adelnor/latest)
![rubygems](https://badgen.net/rubygems/dt/adelnor)

![Build](https://github.com/leandronsp/adelnor/actions/workflows/build.yml/badge.svg)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-community-brightgreen.svg)](https://rubystyle.guide)
```
     ___       _______   _______  __      .__   __.   ______   .______      
    /   \     |       \ |   ____||  |     |  \ |  |  /  __  \  |   _  \     
   /  ^  \    |  .--.  ||  |__   |  |     |   \|  | |  |  |  | |  |_)  |    
  /  /_\  \   |  |  |  ||   __|  |  |     |  . `  | |  |  |  | |      /     
 /  _____  \  |  '--'  ||  |____ |  `----.|  |\   | |  `--'  | |  |\  \----.
/__/     \__\ |_______/ |_______||_______||__| \__|  \______/  | _| `._____|
```

[adelnor](https://rubygems.org/gems/adelnor) is a dead simple, yet Rack-compatible, HTTP server written in Ruby.

## Requirements

Ruby

## Installation
```bash
$ gem install adelnor
```

## Development tooling

Make and Docker

## Using make

```bash
$ make help
```
Output:
```
Usage: make <target>
  help                       Prints available commands
  sample.server              Runs a sample server in the port 3000
  bundle.install             Installs the Ruby gems
  bash                       Creates a container Bash
  run.tests                  Runs Unit tests
  rubocop                    Runs code linter
  ci                         Runs Unit tests in CI
  gem.publish                Publishes the gem to https://rubygems.org (auth required)
  gem.yank                   Removes a specific version from the Rubygems
```

## Running a sample server in development

```bash
$ make bundle.install
$ make sample.server
```

## Handling concurrency

Currently Adelnor allows to run the server using different concurrency strategies, one at a time.

```ruby
require './lib/adelnor/server'

app = -> (env) do
  [200, { 'Content-Type' => 'text/html' }, 'Hello world!']
end

# Threaded mode
Adelnor::Server.run app, 3000, thread_pool: 5

# Clusterd mode (forking)
Adelnor::Server.run app, 3000, workers: 2

# Async mode
Adelnor::Server.run app, 3000, async: true
```

Open `http://localhost:3000`
