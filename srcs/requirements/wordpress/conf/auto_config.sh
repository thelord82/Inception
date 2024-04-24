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
    log_message "TEST REMOVING IT..."
    rm -rf "$wp_config_file"
else
    log_message "Setting up php..."
    # Capture output of wp-cli command and log it
	wp_output=$(/usr/local/bin/wp-cli.phar --allow-root config create \
        --dbname="$SQL_DATABASE" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --dbhost=mariadb:3306 --path='/var/www/wordpress' 2>&1)
    wp core install --allow-root \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_EMAIL" \
        --path='/var/www/wordpress'

    echo "Creating second user..."
    wp user create --allow-root \
    "$WP_USER" "$WP_EMAIL" \
    --role=author \
    --user_pass=$WP_USER_PASSWORD \
    --path='/var/www/wordpress'
    
    # Log the output of wp-cli command
    log_message "wp-cli output: $wp_output"

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
