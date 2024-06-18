#!/bin/bash

set -e

ECR_URL=$1

# Get the latest tag of the nexus3 image from Docker Hub
LATEST_TAG=$(curl -s https://hub.docker.com/v2/repositories/sonatype/nexus3/tags/?page_size=1 | jq -r '.results[0].name')

echo "Latest tag of sonatype/nexus3: $LATEST_TAG"

# Log in to AWS ECR
$(aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL)

# Pull the latest image from Docker Hub
docker pull sonatype/nexus3:$LATEST_TAG

# Tag the image for ECR
docker tag sonatype/nexus3:$LATEST_TAG $ECR_URL:latest

# Push the image to ECR
docker push $ECR_URL:latest

echo "Pushed $ECR_URL:latest"
