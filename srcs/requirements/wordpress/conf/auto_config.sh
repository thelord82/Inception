#!/bin/sh

wp_config_file="/var/www/wordpress/wp-config.php"
echo "SLEEP START"
sleep 10
echo "SLEEP END"

if [ -f "$wp_config_file" ]; then
	echo "wp-config.php ALREADY EXISTS"
fi

if [ ! -f "$wp_config_file" ]; then
	echo "setuping php..."
	wp config create --allow-root \
    	--dbname=$SQL_DATABASE \
    	--dbuser=$SQL_USER \
    	--dbpass=$SQL_PASSWORD \
    	--dbhost=mariadb:3306 --path='/var/www/wordpress'
	echo "Creating page..."
	/usr/local/bin/wp-cli.phar --allow-root core install \
	--url='https://localhost' \
	--title="$WP_TITLE" \
	--admin_user="$WP_ADMIN" \
	--admin_password="$WP_ADMIN_PASSWORD" \
	--admin_email="$WP_ADMIN_EMAIL" \
	--path='var/www/wordpress/'
	echo "Creating new user..."
	/usr/local/bin/wp-cli.phar --allow-root user create \
	"$WP_USER" \
	"$WP_USER_EMAIL" \
	--role=author \
	--user_pass="$WP_USER_PASSWORD" \
	--path='/var/www/wordpress/'
	echo "To check second user creation, go to localhost/wp-login.php"
fi

echo "Executing php-fpm"
/usr/sbin/php-fpm7.3 -F
