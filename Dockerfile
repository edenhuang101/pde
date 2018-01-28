#################################################
# Dockerfile to python Application Containers
# Based on centos66
#################################################
FROM centos:6.6

# File Author / Maintainer
MAINTAINER edenhuang@truetel.com

#**************************
#*   Add Required Files   *
#**************************
ADD devenv.sh /tmp/
ADD mysql_setup.sql /tmp/
ADD my.cnf /etc/
ADD oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm /usr/local/src
ADD oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm /usr/local/src
ADD oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm /usr/local/src

RUN yum clean all && \
yum -y update && \
# yum -y groupinstall "Development tools" && \
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel  && \
yum -y install sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel && \
yum -y install make automake gcc gcc-c++ kernel-devel git-core && \
yum -y install wget tar sudo hg unzip which tree && \
yum -y install openssh* net-snmp-utils nmap tcpdump && \
yum -y install cairo-devel pango-devel telnet && \
# Install perl package for percona-toolkit
yum -y install perl-DBD-MySQL.x86_64 && \
yum -y install perl-Time-HiRes.x86_64 && \
yum -y install perl-IO-Socket-SSL && \
yum -y install perl-TermReadKey.x86_64 && \
# Install font for gnuplot
yum -y install liberation-sans-fonts && \
yum -y install dos2unix

