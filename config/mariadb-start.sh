#!/bin/bash

# if the /data/mariadb directory doesn't contain anything, then initialise it
directory="/data/mariadb/data"
mkdir -p $directory

if [ ! "$(ls -A $directory)" ]; then
    /usr/bin/mysql_install_db --datadir=/data/mariadb/data --user=mysql
    cp /opt/bin/mariadb-setup.sql /tmp/combined.sql
    cat >> /tmp/combined.sql <<-EOSQL
	CREATE USER '${LARAVEL_DB_USER}'@'%';
	SET PASSWORD FOR '${LARAVEL_DB_USER}'@'%' = PASSWORD('${LARAVEL_DB_PASS}');
	CREATE DATABASE \`${LARAVEL_DB_NAME}\`;
	GRANT ALL PRIVILEGES ON \`${LARAVEL_DB_NAME}\`.* TO '${LARAVEL_DB_USER}'@'%';
	FLUSH PRIVILEGES;
EOSQL
    /usr/bin/mysqld_safe --init-file=/tmp/combined.sql
else
    /usr/bin/mysqld_safe
fi
