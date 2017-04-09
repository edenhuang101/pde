### Information
docker pull edenhuang/pde
docker run -it -h pde1 --name pde1   edenhuang/pde /bin/bash
docker attach pde1

# Link to host(mac) volume
docker run -it -h pde1 --name pde1 -p 3306:3306 -v /Users/eden/git:/home/docker/dev_data  edenhuang/pde /bin/bash
docker attach pde1

# Use Mysql
sudo service mysql start
# Exit container without stop
[Ctrl] + P and [Ctrl] + Q

# Mysql Info
mysql  Ver 14.14 Distrib 5.6.35, for Linux (x86_64)

id:root password:P@ssw0rd
id:tasadm password:tasadm
default database: tctas

# JAVA Info
java version "1.8.0_121"
Java(TM) SE Runtime Environment (build 1.8.0_121-b13)
Java HotSpot(TM) 64-Bit Server VM (build 25.121-b13, mixed mode)

PATH: /opt/jdk1.8.0_121
