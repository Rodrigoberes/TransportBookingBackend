#!/bin/bash

# Migration script for Transport Booking Backend
# This script runs database migrations using golang-migrate

set -e

# Check if golang-migrate is installed
if ! command -v migrate &> /dev/null; then
    echo "golang-migrate is not installed. Please install it first:"
    echo "go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest"
    exit 1
fi

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

# Set default database URL if not provided
DATABASE_URL=${DATABASE_URL:-"postgresql://user:password@localhost:5432/transport_booking?sslmode=disable"}

echo "Running database migrations..."
echo "Database URL: $DATABASE_URL"

# Run migrations
migrate -path ./migrations -database "$DATABASE_URL" up

echo "Migrations completed successfully!"