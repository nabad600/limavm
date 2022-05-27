#!/bin/sh

# Install MacPort tools
blanko=" ";
pkg=`pkgutil --packages | grep macports`
if [ "$pkg" == "$blanko" ]; then
    MACPORTS=`sw_vers -productVersion | awk -F '.' '{print $1}'`
    curl -L -o macprots-${MACPORTS}.pkg "https://github.com/nabad600/limavm/releases/download/v1.1.1/MacPorts-${MACPORTS}.pkg"
    sudo mkdir /Users/${whoami}/qemu
    sudo installer -verbose -pkg macprots-${MACPORTS}.pkg -target /Users/${whoami}/qemu
    sudo echo "export PATH=$PATH:/opt/local/bin" >> ~/.bash_profile
    source ~/.bash_profile
    rm -rf macprots-${MACPORTS}.pkg
else
    echo "MacPorts Already install in your system"
fi

# Install Xcode command line tools
# xcode-select -p 1>/dev/null 2>/dev/null
# checkXcode=$?
# if [ $checkXcode != 0 ]; then
#   echo
#   echo "Please install Xcode command line tools first using"
#   echo "$(tput setaf 6)xcode-select --install$(tput sgr0)"
#   echo
#   exit 1
# fi
# # Install MacPorts
# xcode-select --install

# # Install Homebrew arm64
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(logname)/.zprofile
# eval "$(/opt/homebrew/bin/brew shellenv)"

# Install necessary packages for building
# brew install qemu
blankq=" ";
qemu_version=`qemu-system-${uname -p} --version`
if [ "$qemu_version" == "$blankq" ]; then
    yes Y | sudo port install qemu
else
    echo "Qemu already install in your system"
fi

# Check actual release tag
blankl=" ";
limavm=`limactl --version`
if [ "$limavm" == "$blankl" ]; then
    VERSION=$(curl -s https://api.github.com/repos/lima-vm/lima/releases/latest \
    | grep "tag_name" \
    | awk '{print substr($2, 2, length($2)-3)}')
    # Download latest release version or extract /usr/local/
    curl -L -o lima.tar.gz "https://github.com/lima-vm/lima/releases/download/${VERSION}/lima-${VERSION:1}-$(uname -s)-$(uname -m).tar.gz"
    tar -xvf lima.tar.gz 
    sudo cp bin/* /usr/local/bin/
    sudo cp -a share/* /usr/local/share/
    rm -rf bin
    rm -rf share
    rm -rf lima.tar.gz
else
    echo "Lima VM already install in your system"
# Create Deck-app VM
limactl start --name=deck-app https://raw.githubusercontent.com/deck-app/stack-preview-screen/main/symfony/deck-app.yaml
# Alias docker command
sudo echo 'alias docker="limactl shell deck-app docker"' >> ~/.bash_profile
source ~/.bash_profile

# STR='alias docker="limactl shell deck-app docker"'
# SUB='/Users/nabakr.das/.zshrc'

# if [[ "$STR" =~ .*"$SUB".* ]]; then
#   echo "It's there."
# fi
