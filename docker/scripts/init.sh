#!/bin/bash

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

php artisan migrate
php artisan db:seed
php artisan storage:link

loadEnv .env

if [[ "$APP_KEY" == '' ]]; then
    php artisan key:generate
fi

if (("$PRODUCT" = True)); then
    php artisan optimize
fi
