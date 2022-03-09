#!/bin/bash

sleep 10
php artisan migrate
php artisan db:seed
php artisan storage:link
chown www-data:www-data -R /var/www/storage/app
if (("$PRODUCT" = True)); then
    php artisan optimize
fi
