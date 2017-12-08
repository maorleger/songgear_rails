# Listing docker and compose commands here for future reference

## Command list

1. `docker-compose build` - rebuilds the container after changes to Gemfile or Dockerfile
2. `docker-compose up` - boot up the app
  1. `docker-compose up --build` - boot up the container but rebuild it first
3. `docker-compose run web rails db:create` - run `rails db:create` inside the `web` container
4. `docker-compose down` - shut down the app containers

## Rebuilding the app

`docker-compose build` or `docker-compose up --build` will do a rebuild to sync up changes to Gemfile or Dockerfile.

Sometimes you'll want to run `docker-compose run web rails db:create` to rebuild the DB.

### Notes and things I have to improve

1. Make setting up the DB part of booting up the world so I don't have to always create and run db:setup
1. Webpacker and rails server are running via foreman in one container but they shouldnt have to.
  - Instead I can setup a webpacker container separately
1. Setup hot reloading in webpacker
1. Figure out Yarn cache so I can run `yarn install` both inside and outside the container and they'll not be shared
