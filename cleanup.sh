#!/bin/sh

docker rm -f chinook-db

docker rmi chinook-seeder

docker rm -f chinook-gateway

docker network rm chinook-net