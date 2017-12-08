# Listing docker and compose commands here for future reference

## Command list

1. `docker-compose build` - rebuilds the container after changes to Gemfile or Dockerfile
2. `docker-compose up -d` - boot up the app in background
  1. `docker-compose up --build` - boot up the container but rebuild it first
3. `docker-compose run web rails db:create` - run `rails db:create` inside the `web` container
4. `docker-compose down` - shut down the app containers
5. `docker-compose logs -f` - tail the logs

## Rebuilding the app

`docker-compose build` or `docker-compose up --build` will do a rebuild to sync up changes to Gemfile or Dockerfile.

Sometimes you'll want to run `docker-compose run web rails db:create` to rebuild the DB.

