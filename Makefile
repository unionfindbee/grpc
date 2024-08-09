# Name of the Docker image
IMAGE_NAME=grpc-demo
# Name of the Docker container
CONTAINER_NAME=grpc-demo
# Tag for the Docker image
TAG=latest
# Dockerfile location
DOCKERFILE_PATH=./Dockerfile
# Load environment variables from .env file
include .env

.PHONY: all build clean

# Default target
all: build

# Build the Docker image
build:
	docker build --build-arg MAPI_TOKEN=$(MAPI_TOKEN) -t $(IMAGE_NAME):$(TAG) -f $(DOCKERFILE_PATH) .

# Enter a shell in the Docker image
shell:
	docker run -it --rm $(IMAGE_NAME):$(TAG) /bin/bash

# Scan the gRPC server
demo:
	docker run -it --rm --name $(CONTAINER_NAME) $(IMAGE_NAME):$(TAG) 


# Remove the Docker image
clean:
	docker rmi $(IMAGE_NAME):$(TAG)
