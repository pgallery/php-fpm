## Описание

Это Dockerfile, позволяющие собрать простой образ для Docker с PHP-FPM 7.1. Имеется возможность изменения параметров PHP.

### PHP собран с поддержкой следующих модулей

 -  gd, mysqli, pdo, pdo_mysql, intl, dom, xml, xsl, xmlrpc, zip, bz2, fileinfo, curl, iconv, json, soap, calendar, 
gettext, mcrypt, tidy, phar, gettext, imagick, bcmath, amqp, opcache, memcached , redis

## Репозиторий Git

Репозиторий исходных файлов данного проекта: [https://github.com/pgallery/php-fpm](https://github.com/pgallery/php-fpm)

## Репозиторий Docker Hub

Расположение образа в Docker Hub: [https://hub.docker.com/](https://hub.docker.com/)

## Использование Docker Hub

```
sudo docker pull pgallery/php-fpm
```

## Запуск

```
docker run -d --name myapp \
    -v /home/username/sitename/www/:/var/www/html/ \
    pgallery/php-fpm

docker run -d -p 80:80 -p 443:443 \
    --link myapp:myapp \
    -v /home/username/sitename/www/:/var/www/html/ \
    -v /home/username/sitename/logs/:/var/log/nginx/ \
    pgallery/nginx
```

## Доступные параметры конфигурации

### Параметры изменяющие настройки PHP

| Параметр | Изменяемая директива | По умолчанию |
|----------|----------------------|--------------|
|**PHP_ALLOW_URL_FOPEN**| allow_url_fopen | On |
|**PHP_DISPLAY_ERRORS**| display_errors | Off |
|**PHP_MAX_EXECUTION_TIME**| max_execution_time | 360 |
|**PHP_MAX_INPUT_TIME**| max_input_time | 360 |
|**PHP_MEMORY_LIMIT**| memory_limit | 256M |
|**PHP_POST_MAX_SIZE**| post_max_size | 256M |
|**PHP_SHORT_OPEN_TAG**| short_open_tag | On |
|**PHP_TIMEZONE**| date.timezone | Europe/Moscow |
|**PHP_UPLOAD_MAX_FILEZIZE**| upload_max_filesize | 256M |
|**PHP_MAX_FILE_UPLOADS**| max_file_uploads | 250 |


#### Пример использования

```
sudo docker run -d \
    -e 'PHP_TIMEZONE=Europe/Moscow' \
    -e 'PHP_MEMORY_LIMIT=512' \
    -e 'PHP_SHORT_OPEN_TAG=On' \
    -e 'PHP_UPLOAD_MAX_FILEZIZE=16' \
    -e 'PHP_MAX_EXECUTION_TIME=120' \
    -e 'PHP_MAX_INPUT_TIME=120' \
    -e 'PHP_DISPLAY_ERRORS=On' \
    -e 'PHP_POST_MAX_SIZE=32' \
    -e 'PHP_ALLOW_URL_FOPEN=Off' \
    pgallery/php-fpm
```

## Использование собственных конфигурационных файлов

Вы можете использовать собственные конфигурационные файлы для php. Для этого Вам необходимо создать их в директории **/var/www/html/config/**. При их обнаружении, Ваши конфигурационные файлы будут скопированы и заменят существующие.

### PHP

 - **/var/www/html/config/php/php.ini** - данным файлом будет заменен /usr/local/etc/php/php.ini (при этом параметры, изменяющие настройки PHP, переданные при запуске контейнера, будут игнорированы)
 - **/var/www/html/config/php/pool.conf** - данным файлом будет заменен /usr/local/etc/php-fpm.d/www.conf

