#!/bin/bash
set -e

# Copy original docker-entrypoint.sh from the PostgreSQL image to the current directory
cp /usr/local/bin/docker-entrypoint.sh .

# Start PostgreSQL in the background using the copied entrypoint script
./docker-entrypoint.sh postgres &

# Wait for 10-15 seconds for PostgreSQL to initialize
sleep 15

# Run the init.sql script
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /docker-entrypoint-initdb.d/init.sql

# Keep the container running
wait
