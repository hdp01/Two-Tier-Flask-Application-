#!/bin/bash

CONTAINER_NAME="two-tier-app"
IMAGE_NAME="harshp01/two-tier-app:latest"

# Pull the latest image from Docker Hub
echo "Pulling the latest image: $IMAGE_NAME"
docker pull $IMAGE_NAME

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
CONTAINER_ID=$(docker run -d --name $CONTAINER_NAME -p 80:80 $IMAGE_NAME)
echo "Container started with ID: $CONTAINER_ID"

# Display logs for the new container
echo "Displaying logs for container: $CONTAINER_NAME"
docker logs $CONTAINER_ID
