FROM debian:buster

RUN apt update -y && \\
    apt upgrade -y && \\
    apt-get install mariadb-server -y && apt install vim -y

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf