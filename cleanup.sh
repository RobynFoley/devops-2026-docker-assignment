#!/bin/sh

docker ps -aq --filter label=project=chinook | xargs -r docker rm -f -v
docker ps -aq --filter label=docker-mcp=true | xargs -r docker rm -f -v

docker rmi chinook-seeder
docker rmi chinook-agent

docker network ls -q --filter label=project=chinook | xargs -r docker network rm