# Name of the Docker image
IMAGE_NAME=grpc-demo
# Tag for the Docker image
TAG=latest
# Dockerfile location
DOCKERFILE_PATH=./Dockerfile

.PHONY: all build clean

# Default target
all: build

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME):$(TAG) -f $(DOCKERFILE_PATH) .

# Enter a shell in the Docker image
shell:
	docker run -it --rm $(IMAGE_NAME):$(TAG) /bin/bash

# Remove the Docker image
clean:
	docker rmi $(IMAGE_NAME):$(TAG)
