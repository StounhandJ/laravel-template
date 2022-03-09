#!/bin/bash

if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: docker-compose is not installed.' >&2
  exit 1
fi

echo -e "\033[1;32m \033[41m Updating... \033[0m"
git fetch --all
git reset --hard origin/master

echo -e "\033[1;32m \033[41m Granting rights to bsh scripts... \033[0m"
chmod +x run.sh
chmod +x docker/certbot/gen-ssl.sh
chmod +x restart.sh

echo -e "\033[1;32m \033[41m Launching a project... \033[0m"
docker-compose up --build -d
