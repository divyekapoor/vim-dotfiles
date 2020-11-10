#!/bin/bash

if [[ "$(uname)" != "Darwin" ]]; then
  sudo apt install vim bash-completion python-optcomplete htop -y
  echo "Install ITerm shell integration"
  curl -L https://iterm2.com/shell_integration/bash -o ~/.iterm2_shell_integration.bash
elif [[ "$(uname)" == "Darwin" ]]; then
  # Set up locatedb
  sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

  # Turn off Mac's diacritics accent menus which trigger on holding down "e" and other keys.
  # https://superuser.com/questions/1257641/disable-mac-typing-accent-menu
  defaults write -g ApplePressAndHoldEnabled -bool false

  if [[ "$(command -v brew)" == "" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi

  # Regular deps
  brew install fzf zsh-completions bash-completion htop ag bash-git-prompt mysql rustup yarn
  rustup-init

  # YCM requirements
  brew install cmake macvim python mono go nodejs

fi

set -e
echo "Cloning Vundle's git repo."
rm -rf ~/.vim/bundle/Vundle.vim
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

echo "Setting up the bash prompt."
rm -rf ~/.bash-git-prompt
git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1

echo "Setting up the zsh prompt."
rm -rf ~/.zsh-git-prompt
git clone https://github.com/olivierverdier/zsh-git-prompt.git ~/.zsh-git-prompt --depth=1

echo "Setting up FZF"
rm -rf ~/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo "Setting up oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install YCM.
cd ~/.vim/bundle/YouCompleteMe && python3 install.py --all
cd -

echo "Please source your .bashrc or .zshrc to continue."
echo "Done"
