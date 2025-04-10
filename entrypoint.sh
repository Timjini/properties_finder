#!/bin/bash
set -e

# Remove existing server PID if present
rm -f /usr/src/app/tmp/pids/server.pid

# Ensure all gems are installed
echo "Installing gems..."
bundle install --jobs 4 --retry 3

# Wait for PostgreSQL to be ready
until pg_isready -h postgres -U $PSQL_USER -d $PSQL_DATABASE; do
  echo "Waiting for PostgreSQL..."
  sleep 3
done

# Run database setup
RAILS_ENV=${RAILS_ENV} bundle exec rails db:migrate
RAILS_ENV=${RAILS_ENV} bundle exec rails db:seed

# Start the Rails server
exec bundle exec rails server -b 0.0.0.0
