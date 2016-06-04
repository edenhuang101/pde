# Information
docker pull edenhuang/pde
docker run -it -h pde1 --name pde1 -p 3306:3306 -v /dev_data:/home/docker/dev_data  pde
docker attach pde1

### if want to use Mysql
sudo service mysql start
### Exit container without stop
[Ctrl] + P and [Ctrl] + Q

# Mysql Info
mysql  Ver 14.14 Distrib 5.6.28, for Linux (x86_64)

id:root password:P@ssw0rd
id:tasadm password:tasadm
default database: tctas
