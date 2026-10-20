#!/bin/sh

docker ps -aq --filter label=project=chinook | xargs -r docker rm -f -v

docker rmi chinook-seeder

docker rm -f chinook-gateway

docker rmi chinook-agent

docker network rm chinook-net