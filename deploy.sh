#!/bin/bash

# Pull the latest Docker image
docker pull harshp01/two-tier-app:latest

# Stop and remove existing containers
docker stop $(docker ps -q) || true
docker rm $(docker ps -aq) || true

# Run the new container
docker run -d -p 80:80 harshp01/two-tier-app:latest
