#!/bin/sh

until php artisan migrate; do
  echo Transfer disrupted, retrying in 5s seconds...
  sleep 5s
done

php artisan db:seed
php artisan storage:link

source .env
export $(cut -d= -f1 .env)

if [ "$APP_KEY" = '' ]; then
    php artisan key:generate
fi

if [ "$APP_DEBUG" = False ]; then
    php artisan optimize
fi
