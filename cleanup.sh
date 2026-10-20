#!/bin/sh

docker ps -aq --filter label=project=chinook | xargs -r docker rm -f -v
docker ps -aq --filter label=docker-mcp=true | xargs -r docker rm -f -v

docker network ls -q --filter label=project=chinook | xargs -r docker network rm

docker image ls -q --filter label=project=chinook | xargs -r docker rmi -f

docker volume ls -q --filter label=project=chinook | xargs -r docker volume rm