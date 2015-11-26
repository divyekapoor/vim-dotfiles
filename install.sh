#!/bin/bash
set -e
echo "Cloning Vundle's git repo."
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/Vundle.vim
echo "Install .vimrc"
cp .vimrc $HOME/
echo "Running :PluginInstall"
vim -S install.vim
echo "PluginInstall done."

if [ ! -f ~/.aliases ]; then
  echo "Copying .aliases"
  cp .aliases ~/.aliases
  if [ -f ~/.bash_aliases ]; then
    echo "Adding to .bash_aliases"
    echo . ~/.aliases >> ~/.bash_aliases
  fi
fi

echo "Please source your .bashrc to continue."
echo "Done"
