#!/bin/bash

# Show current python version
echo "Check OS python version  ......."
python_version=$(python -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
python_major=$(python -c 'import sys; print(".".join(map(str, sys.version_info[0:1])))')
python_minor=$(python -c 'import sys; print(".".join(map(str, sys.version_info[1:2])))')
if [[ -z "$python_version" ]]; then
    echo "No Python!"
else
    #Python is installed
    echo "Current OS python version $python_version"
    echo ""
    parsedVersion=$(echo "${python_version//./}")
    if [[ "$python_major" -eq "2" && "$python_minor" -eq "7" ]];then
        echo "Its major and minor version are same with install version 2.7.10"
        read -p "Press [Enter] key to continue... or Ctrl+C to cancel installation"
    elif [ $python_major -eq 3 ];then
        echo "It's newer than 2.7.10"
        read -p "Press [Enter] key to continue... or Ctrl+C to cancel installation"
    elif [ -f /usr/local/bin/python2.7 ];then
        echo "Already install python 2.7 at /usr/local/bin/python2.7"
	    local_python=$(/usr/local/bin/python2.7 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
        echo "Current local python version $local_python"
        exit
    else
        echo "This script will install python 2.7.10"
    fi
fi

# check prerequisite packages
echo "Check essential packages ......."
essentail_packages='kernel-devel gcc gcc-c++ make automake zlib-devel bzip2-devel sqlite-devel readline-devel
                    openssl-devel ncurses-devel gdbm-devel openssh net-snmp-utils
                    nmap tcpdump git mercurial wget tar unzip'
for package_name in $essentail_packages
do
    if yum list installed "$package_name" >/dev/null 2>&1; then
        echo $package_name "Installed"
    else
        echo $package_name "Not installed"
        unistanll_packages="$unistanll_packages $package_name"
    fi
done

# check mysql-devl
echo "Check mysql-devel packages ......."
mysql_packages='mysql-devel MySQL-devel-community mysql-community-devel'
for package_name in $mysql_packages
do
    if yum list installed "$package_name" >/dev/null 2>&1; then
        echo $package_name "Installed"
	is_mysql_dev_installed="True"
    fi
done

if [ -z "$is_mysql_dev_installed" ]; then
    echo -e "Mysql-devel are not installed"
fi

# prompt User to be continue or breake installation
cat << EOF

Before install python, please make sure the all of essential packages has been installed.

Note:
If no internet, git and mercurial are optional.
If no MySQL, mysql-devel also is an option.

EOF

if [ -n "$unistanll_packages" ]; then
    echo -e "for now , these packages are not installed"
    echo -e "$unistanll_packages\n"
    echo "Installation command:"
    echo "yum clean all && yum -y update && yum -y install $unistanll_packages"
fi
read -p "Press [Enter] key to continue... or Ctrl+C to cancel"

# Install python
cd /usr/local/src &&
wget https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz && \
tar -zxf Python-2.7.10.tgz && \
cd Python-2.7.10 && \
./configure --prefix=/usr/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" && \
make && make altinstall && \
cd /usr/local/src &&
rm -f Python-2.7.10.tgz && \
rm -rf Python-2.7.10 && \
# Install ezsetup and pip
wget https://bootstrap.pypa.io/ez_setup.py -O - | /usr/local/bin/python2.7 && \
/usr/local/bin/easy_install-2.7 pip

# Install python plugin
cd /usr/local/src
if [ -d /usr/local/src/python-smpplib ]; then
    rm -rf python-smpplib python-smpplib-master
fi
/usr/local/bin/pip install --upgrade pip && \
/usr/local/bin/pip install fabric && \
/usr/local/bin/pip install ipython && \
/usr/local/bin/pip install flake8 && \
/usr/local/bin/pip install fake-factory && \
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
/usr/local/bin/easy_install-2.7 path.py && \
/usr/local/bin/easy_install-2.7 Ptable
# insatall MySQL-python
if [ -f /usr/bin/mysql_config ]; then
    /usr/local/bin/pip install MySQL-python
fi
# install smpp library
cd /usr/local/src && wget -O python-smpplib.zip https://github.com/podshumok/python-smpplib/archive/master.zip && \
unzip python-smpplib.zip && mv python-smpplib-master python-smpplib && \
cd python-smpplib && python2.7 setup.py install
if [ $? -gt 0 ]; then
    echo "Install python failed"
else
    echo "Install python succeeded"
fi
read -p "Press [Enter] key to install mailsend 1.8 ... or Ctrl+C to cancel installation"

# install mailsend
cd /usr/local/src &&
if [ -d /usr/local/src/mailsend ]; then
    rm -rf mailsend mailsend-master
fi
cd /usr/local/src && wget -O mailsend.zip https://github.com/muquit/mailsend/archive/master.zip && \
unzip mailsend.zip && mv mailsend-master mailsend && \
cd mailsend && /bin/sh ./configure --with-openssl=/usr && \
make install
