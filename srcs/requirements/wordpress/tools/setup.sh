#!/bin/sh
set -e

# Check required environment variables
if [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] || \
   [ -z "$MYSQL_PASSWORD" ]; then
    echo "Error: Missing database environment variables"
    exit 1
fi

# Download WordPress if it is not already installed
if [ ! -f /var/www/html/wp-config.php ]; then
    wp core download --path=/var/www/html --allow-root

    wp config create \
        --path=/var/www/html \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="mariadb:3306" \
        --allow-root
fi

# Start PHP-FPM
exec "$@"
