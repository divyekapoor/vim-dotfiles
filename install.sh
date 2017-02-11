#!/bin/bash
sudo apt-get install vim -y
set -e
echo "Cloning Vundle's git repo."
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/Vundle.vim
echo "Install .vimrc"
cp .vimrc $HOME/
echo "Running :PluginInstall"
vim -S install.vim
echo "PluginInstall done."

echo "Installing .emacs"
cp .emacs ~/
cp -r .emacs.d/ ~/

echo "Installing .aliases."
cp -i .aliases ~/.aliases

echo "Adding to .bash_aliases"
echo ". ~/.aliases" >> ~/.bash_aliases

echo "Please source your .bashrc to continue."
echo "Done"
