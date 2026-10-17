#!/bin/sh
set -e

if [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] || \
   [ -z "$MYSQL_PASSWORD" ]; then
    echo "Error: Missing database environment variables"
    exit 1
fi

cd /var/www/html

# Wait for mariadb to accept connections
until nc -z mariadb 3306; do
    echo "Waiting for mariadb..."
    sleep 2
done

# Each step has its own guard, so a restart resumes where it left off
if [ ! -f wp-load.php ]; then
    wp core download --allow-root
fi

if [ ! -f wp-config.php ]; then
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="mariadb:3306" \
        --allow-root
fi

if ! wp core is-installed --allow-root; then
    wp core install \
        --url="https://$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root
fi

exec "$@"