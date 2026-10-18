#!/bin/sh

docker rm -f chinook-db

docker rmi chinook-seeder

docker network rm chinook-net