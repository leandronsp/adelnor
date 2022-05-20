# Adelnor

A dead simple, yet Rack-compatible, HTTP server written in Ruby

## Using make

```bash
make help
```
Output:
```
Usage: make <target>
  help                       Prints available commands
  sample.server              Runs a sample server in the port 3000
  bundle.install             Installs the Ruby gems
  bash                       Creates a container Bash
  run.tests                  Runs Unit tests
  gem.publish                Publishes the gem to https://rubygems.org (auth required)
  gem.yank                   Removes a specific version from the Rubygems
```

## Running a sample server in development

```bash
make bundle.install
make sample.server
```

Open `http://localhost:3000`

## Publishing the gem

```bash
make gem.publish version=0.0.4
```

## Yanking (deleting) a specific version

```bash
make gem.yank version=0.0.3
```
