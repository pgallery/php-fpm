FROM pgallery/php:latest

LABEL maintainer="Ruzhentsev Alexandr <git@pgallery.ru>"
LABEL version="1.0 beta 2"
LABEL description="Docker image PHP-FPM 7.1 for pGallery"

COPY scripts/ 	/usr/local/bin/

RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

VOLUME /var/www/html

EXPOSE 9000

CMD ["/usr/local/bin/docker-entrypoint.sh"]
