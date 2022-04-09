FROM composer as composer
COPY composer.* /app/
RUN composer install --ignore-platform-reqs --no-scripts --optimize-autoloader

FROM php:8.1-fpm

COPY composer.lock composer.json /var/www/

WORKDIR /var/www

RUN apt-get update
RUN apt-get install -y libpq-dev \
    supervisor \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql

#RUN apt-get install -y php-zip \
#    && docker-php-ext-enable zip.so \

RUN apt-get install -y \
        libzip-dev \
        zip \
  && docker-php-ext-install zip

COPY docker/scripts/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN touch /var/www/cron.log

COPY --chown=www-data:www-data . /var/www
RUN touch /var/www/storage/logs/laravel.log
COPY --from=composer /app/vendor /var/www/vendor
COPY docker/scripts/init.sh ./init.sh
RUN sed -i -e 's/\r$//' init.sh
RUN chmod +x ./init.sh

EXPOSE 9000
CMD ["/usr/bin/supervisord"]
