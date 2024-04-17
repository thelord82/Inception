FROM debian:buster

RUN apt update -y && \
    apt upgrade -y && \
    apt-get install mariadb-server -y && apt install dumb-init -y

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY conf/dbconfig.sh /usr/local/bin/dbconfig.sh
RUN chmod +x /usr/local/bin/dbconfig.sh

EXPOSE 3306

CMD ["/usr/local/bin/dbconfig.sh"]