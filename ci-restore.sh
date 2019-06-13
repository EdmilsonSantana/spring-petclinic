#!/bin/bash

DOCKER_VOLUME=$1
DIR=$2
VERSION=$3

sudo docker stop $DOCKER_VOLUME
sudo docker rm $DOCKER_VOLUME

sudo docker run --name $DOCKER_VOLUME  -v $DOCKER_VOLUME:$DIR --entrypoint "bin/sh" edmilsonsantana/$DOCKER_VOLUME:${VERSION}
