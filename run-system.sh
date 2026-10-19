#!/bin/sh

set -e

docker network create --label project=chinook chinook-net

docker run -d --name chinook-db \
    --network chinook-net \
    --label project=chinook \
    -e POSTGRES_USER=robyn \
    -e POSTGRES_PASSWORD=password \
    -e POSTGRES_DB=chinook \
    postgres

docker build --target seeder --label project=chinook -t chinook-seeder .

#Wait for Postgres to accept connections before seeding
until docker exec chinook-db pg_isready -U robyn -d chinook; do
    echo "Waiting for database..."
    sleep 2
done

# MSYS_NO_PATHCONV=1 stops Git Bash on Windows from rewriting Unix-style
# paths (like /app/Chinook.db) into Windows paths before Docker sees them.
MSYS_NO_PATHCONV=1 docker run --rm --name chinook-seeder \
    --network chinook-net \
    --label project=chinook \
    -v "$PWD/Chinook.db:/app/Chinook.db:ro" \
    -e SQLITE_FILE=/app/Chinook.db \
    -e DATABASE_URL=postgres://robyn:password@chinook-db:5432/chinook \
    chinook-seeder

MSYS_NO_PATHCONV=1 docker run -d --name chinook-gateway \
    --network chinook-net \
    --label project=chinook \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$PWD/mcp_config.yaml:/mcp_config.yaml:ro" \
    -v "$PWD/mcp_secret.env:/run/secrets/database-url:ro" \
    docker/mcp-gateway:latest \
    --transport=sse \
    --secrets=/run/secrets/database-url \
    --allow-unauthenticated \
    --servers=cockroachdb \
    --tools=execute_query \
    --config=/mcp_config.yaml