#!/bin/bash

CONTAINER_NAME="two-tier-app"

# Stop and remove any existing containers
if [ $(docker ps -q -f name=$CONTAINER_NAME) ]; then
    echo "Stopping existing container: $CONTAINER_NAME"
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
else
    echo "No existing container found with name: $CONTAINER_NAME"
fi

# Run the new container
echo "Starting new container: $CONTAINER_NAME"
CONTAINER_ID=$(docker run -d --name $CONTAINER_NAME -p 80:80 harshp01/two-tier-app:latest)
echo "Container started with ID: $CONTAINER_ID"

# Display logs for the new container
echo "Displaying logs for container: $CONTAINER_NAME"
docker logs $CONTAINER_ID
