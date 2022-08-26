#!/bin/sh
git fetch
git reset --hard origin/master
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up --build -d
