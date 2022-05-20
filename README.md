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
make gem.publish version=0.0.4
```

## Yanking (deleting) a specific version

```bash
make gem.yank version=0.0.3
```
