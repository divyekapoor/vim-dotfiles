#!/bin/bash

if [[ "$(uname)" != "Darwin" ]]; then
  sudo apt-get install vim -y
  echo "Install ITerm shell integration"
  curl -L https://iterm2.com/shell_integration/bash -o ~/.iterm2_shell_integration.bash
fi

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

echo "Setting up git."
cp -i .gitconfig ~/.gitconfig

echo "Setting up the prompt."
git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1

echo "Setting up FZF"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo "Please source your .bashrc to continue."
echo "Done"
