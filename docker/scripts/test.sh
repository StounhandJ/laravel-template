#!/bin/bash

sleep 3

php artisan migrate
php artisan storage:link
vendor/bin/phpunit --verbose --coverage-html tests/coverage
