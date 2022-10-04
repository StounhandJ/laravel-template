FROM composer as composer
COPY composer.* /app/
RUN composer install --ignore-platform-reqs --no-scripts --optimize-autoloader

FROM php:8.1-fpm

WORKDIR /var/www

COPY composer.lock composer.json ./

RUN apt-get update --fix-missing
RUN apt-get install -y zlib1g-dev libpq-dev --no-install-recommends \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql

# Supervisor
RUN apt-get install -y supervisor
COPY docker/scripts/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN touch cron.log
# ------

# Zip
#RUN apt-get install -y \
#        libzip-dev \
#        zip \
#  && docker-php-ext-install zip
# ------

# memcached
#RUN apt-get install -y libmemcached-dev --no-install-recommends
#RUN pecl install memcached \
#    && docker-php-ext-enable memcached
# ------

# imagick
#RUN apt-get install -y libmagickwand-dev --no-install-recommends && \
#    pecl install imagick && docker-php-ext-enable imagick && \
#    rm -rf /var/lib/apt/lists/*
# ------

COPY --chown=www-data:www-data . .
COPY --from=composer /app/vendor vendor

COPY docker/scripts/init.sh ./init.sh
RUN sed -i -e 's/\r$//' init.sh
RUN chmod +x ./init.sh
RUN touch storage/logs/laravel.log
RUN chmod 777 storage/logs/laravel.log

EXPOSE 9000
CMD ["/usr/bin/supervisord"]
