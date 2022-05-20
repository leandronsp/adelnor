# Adelnor

A dead simple, yet Rack-compatible, HTTP server written in Ruby

## Running a sample server in development

```bash
make bundle.install
make sample.server
```

Open `http://localhost:3000`

## Publishing the gem

```bash
make gem.build
make gem.install    # locally
make gem.signin     # sign in to rubygems.org using owner credentials
make gem.push       # push gem to rubygems.org
```
