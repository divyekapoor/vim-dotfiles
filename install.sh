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
  echo "Adding to .bash_aliases"
  if [ -f ~/.bash_aliases ]; then
    echo . ~/.aliases >> ~/.bash_aliases
  fi
fi

echo "Done"
