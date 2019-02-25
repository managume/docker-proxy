#!/bin/bash

if [ ! "$(docker network ls | grep nginx-proxy)" ]; then
  echo "Creating nginx-proxy network ..."
  docker network create nginx-proxy
else
  echo "nginx-proxy network exists."
fi

if [ ! "$(docker-compose ps nginx-proxy | grep nginx-proxy)" ]; then
  echo "Creating nginx-proxy service ..."
  docker-compose up -d
else
  echo "nginx-proxy service is already up."
fi