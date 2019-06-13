#!/bin/bash

CONTAINER=$1
CONTAINER_BACKUP=$2
DIR=$3
VERSION=$4

sudo docker stop $CONTAINER_BACKUP  &>/dev/null
sudo docker rm $CONTAINER_BACKUP  &>/dev/null

sudo docker run --rm --volumes-from $CONTAINER -v $(pwd)/backup:/backup ubuntu tar cvf /backup/backup.tar $DIR \
&& sudo docker run -v $(pwd)/backup:/backup --name $CONTAINER_BACKUP ubuntu /bin/sh -c "cd / && tar xvf /backup/backup.tar" \
&& sudo docker commit $CONTAINER_BACKUP edmilsonsantana/$CONTAINER_BACKUP:$VERSION \
&& sudo docker stop $CONTAINER_BACKUP && sudo docker rm $CONTAINER_BACKUP \
&& sudo rm -Rf $(pwd)/backup