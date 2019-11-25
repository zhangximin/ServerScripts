#!/bin/bash

#docker rmi $(docker images -f "dangling=true" -q)

docker system prune -a -f
docker container prune -f
docker image prune -a -f

docker volume prune --filter "label!=keep" -f
