#!/bin/sh

docker buildx create --name multibuilder
docker buildx use multibuilder
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 --tag stevenfollis/howdy-app:5 --push .