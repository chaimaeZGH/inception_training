FROM alpine:3.21

RUN apk add --no-cache \
        php83 \
        php83-mysqli \
        php83-pdo_mysql \
        php83-session \
        curl \
        ca-certificates

ARG ADMINER_VERSION=4.8.1
RUN mkdir -p /var/www/adminer \
 && curl -fsSL -o /var/www/adminer/index.php \
      "https://github.com/vrana/adminer/releases/download/v${ADMINER_VERSION}/adminer-${ADMINER_VERSION}.php" \
 && chown -R nobody:nobody /var/www/adminer

WORKDIR /var/www/adminer
EXPOSE 9000


CMD ["php", "-S", "0.0.0.0:9000", "-t", "/var/www/adminer"]