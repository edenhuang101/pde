#!/bin/bash
# check prerequisite packages
echo "Check essential packages ......."
essentail_packages='kernel-devel gcc gcc-c++ make automake zlib-devel bzip2-devel
                    openssl-devel ncurses-devel automake openssh net-snmp-utils
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

# prompt User to be continue or breake installation
cat << EOF

Before install python, please make sure the all of essential packages has been installed.
EOF
if [ -n "$unistanll_packages" ]; then
    echo -e "for now , these packages are not installed\n"
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
cd /usr/local/src &&
if [ -d /usr/local/src/python-smpplib ]; then
    rm -rf python-smpplib python-smpplib-master
fi
/usr/local/bin/pip install --upgrade pip && \
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
/usr/local/bin/easy_install-2.7 prettytable && \
cd /usr/local/src && wget -O python-smpplib.zip https://github.com/podshumok/python-smpplib/archive/master.zip && \
unzip python-smpplib.zip && mv python-smpplib-master python-smpplib && \
cd python-smpplib && python2.7 setup.py install

# install mailsend
cd /usr/local/src &&
if [ -d /usr/local/src/mailsend ]; then
    rm -rf mailsend mailsend-master
fi
cd /usr/local/src && wget -O mailsend.zip https://github.com/muquit/mailsend/archive/master.zip && \
unzip mailsend.zip && mv mailsend-master mailsend && \
cd mailsend && /bin/sh ./configure --with-openssl=/usr && \
make install

# install vim
if [ -d /usr/local/src/vim ]; then
    rm -rf /usr/local/src/vim
fi
cd /usr/local/src && hg clone https://vim.googlecode.com/hg/ vim && \
echo "/usr/local/lib" >> /etc/ld.so.conf && ldconfig && \
export vi_cv_path_python=/usr/local/bin/python2.7 && \
export vi_cv_path_python_pfx=/usr/local && \
cd vim/src && \
./configure --enable-pythoninterp --with-features=huge --with-python-config-dir=/usr/local/lib/python2.7/config && \
make && make install
