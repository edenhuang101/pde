# Information
docker pull edenhuang/pde
docker run -it -h oam01 --name oam01 -p 3306:3306 -v /dev_data:/home/docker/dev_data  pde
docker attach oam01

### if want to use Mysql
sudo service mysql start
### Exit container without stop
[Ctrl] + P and [Ctrl] + Q

# Mysql Info
mysql  Ver 14.14 Distrib 5.6.28, for Linux (x86_64)

id:root password:P@ssw0rd
id:tasadm password:tasadm
default database: tctas
