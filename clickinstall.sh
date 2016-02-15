#!/bin/bash
# Install python
wget https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz && \
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
cd /usr/local/src && wget -O mailsend.zip https://github.com/muquit/mailsend/archive/master.zip && \
unzip mailsend.zip && mv mailsend-master mailsend && \
cd mailsend && /bin/sh ./configure --with-openssl=/usr && \
make install

# install vim
hg clone https://vim.googlecode.com/hg/ vim && \
echo "/usr/local/lib" >> /etc/ld.so.conf && ldconfig && \
export vi_cv_path_python=/usr/local/bin/python2.7 && \
export vi_cv_path_python_pfx=/usr/local && \
cd /vim/src && \
./configure --enable-pythoninterp --with-features=huge --with-python-config-dir=/usr/local/lib/python2.7/config && \
make && make install
