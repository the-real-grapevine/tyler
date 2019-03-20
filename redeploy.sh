#!/bin/sh
git fetch
git reset origin/master
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up --build -d
