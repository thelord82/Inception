#!/bin/bash -x

#Demarrage MySQL
service mysql start;

#Creation de la table
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

#Creation du user
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"

#Donner les droits au user
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

#Modification de l'utilisateur root
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

#refresh!
mysql -e "FLUSH PRIVILEGES;"

#Redemarrage MySQL (shutdown + exec)
mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown
exec mysqld_safe