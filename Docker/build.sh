#!/bin/bash
set -e
set -x
IMAGE_NAME="my-mape"
IMAGE_TAG="v0.0.0" 
cd ..
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -f Docker/Dockerfile .
