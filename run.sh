#!/bin/sh
# Adapted from Alex Kleissner's post, Running a Phoenix 1.3 project with docker-compose
# https://medium.com/@hex337/running-a-phoenix-1-3-project-with-docker-compose-d82ab55e43cf

set -e


# Ensure the app's dependencies are installed
mix deps.get

# Install JS libraries
echo "Installing JS..."
cd assets && npm install && node node_modules/webpack/bin/webpack.js --mode development
cd ..

# Wait for Postgres to become available.
until psql -h postgres -U "postgres" -c '\q' 2>/dev/null; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

echo "Postgres is available: continuing with database setup..."

# Potentially Set up the database
mix ecto.create
mix ecto.migrate

echo " Launching Phoenix web server..."
# Start the phoenix web server
mix phx.server
