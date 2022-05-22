# adelnor

![rubygems](https://badgen.net/rubygems/n/adelnor)
![rubygems](https://badgen.net/rubygems/v/adelnor/latest)
![rubygems](https://badgen.net/rubygems/dt/adelnor)

![Build](https://github.com/leandronsp/adelnor/actions/workflows/build.yml/badge.svg)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-community-brightgreen.svg)](https://rubystyle.guide)
```            .___     .__
_____     __| _/____ |  |   ____   ___________
\__  \   / __ |/ __ \|  |  /    \ /  _ \_  __ \
 / __ \_/ /_/ \  ___/|  |_|   |  (  <_> )  | \/
(____  /\____ |\___  >____/___|  /\____/|__|
     \/      \/    \/          \/
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

Open `http://localhost:3000`
