#!/bin/bash

# Rails 8 JSON-RPC Demo - Docker Startup Script
# This script builds and starts the demo using Docker Compose

set -e

echo "=============================================="
echo " Rails 8 JSON-RPC Demo - Docker Setup"
echo "=============================================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker and try again."
    exit 1
fi

# Navigate to the demo directory
cd "$(dirname "$0")"

echo "Building Docker images..."
docker compose build

echo ""
echo "Starting services..."
docker compose up -d

echo ""
echo "Waiting for services to be ready..."
sleep 10

# Check service health
echo ""
echo "Checking service status..."
docker compose ps

echo ""
echo "=============================================="
echo " Demo is running!"
echo "=============================================="
echo ""
echo " Server App (receives JSON-RPC):"
echo "   - Rails UI:    http://localhost:3000"
echo "   - JSON-RPC:    http://localhost:8999"
echo ""
echo " Client App (sends JSON-RPC):"
echo "   - Rails UI:    http://localhost:3001"
echo ""
echo " Commands:"
echo "   - View logs:   docker compose logs -f"
echo "   - Stop demo:   docker compose down"
echo "   - Rebuild:     docker compose build --no-cache"
echo ""
echo "=============================================="
