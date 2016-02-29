#!/bin/bash

# check vim version
/usr/bin/vim --version > /dev/null 2>&1
if [ $? = 0 ]; then
    is_os_vim="True"
    echo "OS vim has been installed"
    /usr/bin/vim --version |head -1
fi
/usr/local/bin/vim --version > /dev/null 2>&1
if [ $? = 0 ]; then
    is_local_vim="True"
    echo "Local vim has been installed"
    /usr/local/bin/vim --version |head -1
fi
if [ -z $is_local_vim ] && [ -z $is_os_vim ]; then
   echo "Do not yet install vim"
   exit
fi
read -p "Press [Enter] key to continue... or Ctrl+C to cancel installation"

# install vim plugin
install_vim_plugin()
{
if [ "$is_local_vim" == "True" ] || [ "$is_os_vim" == "True" ]; then
    mkdir -p ~/.vim/colors && cd ~/.vim/colors
    wget -O wombat256mod.vim http://www.vim.org/scripts/download_script.php?src_id=13400 && \
    mkdir -p ~/.vim/ftplugin
    wget -O ~/.vim/ftplugin/python_editing.vim http://www.vim.org/scripts/download_script.php?src_id=5492 && \
    mkdir -p ~/.vim/autoload ~/.vim/bundle
    curl -so ~/.vim/autoload/pathogen.vim \
    https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
    cd ~/.vim/bundle;git clone https://github.com/kien/ctrlp.vim.git;  \
    cd ~/.vim/bundle;git clone git://github.com/Lokaltog/vim-powerline.git; \
    cd ~/.vim/bundle;git clone https://github.com/nvie/vim-flake8 ;\
    cd ~/.vim/bundle;git clone https://github.com/scrooloose/nerdtree.git
    # get config file
    wget -O ~/.vimrc  http://54.183.79.133/vimrc &&  \
    wget -O ~/.flake8  http://54.183.79.133/flake8 && \
    mkdir -p $HOME/.config && \
    wget -O $HOME/.config/flake8  http://54.183.79.133/flake8
fi
}

# Set vim path
last_line=$(tail -1 ~/.bashrc)
if [ "$is_local_vim" == "True" ]; then
    if [ ! "$last_line" == "export EDITOR=/usr/local/bin/vim" ]; then
        install_vim_plugin
        cd ~/.vim/bundle;git clone git://github.com/davidhalter/jedi-vim.git; \
        /usr/local/bin/vim --version |head -1
        echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
        echo "alias vi='/usr/local/bin/vim'" >> ~/.bashrc
        echo "export EDITOR=/usr/local/bin/vim" >> ~/.bashrc
        source $HOME/.bashrc
        echo "local vim plugin install succeeded"
        echo ""
        echo ##########################################################
        echo # Please Logout and login to let vim plugin take effect  #
        echo # or source ~/.bashrc                                    #
        echo ##########################################################
    else
        echo "It's done before"
    fi
elif [ "$is_os_vim" == "True" ]; then
    if [ ! "$last_line" == "export EDITOR=/usr/bin/vim" ]; then
        install_vim_plugin
        /usr/bin/vim --version |head -1
        echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
        echo "alias vi='/usr/bin/vim'" >> ~/.bashrc
        echo "export EDITOR=/usr/bin/vim" >> ~/.bashrc
        source $HOME/.bashrc
        echo "OS vim plugin install succeeded"
        echo ##########################################################
        echo # Please Logout and login to let vim plugin take effect  #
        echo # or source ~/.bashrc                                    #
        echo ##########################################################
    else
        echo "It's done before"
    fi
else
   echo "Do not yet install vim"
fi
