# README

Ruby version:  2.4.2 (using rbenv)
Rails version: 5.1.4

## Instructions

### Dependencies
Docker

### Startup

1. Build the containers `docker-compose build`
2. Start the server in the background `bin/server`
3. Tail the logs `docker-compose logs -f`

### Shutdown

`bin/server` will fire up the containers in background mode so you'll need to run `docker-compose down` to shut everything down
