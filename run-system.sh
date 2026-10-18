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
