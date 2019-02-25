#!/bin/bash

if [ "$(docker network ls | grep nginx-proxy)" ]; then
  echo "Creating nginx-proxy network ..."
  docker network rm nginx-proxy
else
  echo "Nginx-proxy network doesn't exist."
fi

if [ "$(docker-compose ps nginx-proxy | grep nginx-proxy)" ]; then
  echo "Removing nginx-proxy service..."
  docker-compose down
else
  echo "nginx-proxy service is already down."
fi