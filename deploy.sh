#!/bin/bash

# Stop and remove any existing containers
CONTAINER_NAME="your_container_name" # Update with your actual container name
if [ $(docker ps -q -f name=$CONTAINER_NAME) ]; then
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

# Run the new container
docker run -d --name $CONTAINER_NAME -p 80:80 harshp01/two-tier-app:latest
