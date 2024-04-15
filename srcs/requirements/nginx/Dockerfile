FROM debian:buster

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y nginx && \
    apt install -y vim && \
    apt install -y curl && \
    mkdir -p /etc/nginx/ssl && \
    apt install openssl -y && \
    openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=CA/ST=QC/L=Quebec/O=42/OU=42/CN=malord.42.fr/UID=malord" && \
    mkdir -p /var/run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf
RUN chmod 755 /var/www/html && \
    chown -R www-data:www-data /var/www/html
CMD ["nginx", "-g", "daemon off;"]