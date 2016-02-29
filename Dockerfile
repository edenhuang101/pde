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

RUN yum clean all && \
yum -y update && \
# yum -y groupinstall "Development tools" && \
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel  && \
yum -y install sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel && \
yum -y install make automake gcc gcc-c++ kernel-devel git-core && \
yum -y install wget tar sudo hg unzip which tree && \
yum -y install openssh* net-snmp-utils nmap tcpdump && \
# Install MySQL
yum -y localinstall http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm && \
yum -y install mysql-community-server && \
yum -y install mysql-community-devel && \
rm -fr /var/cache/*

# Install python
RUN wget https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz && \
tar -zxf Python-2.7.10.tgz && \
cd Python-2.7.10 && \
./configure --prefix=/usr/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" && \
make && make altinstall && \
rm -f Python-2.7.10.tgz && \
rm -rf Python-2.7.10 && \
# Install ezsetup and pip
wget https://bootstrap.pypa.io/ez_setup.py -O - | /usr/local/bin/python2.7 && \
/usr/local/bin/easy_install-2.7 pip

# Install python plugin
RUN /usr/local/bin/pip install --upgrade pip && \
/usr/local/bin/pip install fabric && \
/usr/local/bin/pip install ipython && \
/usr/local/bin/pip install flake8 && \
/usr/local/bin/pip install fake-factory && \
/usr/local/bin/pip install MySQL-python && \
/usr/local/bin/pip install python-daemon && \
/usr/local/bin/pip install ecks && \
/usr/local/bin/pip install python-nmap && \
/usr/local/bin/pip install scapy && \
/usr/local/bin/pip install ping && \
/usr/local/bin/pip install jedi && \
/usr/local/bin/easy_install-2.7 path.py && \
/usr/local/bin/easy_install-2.7 Ptable && \
cd /usr/local/src && wget -O python-smpplib.zip https://github.com/podshumok/python-smpplib/archive/master.zip && \
unzip python-smpplib.zip && mv python-smpplib-master python-smpplib && \
cd python-smpplib && python2.7 setup.py install

# install mailsend
RUN cd /usr/local/src && wget -O mailsend.zip https://github.com/muquit/mailsend/archive/master.zip && \
unzip mailsend.zip && mv mailsend-master mailsend && \
cd mailsend && /bin/sh ./configure --with-openssl=/usr && \
make install

# install vim
RUN hg clone https://vim.googlecode.com/hg/ vim && \
export vi_cv_path_python=/usr/local/bin/python2.7 && \
export vi_cv_path_python_pfx=/usr/local && \
cd /vim/src && \
./configure LDFLAGS="-Wl,--rpath=/usr/local/lib" --enable-pythoninterp \
            --with-features=huge --with-python-config-dir=/usr/local/lib/python2.7/config && \
make && make install

# Add docker account
RUN useradd docker && echo "docker:docker" | chpasswd && \
echo 'docker    ALL=(ALL)   NOPASSWD:ALL' >> /etc/sudoers

# Environment variables
RUN echo "alias vi='/usr/local/bin/vim'" >> ~/.bashrc && \
echo "alias vi='/usr/local/bin/vim'" >> /home/docker/.bashrc && \
echo "ldconfig" >> ~/.bashrc && \
echo "sudo ldconfig" >> /home/docker/.bashrc

#**************************
#*  Config Startup Items  *
#**************************
# Add vim rc
ADD .vimrc /home/docker/
ADD .flake8 /home/docker/

RUN chmod +x /tmp/devenv.sh && \
sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers && \
# Initialize MySQL database and set Mysql root password
su - docker -c "export MYSQL_PASS=P@ssw0rd;export MYSQL_DB=tctas;export MYSQL_CLIENTADDR=%; \
export APP_USER=tasadm;export APP_PASS=tasadm;/tmp/devenv.sh" && \
echo ". ~/oam/oamrtenv.sh" >> /home/docker/.bashrc && \
ln -s /home/docker/dev_data/oam /home/docker/oam && \
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

USER docker
WORKDIR /home/docker

CMD /bin/bash

#****************************
#* Expose Applicatoin Ports *
#****************************
# Expose ports to other containers only

EXPOSE 3306
