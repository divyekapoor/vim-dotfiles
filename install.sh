#!/bin/bash

if [[ "$(uname)" != "Darwin" ]]; then
  sudo apt install curl vim bash-completion htop nethogs iotop silversearcher-ag docker.io python3-dev cmake zsh clang golang-go gh x11-xkb-utils x11-xserver-utils ssh-import-id vim-youcompleteme vim-addon-manager qemu-guest-agent git-crypt scrypt gpg nfs-common -y
  echo "Enabling SSH with github keys."
  ssh-import-id gh:divyekapoor
  echo "Enabling YCM with vim-addon-manager"
  vim-addon-manager install youcompleteme
  echo "Install ITerm shell integration"
  curl -L https://iterm2.com/shell_integration/bash -o ~/.iterm2_shell_integration.bash
  echo "Enabling QEMU guest agent."
  sudo service start qemu-guest-agent
  echo "Enabling docker for the user without root permissions."
  sudo usermod -aG docker $USER && newgrp docker
  echo "Installing SSH Keys."
  scrypt dec ssh.tar.gz.scrypt ssh.tar.gz && tar xvzf ssh.tar.gz --directory $HOME && rm ssh.tar.gz
  echo "Importing GPG Key."
  gpg --import ~/.ssh/divye-mac.gpg.private
  expect -c 'spawn gpg --edit-key divyekapoor@gmail.com trust quit; send "5\ry\r"; expect eof'
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
  brew install cmake macvim python mono go nodejs gh

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

echo "Setting up Github"
gh auth login

echo "Setting up oh-my-zsh. Please exit the zsh shell to continue the install."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install YCM.
echo "Please source your .bashrc or .zshrc to continue."
echo "Done"
