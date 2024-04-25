#!/bin/sh

log_file="/var/log/auto_config.log"
wp_config_file="/var/www/wordpress/wp-config.php"

# Function to log messages to the file
log_message() {
    local message="$1"
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $message" >> "$log_file"
}

# Log start of script
log_message "Auto configuration script started."

# Rest of your script goes here...

log_message "SLEEP START"
sleep 10
log_message "SLEEP END"

# Check if wp-config.php file already exists
if [ -f "$wp_config_file" ]; then
    log_message "wp-config.php ALREADY EXISTS"
    #log_message "TEST REMOVING IT..."
    #rm -rf "$wp_config_file"
else
    log_message "Setting up php..."
    # Capture output of wp-cli command and log it
    chmod -R 777 /var/www/wordpress
    #wp core download --path="/var/www/wordpress" --allow-root
    wp_output=$(/usr/local/bin/wp-cli.phar --allow-root config create \
        --dbname="$SQL_DATABASE" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --dbhost=mariadb:3306 --path='/var/www/wordpress' 2>&1)
    log_message "wp-cli output for config create: $wp_output"
    wp_output=$(/usr/local/bin/wp-cli.phar core install --allow-root \
        --url='https://malord.42.fr' \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path='/var/www/wordpress' 2>&1)
    log_message "wp-cli output for core install: $wp_output"
    log_message "Creating second user..."
    wp_output=$(/usr/local/bin/wp-cli.phar user create --allow-root \
        "$WP_USER" "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --path='/var/www/wordpress' 2>&1)
    log_message "wp-cli output for user create: $wp_output"
    
    # Check if wp-config.php was created successfully
    if [ -f "$wp_config_file" ]; then
        log_message "wp-config.php CREATED successfully"
    else
        log_message "Failed to create wp-config.php"
        log_message "Error: $wp_output"
    fi
fi

log_message "Executing php-fpm"
/usr/sbin/php-fpm7.3 -F