# Install MySQL
RUN yum -y localinstall http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm && \
yum -y install mysql-community-server && \
yum -y install mysql-community-devel && \
rm -fr /var/cache/*

# Install python
RUN cd /usr/local/src && wget https://www.python.org/ftp/python/2.7.14/Python-2.7.14.tgz && \
tar -zxf Python-2.7.14.tgz && \
cd Python-2.7.14 && \
./configure --prefix=/usr/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" && \
make && make altinstall && \
cd ..;rm -f Python-2.7.14.tgz && \
rm -rf Python-2.7.14 && \
# Install ezsetup and pip
wget https://bootstrap.pypa.io/ez_setup.py -O - | /usr/local/bin/python2.7 && \
/usr/local/bin/easy_install-2.7 pip

# install oracle client 11
RUN cd /usr/local/src && rpm -ivh oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm && \
rpm -ivh oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm && \
rpm -ivh oracle-instantclient11.2-sqlplus-11.2.0.4.0-1.x86_64.rpm && \
rm -f oracle*.rpm

# Install python plugin
RUN /usr/local/bin/pip install --upgrade pip && \
/usr/local/bin/pip install fabric && \
/usr/local/bin/pip install ipython && \
/usr/local/bin/pip install flake8 && \
# /usr/local/bin/pip install install Faker>=0.7.0 && \
/usr/local/bin/pip install MySQL-python && \
/usr/local/bin/pip install python-daemon && \
/usr/local/bin/pip install ecks && \
/usr/local/bin/pip install python-nmap && \
/usr/local/bin/pip install scapy && \
/usr/local/bin/pip install ping && \
/usr/local/bin/pip install jedi && \
/usr/local/bin/pip install configobj && \
/usr/local/bin/pip install ipdb && \
/usr/local/bin/pip install sshtunnel && \
/usr/local/bin/pip install ftpretty && \
/usr/local/bin/pip install colorlog && \
/usr/local/bin/pip install cx-Oracle && \
/usr/local/bin/pip install python-hpilo && \
/usr/local/bin/pip install pysnmp && \
/usr/local/bin/pip install requests && \
/usr/local/bin/pip install numpy && \
/usr/local/bin/pip install ansible && \
/usr/local/bin/pip install twilio && \
/usr/local/bin/easy_install-2.7 "path.py==8.2.1" && \
/usr/local/bin/easy_install-2.7 Ptable && \
/usr/local/bin/easy_install-2.7 virtualenv && \
cd /usr/local/src && wget -O python-smpplib.zip https://github.com/podshumok/python-smpplib/archive/master.zip && \
unzip python-smpplib.zip && mv python-smpplib-master python-smpplib && \
cd python-smpplib && python2.7 setup.py install && \
cd ..;rm -f python-smpplib.zip;rm -rf python-smpplib

# install mailsend
RUN cd /usr/local/src && wget -O mailsend.zip https://github.com/muquit/mailsend/archive/master.zip && \
unzip mailsend.zip && mv mailsend-master mailsend && \
cd mailsend && /bin/sh ./configure --with-openssl=/usr && \
make install && \
cd ..;rm -f mailsend.zip;rm -rf mailsend

# install vim
RUN cd /usr/local/src && hg clone https://bitbucket.org/vim-mirror/vim vim && \
export vi_cv_path_python=/usr/local/bin/python2.7 && \
export vi_cv_path_python_pfx=/usr/local && \
cd vim/src && \
./configure LDFLAGS="-Wl,--rpath=/usr/local/lib" --enable-pythoninterp \
            --with-features=huge --with-python-config-dir=/usr/local/lib/python2.7/config && \
make && make install && \
cd ../../;rm -rf vim

# install gnuplot
RUN cd /usr/local/src && wget -O gnuplot-5.0.6.tar.gz \
    https://sourceforge.net/projects/gnuplot/files/gnuplot/5.0.6/gnuplot-5.0.6.tar.gz/download && \
tar -zxvf gnuplot-5.0.6.tar.gz && \
cd gnuplot-5.0.6 && \
./configure && \
make && \
make install && \
cd ..;rm -rf gnuplot-5.0.6.tar.gz; rm -rf gnuplot-5.0.6

# install gnuplot-py
RUN cd /usr/local/src && git clone https://github.com/jrk/gnuplot-py.git && \
cd gnuplot-py/ && \
python2.7 setup.py install && \
cd ..;rm -rf gnuplot-py

# install java
RUN cd /usr/local/src && \
curl -O http://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/jdk-8u162-linux-x64.tar.gz && \
tar -zxvf jdk-8u162-linux-x64.tar.gz -C /opt && \
alternatives --install /usr/bin/jar jar /opt/jdk1.8.0_162/bin/jar 1 && \
alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_162/bin/javac 1 && \
alternatives --install /usr/bin/java java /opt/jdk1.8.0_162/bin/java 1 && \
alternatives --install /usr/bin/jps jps /opt/jdk1.8.0_162/bin/jps 1 && \
alternatives --set jar /opt/jdk1.8.0_162/bin/jar && \
alternatives --set javac /opt/jdk1.8.0_162/bin/javac && \
alternatives --set java /opt/jdk1.8.0_162/bin/java && \
alternatives --set jps /opt/jdk1.8.0_162/bin/jps && \
rm -rf jdk-8u162-linux-x64.tar.gz

# Add docker account
RUN useradd docker && echo "docker:docker" | chpasswd && \
echo 'docker    ALL=(ALL)   NOPASSWD:ALL' >> /etc/sudoers

# Environment variables
RUN echo "alias vi='/usr/local/bin/vim'" >> ~/.bashrc && \
echo "alias vi='/usr/local/bin/vim'" >> /home/docker/.bashrc && \
echo "alias sqltasdb=\"sqlplus64 'tasadm/tasadm@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.1.120)(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=tctas)))'\"" >> /home/docker/.bashrc && \
echo "export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib" >> ~/.bashrc && \
echo "ldconfig" >> ~/.bashrc && \
echo "sudo ldconfig" >> /home/docker/.bashrc

#**************************
#*  Config Startup Items  *
#**************************
# Add vim rc
ADD .vimrc /home/docker/
ADD .flake8 /home/docker/
ADD oam_sample.tar.gz /home/docker/
RUN mv /home/docker/oam_sample /home/docker/oam

RUN chmod +x /tmp/devenv.sh && \
sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers && \
# Initialize MySQL database and set Mysql root password
su - docker -c "export MYSQL_PASS=P@ssw0rd;export MYSQL_DB=tctas;export MYSQL_CLIENTADDR=%; \
export APP_USER=tasadm;export APP_PASS=tasadm;/tmp/devenv.sh" && \
echo ". ~/oam/oamrtenv.sh" >> /home/docker/.bashrc && \
echo "fabfile = ~/oam/lib/fabfile.py" >> /home/docker/.fabricrc && \
chown -R docker:docker /home/docker

# Install vim plugin
# Color scheme
# Setup Pathogen to manage your plugins
# Settings for ctrlp
# Settings for vim-powerline
# Settings for jedi-vim
# Python folding
# Settings for NERDTree
RUN su - docker -c "mkdir -p ~/.vim/colors && cd ~/.vim/colors; \
    wget -O wombat256mod.vim http://www.vim.org/scripts/download_script.php?src_id=13400; \
    mkdir -p ~/.vim/autoload ~/.vim/bundle; \
    curl -so ~/.vim/autoload/pathogen.vim \
    https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim; \
    cd ~/.vim/bundle; git clone https://github.com/kien/ctrlp.vim.git;\
    cd ~/.vim/bundle;git clone git://github.com/Lokaltog/vim-powerline.git;\
    cd ~/.vim/bundle;git clone git://github.com/davidhalter/jedi-vim.git;\
    cd ~/.vim/bundle;git clone https://github.com/nvie/vim-flake8;\
    mkdir -p ~/.vim/ftplugin;\
    wget -O ~/.vim/ftplugin/python_editing.vim http://www.vim.org/scripts/download_script.php?src_id=5492;\
    cd ~/.vim/bundle;git clone https://github.com/scrooloose/nerdtree.git"

# for pip 9.0.1
RUN su - docker -c "mkdir -p ~/.pip; \
    echo "[list]" >> /home/docker/.pip/pip.conf;\
    echo "format=columns" >> /home/docker/.pip/pip.conf"

USER docker
WORKDIR /home/docker

CMD /bin/bash

#****************************
#* Expose Applicatoin Ports *
#****************************
# Expose ports to other containers only

EXPOSE 3306
