#!/usr/bin/env bash

docker build -t client .
docker run -dt -p 4567:4567 client sh