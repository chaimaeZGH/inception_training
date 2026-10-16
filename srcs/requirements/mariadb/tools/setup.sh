    # !/bin/sh
    set -e

    if [ -z "$MYSQL_ROOT_PASSWORD" ] || [ -z "$MYSQL_DATABASE" ] || \
    [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
        echo "Error: Missing required environment variables"
        exit 1 
    fi

    if [ ! -d "/var/lib/mysql/mysql" ]; then
        mysql_install_db --user=mysql --datadir=/var/lib/mysql

        mysqld --user=mysql --datadir=/var/lib/mysql \ 
            --skip-networking &
        pid=$! 

        until mysqladmin ping --silent; do
            sleep 1
        done

        mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

        mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e \
            "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;" 

        mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e \
            "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

        mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e \
            "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"

        mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
        wait "$pid" || true
    fi

    exec mysqld --user=mysql --datadir=/var/lib/mysql