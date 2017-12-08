FROM ruby:2.4

# Install JS runtime dependencies
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
      && apt-get install -y nodejs

# Install apt based dependencies
RUN apt-get update && apt-get install -y \
      build-essential

# Get everything you need to setup yarn
RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
      curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
      apt-get update && apt-get install -y yarn

# Configure the main working directory.
# Once we set this up, any further commands will run off this directory
RUN mkdir -p /app
WORKDIR /app

# Copy Gemfile and lock and install gems.
# Why is this a separate step?
# so that dependencies will be cached unless changes to one of these files are made
ADD Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy the main application over
ADD . ./
