#!/bin/bash
# install vim plugin
mkdir -p ~/.vim/colors && cd ~/.vim/colors; \
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
cd ~/.vim/bundle;git clone https://github.com/scrooloose/nerdtree.git

# get config file
wget -O ~/.vimrc  http://54.183.79.133/vimrc
wget -O ~/.flake8  http://54.183.79.133/flake8

# Set vim path 
echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
echo "alias vi='/usr/local/bin/vim'" >> ~/.bashrc
echo "export EDITOR=/usr/local/bin/vim" >> ~/.bashrc

# Add instruction

cat << EOF
##########################################################
# Please Logout and login to let vim plugin take effect  #
##########################################################
EOF
