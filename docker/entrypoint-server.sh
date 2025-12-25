#!/bin/bash
set -e

echo "=== Rails 8 JSON-RPC Demo: Server App ==="
echo ""

cd /app

# Create a modified Gemfile for Docker paths
echo "Configuring gem paths for Docker..."
if [ -f Gemfile ]; then
  cp Gemfile Gemfile.docker.bak
  # Rewrite path-based gems to use the mounted volume
  sed -i 's|path: "../.."|path: "/active_data_flow"|g' Gemfile
  sed -i 's|path: "../../submodules/|path: "/active_data_flow/submodules/|g' Gemfile
fi

# Install/update gems
echo "Installing gems..."
bundle config set --local path '/bundle'
bundle install --jobs 4

# Remove stale pid file
rm -f tmp/pids/server.pid

# Create necessary directories
mkdir -p storage log tmp/pids tmp/cache tmp/sockets

# Setup database if needed
echo "Setting up database..."
if [ ! -f storage/development.sqlite3 ]; then
  bundle exec rails db:create db:migrate db:seed
else
  bundle exec rails db:migrate
fi

echo ""
echo "=== Server App Ready ==="
echo "Rails:    http://0.0.0.0:3000"
echo "JSON-RPC: http://0.0.0.0:8999"
echo ""

# Execute the main command
exec "$@"
