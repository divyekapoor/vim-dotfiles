#!/bin/bash
set -e
echo "Cloning Vundle's git repo."
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
echo "Install .vimrc"
cp .vimrc $HOME/
echo "Running :BundleInstall"
vim -S install.vim
echo "Done"
