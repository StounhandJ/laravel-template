#!/bin/bash

if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: docker-compose is not installed.' >&2
  exit 1
fi

loadEnv() {
  local envFile="${1?Missing environment file}"
  local environmentAsArray variableDeclaration
  mapfile environmentAsArray < <(
    grep --invert-match '^#' "${envFile}" \
      | grep --invert-match '^\s*$'
  ) # Uses grep to remove commented and blank lines
  for variableDeclaration in "${environmentAsArray[@]}"; do
    export "${variableDeclaration//[$'\r\n']}" # The substitution removes the line breaks
  done
}

loadEnv .env


echo -e "\033[1;32m \033[41m Granting rights to files... \033[0m"
chmod +x docker/certbot/run.sh
chmod +x docker/certbot/gen-ssl.sh
chmod +x restart.sh

echo -e "\033[1;32m \033[41m Getting a wildcard certificate... \033[0m"
./docker/certbot/run.sh $DOMAIN $CLOUDFLARE_API_KEY $CLOUDFLARE_EMAIL

echo -e "\033[1;32m \033[41m Reboot... \033[0m"
docker-compose build
docker-compose down
docker-compose up -d
