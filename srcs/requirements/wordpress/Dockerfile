
FROM alpine:3.19

RUN apk add --no-cache \
    php83 \
    php83-fpm \
    php83-mysqli \
    php83-curl \
    php83-gd \
    php83-mbstring \
    php83-xml \
    php83-zip \
    php83-session \
    php83-phar \
    php83-iconv \
    php83-xmlreader \
    php83-intl \
    wget \
    mariadb-client

# Increase PHP memory limit
RUN printf '\nmemory_limit=256M\n' >> /etc/php83/php.ini

# Make the command "php" available
RUN ln -s /usr/bin/php83 /usr/bin/php

RUN mkdir -p /var/www/html

COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/setup.sh \
    && wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
       -O /usr/local/bin/wp \
    && chmod +x /usr/local/bin/wp

ENTRYPOINT ["/usr/local/bin/setup.sh"]
CMD ["php-fpm83", "-F"]
