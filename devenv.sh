#!/bin/bash

# Run MySQL, init it, and then run Install Script
sudo service mysqld start

sudo sed -ie 's/database_name_here/'$MYSQL_DB'/g' /tmp/mysql_setup.sql
sudo sed -ie 's/mysql_clientaddr/'$MYSQL_CLIENTADDR'/g' /tmp/mysql_setup.sql
sudo sed -ie 's/mysql_user_here/'$APP_USER'/g' /tmp/mysql_setup.sql
sudo sed -ie 's/mysql_password_here/'$APP_PASS'/g' /tmp/mysql_setup.sql

sudo mysql < /tmp/mysql_setup.sql && sudo rm -fr /tmp/mysql_setup.sql*

# Set the MySQL root password
sudo mysqladmin -u root password $MYSQL_PASS

# Unset the Mysql password variable
unset MYSQL_PASS MYSQL_CLIENTADDR MYSQL_DB APP_USER APP_PASS

# Add mysql to the bashrc to start on boot
# echo "sudo service mysqld stop" >> ~/.bashrc
# echo "sudo service mysqld start" >> ~/.bashrc

