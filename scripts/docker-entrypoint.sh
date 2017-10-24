#!/bin/bash

set -e

phpinifpm=/usr/local/etc/php/php.ini

# php environment
PHP_ALLOW_URL_FOPEN=${PHP_ALLOW_URL_FOPEN:-On}
PHP_DISPLAY_ERRORS=${PHP_DISPLAY_ERRORS:-Off}
PHP_MAX_EXECUTION_TIME=${PHP_MAX_EXECUTION_TIME:-360}
PHP_MAX_INPUT_TIME=${PHP_MAX_INPUT_TIME:-360}
PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT:-256}
PHP_POST_MAX_SIZE=${PHP_POST_MAX_SIZE:-256}
PHP_SHORT_OPEN_TAG=${PHP_SHORT_OPEN_TAG:-On}
PHP_TIMEZONE=${PHP_TIMEZONE:-Europe/Moscow}
PHP_UPLOAD_MAX_FILEZIZE=${PHP_UPLOAD_MAX_FILEZIZE:-256}
PHP_MAX_FILE_UPLOADS=${PHP_MAX_FILE_UPLOADS:-250}

PHP_TZ=`echo ${PHP_TIMEZONE} |sed  's|\/|\\\/|g'`

# set timezone
ln -snf /usr/share/zoneinfo/${PHP_TIMEZONE} /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

if [ -f /var/www/html/config/php/pool.conf ]; then
    cp /var/www/html/config/php/pool.conf /usr/local/etc/php-fpm.d/www.conf
fi

if [ -f /var/www/html/config/php/php.ini ]; then
    cp /var/www/html/config/php/php.ini ${phpinifpm}
else

    sed -i \
        -e "s/memory_limit = 128M/memory_limit = ${PHP_MEMORY_LIMIT}M/g" \
        -e "s/short_open_tag = Off/short_open_tag = ${PHP_SHORT_OPEN_TAG}/g" \
        -e "s/upload_max_filesize = 2M/upload_max_filesize = ${PHP_UPLOAD_MAX_FILEZIZE}M/g" \
        -e "s/max_file_uploads = 20/max_file_uploads = ${PHP_MAX_FILE_UPLOADS}/g" \
        -e "s/max_execution_time = 30/max_execution_time = ${PHP_MAX_EXECUTION_TIME}/g" \
        -e "s/max_input_time = 60/max_input_time = ${PHP_MAX_INPUT_TIME}/g" \
        -e "s/display_errors = Off/display_errors = ${PHP_DISPLAY_ERRORS}/g" \
        -e "s/post_max_size = 8M/post_max_size = ${PHP_POST_MAX_SIZE}M/g" \
        -e "s/allow_url_fopen = On/allow_url_fopen = ${PHP_ALLOW_URL_FOPEN}/g" \
        -e "s/;date.timezone =/date.timezone = ${PHP_TZ}/g" \
        ${phpinifpm}

fi

usermod -s /bin/bash www-data
chown www-data:www-data /var/www -R

/usr/local/sbin/php-fpm

exec "$@"
