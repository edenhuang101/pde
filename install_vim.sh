#!/bin/bash
echo "Check python version  ......."
#Check whether python is installed
if [ -f /usr/local/bin/python2.7 ];then
    local_python=$(/usr/local/bin/python2.7 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
    echo "Current local python version $local_python"
else
    echo "Do not yet install local python"
    exit
fi
# Show current OS python version
python_version=$(/usr/bin/python -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
python_major=$(/usr/bin/python -c 'import sys; print(".".join(map(str, sys.version_info[0:1])))')
python_minor=$(/usr/bin/python -c 'import sys; print(".".join(map(str, sys.version_info[1:2])))')
if [[ -z "$python_version" ]]; then
    echo "No Python!"
else
    echo "Current OS python version $python_version"
fi

# prompt User to be continue or breake installation
cat << EOF
Start to install vim 7.4 ....
EOF
read -p "Press [Enter] key to continue... or Ctrl+C to cancel"

# install vim
if [ -d /usr/local/src/vim ]; then
    rm -rf /usr/local/src/vim
fi
cd /usr/local/src && hg clone https://bitbucket.org/vim-mirror/vim vim && \
export LD_LIBRARY_PATH=/usr/local/lib && \
export vi_cv_path_python=/usr/local/bin/python2.7 && \
export vi_cv_path_python_pfx=/usr/local && \
cd vim/src && \
./configure LDFLAGS="-Wl,--rpath=/usr/local/lib" --enable-pythoninterp --with-features=huge --with-python-config-dir=/usr/local/lib/python2.7/config && \
make && make install
vim --version
