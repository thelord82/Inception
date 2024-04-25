FROM debian:buster

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install wget -y && \
    apt-get install php7.3 -y && \
    apt-get install php-fpm -y && \
    apt-get install php-mysql -y && \
    apt-get install mariadb-client -y

#Installation, untar et rm tar du wordpress setup file
RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www \
&& cd /var/www \
&& tar -xzf wordpress-6.0-fr_FR.tar.gz \
&& rm wordpress-6.0-fr_FR.tar.gz
RUN chown -R www-data:www-data /var/www/wordpress \
&& sleep 5
#&& RUN chmod -R 777 /var/www/wordpress

# Modification du fichier de configuration de php-fpm 
COPY conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

# Configuration de WordPress
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp-cli.phar

# Configuration de wordpress
COPY conf/auto_config.sh /usr/local/bin/auto_config.sh
RUN mkdir -p /run/php
RUN chmod +x /usr/local/bin/auto_config.sh

ENTRYPOINT ["/bin/sh", "/usr/local/bin/auto_config.sh"]

EXPOSE 9000