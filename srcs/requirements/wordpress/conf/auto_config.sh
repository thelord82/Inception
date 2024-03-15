#!/bin/sh

wp_config_file="/var/www/wordpress/wp-config.php"
echo "SLEEP START"
sleep 10
echo "SLEEP END"

wp config create --allow-root \
    --dbname=$SQL_DATABASE \
    --dbuser=$SQL_USER \
    --dbpass=$SQL_PASSWORD \
    --dbhost=mariadb:3306 --path='/var/www/wordpress'