FROM composer as composer
COPY composer.* /app/
RUN composer install --ignore-platform-reqs --no-dev --no-scripts --optimize-autoloader

FROM php:8.1-fpm-alpine

WORKDIR /var/www

COPY composer.lock composer.json ./

RUN apk add autoconf g++ make

RUN apk add zlib-ng-dev libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql

# Supervisor
RUN apk add supervisor
COPY docker/scripts/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# ------

# Zip
#RUN apk add libzip-dev zip
#  && docker-php-ext-install zip
# ------

# memcached
#RUN apk add libzip-dev libmemcached-dev
#RUN pecl install memcached \
#    && docker-php-ext-enable memcached
# ------

# imagick
#RUN apk add imagemagick-dev
#RUN pecl install imagick \
#    && docker-php-ext-enable imagick
# ------

COPY --chown=www-data:www-data . .
COPY --from=composer /app/vendor vendor

ADD docker/scripts/init.sh init.sh
RUN sed -i -e 's/\r$//' init.sh

EXPOSE 9000
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
