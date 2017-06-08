#!/bin/sh

# INSTALL NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash

# INSTALL BREW
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update
brew upgrade

# INSTALL UTILS
brew install tree
brew install git
brew install git-flow-avh
brew install wget

# INSTALL CASK
brew tap caskroom/cask
brew tap caskroom/versions

# INSTALL GUI APPS
# random stuff
brew cask install skype
brew cask install telegram-desktop
brew cask install slack
brew cask install teamviewer
brew cask install ccleaner
brew cask install vlc
brew cask install transmission
brew cask install libreoffice
brew cask install cakebrew
brew cask install spectacle
brew cask install ilya-birman-typography-layout
brew cask install itsycal
brew cask install f.lux

# browsers
brew cask install google-chrome
brew cask install opera
brew cask install firefox
brew cask install firefoxdeveloperedition

# editors
brew cask install sublime-text
brew cask install atom
brew cask install visual-studio-code

# devtools
brew cask install iterm2
brew cask install virtualbox
brew cask install vagrant
brew cask install tunnelblick
brew cask install filezilla
brew cask install zeplin
brew cask install owncloud

# screensaver
brew cask install aerial


# INSTALL POWERLINE FONTS
mkdir ~/tmp && cd ~/tmp
git clone https://github.com/powerline/fonts.git
cd fonts
sh -c ./install.sh
cd ~/tmp && rm -rf ./fonts

# ZSH
# Install Oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Set zsh as default shell
chsh -s /bin/zsh
