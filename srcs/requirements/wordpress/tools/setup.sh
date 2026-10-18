#!/bin/sh
set -e
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

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
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root
fi

if ! wp user get "$WP_USER" --allow-root >/dev/null 2>&1; then
    wp user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root
fi


exec "$@"