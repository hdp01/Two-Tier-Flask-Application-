#!/bin/bash

# Stop and remove any existing containers
CONTAINER_NAME="two-tier-app" # Update with your actual container name
echo "Checking for existing container: $CONTAINER_NAME"

if [ $(docker ps -q -f name=$CONTAINER_NAME) ]; then
    echo "Stopping and removing existing container: $CONTAINER_NAME"
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
else
    echo "No existing container found with name: $CONTAINER_NAME"
fi

# Run the new container
echo "Starting new container: $CONTAINER_NAME"
CONTAINER_ID=$(docker run -d --name $CONTAINER_NAME -p 80:80 harshp01/two-tier-app:latest)

if [ $? -eq 0 ]; then
    echo "Container started successfully with ID: $CONTAINER_ID"
else
    echo "Failed to start the container."
fi

# Optional: Display the logs of the new container
echo "Displaying logs for container: $CONTAINER_NAME"
docker logs $CONTAINER_ID
