#!/bin/bash
# Log everything to start_docker.log
exec > /home/ubuntu/start_docker.log 2>&1

echo "Logging in to ECR..."
aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 107583420716.dkr.ecr.eu-north-1.amazonaws.com

echo "Pulling Docker image..."
docker pull 107583420716.dkr.ecr.eu-north-1.amazonaws.com/music-app-hybrid-recsys:latest

echo "Checking for existing container..."
if [ "$(docker ps -q -f name=hybrid_recsys)" ]; then
    echo "Stopping existing container..."
    docker stop hybrid_recsys
fi

if [ "$(docker ps -aq -f name=hybrid_recsys)" ]; then
    echo "Removing existing container..."
    docker rm hybrid_recsys
fi

echo "Starting new container..."
docker run -d -p 80:8000 --name hybrid_recsys 107583420716.dkr.ecr.eu-north-1.amazonaws.com/music-app-hybrid-recsys:latest

echo "Container started successfully."