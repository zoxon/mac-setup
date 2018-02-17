#!/bin/sh

# INSTALL NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash


# HOMEBREW
# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update
brew upgrade

# INSTALL UTILS
brew install tree
brew install git
brew install git-flow-avh
brew install wget
brew install vim
brew install ctags
brew install watchman
brew install p7zip
brew install trash

# INSTALL CASK
brew tap caskroom/cask
brew tap caskroom/versions

# QUICK LOOK PLUGINS
brew cask install qlcolorcode
brew cask install qlstephen
brew cask install qlmarkdown
brew cask install quicklook-json
brew cask install qlprettypatch
brew cask install quicklook-csv
brew cask install betterzipql
brew cask install webpquicklook
brew cask install suspicious-package
brew cask install qlimagesize
brew cask install quicklookase
brew cask install qlvideo
brew cask install quicklook-pat
brew cask install epubquicklook


# INSTALL GUI APPS
# Messengers
brew cask install skype
brew cask install telegram
# brew cask install telegram-desktop
brew cask install slack

# Utils
brew cask install michaelvillar-timer
brew cask install cheatsheet
brew cask install ilya-birman-typography-layout
brew cask install transmission
brew cask install teamviewer
brew cask install ccleaner
brew cask install cakebrew
brew cask install spectacle
brew cask install itsycal
brew cask install f.lux
brew cask install android-file-transfer
brew cask install the-unarchiver

# Other
brew cask install vlc
brew cask install iina
brew cask install libreoffice
brew cask install commander-one
brew cask install spotify
brew cask install steam
brew cask install tunnelbear

# Browsers
brew cask install google-chrome
brew cask install opera
brew cask install firefox
brew cask install firefoxdeveloperedition

# Editors
brew cask install sublime-text
brew cask install atom
brew cask install visual-studio-code

# Devtools
brew cask install iterm2
brew cask install virtualbox
brew cask install vagrant
brew cask install tunnelblick
brew cask install filezilla
brew cask install zeplin
brew cask install owncloud

# Screensaver
brew cask install aerial
brew cask install padbury-clock

# Enabling Automatic Brew Updates & Upgrades
brew tap domt4/autoupdate
brew autoupdate --start --upgrade

# Brew cleanup
brew cleanup
brew cask cleanup


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
