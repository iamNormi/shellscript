#!/bin/sh

#custom time format
#%a %d %b, %I:%M %p

#remove unwanted tools

sudo apt purge pidgin gnome-software xfce4-notes gnome-menus gnome-mines gnome-sudoku parole ristretto gimp gnome-themes-extra gnome-font-viewer sgt* thunderbird firefox transmission-* snapd gnome-themes-extra ; sudo apt autoremove


### install required tools ###

sudo apt install xclip jq font-manager rofi axel git mpv ffmpeg python3-pip gnome-disk-utility ncdu virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso elinks w3m lynx git conky light

#install fonts
sudo apt install fonts-firacode fonts-cantarell

#install yt-dlp , youtube-dl
sudo apt purge youtube-dl ; pip3 install yt-dlp youtube-dl 
sudo apt autoremove


#Install librewolf
#https://deb.librewolf.net
sudo apt install wget
echo "deb [arch=amd64] https://deb.librewolf.net $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/librewolf.list
sudo wget https://deb.librewolf.net/keyring.gpg -O /etc/apt/trusted.gpg.d/librewolf.gpg 
sudo apt update ; sudo apt install librewolf -y
#librewolf extensions 
echo "Installing Dracula theme for librewolf..."
librewolf https://addons.mozilla.org/en-US/firefox/addon/dracula-dark-colorscheme/

echo "Install dark viewer add-on in librewolf..."
librewolf https://addons.mozilla.org/en-US/firefox/addon/darkreader/

#install exa
sudo apt install wget
sudo apt install curl
cd ; EXA_VERSION=$(curl -s "https://api.github.com/repos/ogham/exa/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+') 
curl -Lo exa.zip "https://github.com/ogham/exa/releases/latest/download/exa-linux-x86_64-v${EXA_VERSION}.zip"
sudo unzip -q exa.zip bin/exa -d /usr/local
cd
rm exa.zip

#install advcpmv
cd
set -e
ADVCPMV_VERSION=${1:-0.9}
CORE_UTILS_VERSION=${2:-9.0}

wget http://ftp.gnu.org/gnu/coreutils/coreutils-$CORE_UTILS_VERSION.tar.xz
tar xvJf coreutils-$CORE_UTILS_VERSION.tar.xz
rm coreutils-$CORE_UTILS_VERSION.tar.xz
(
    cd coreutils-$CORE_UTILS_VERSION/
    wget https://raw.githubusercontent.com/jarun/advcpmv/master/advcpmv-$ADVCPMV_VERSION-$CORE_UTILS_VERSION.patch
    patch -p1 -i advcpmv-$ADVCPMV_VERSION-$CORE_UTILS_VERSION.patch
    ./configure
    make
    cp ./src/cp ../advcp
    cp ./src/mv ../advmv
)
rm -rf coreutils-$CORE_UTILS_VERSION
sudo cp -v advcp /usr/local/bin
sudo cp -v advmv /usr/local/bin

cd ; rm -vrf advcpmv

#install xdm from https://github.com/subhra74/xdm/releases
cd
XDM_VER=$(curl -s "https://api.github.com/repos/subhra74/xdm/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
curl -Lo xdm.tar.xz "https://github.com/subhra74/xdm/releases/download/${XDM_VER}/xdm-setup-${XDM_VER}.tar.xz"
tar -xvf xdm.tar.xz ; sudo bash install.sh ; rm -v install.sh readme.txt xdm.tar.xz ; cd  

#install Telegram from https://github.com/telegramdesktop/tdesktop/releases/ 
#https://desktop.telegram.org/
cd
TG_VER=$(curl -s "https://api.github.com/repos/telegramdesktop/tdesktop/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
curl -Lo tsetup.tar.xz "https://github.com/telegramdesktop/tdesktop/releases/download/v${TG_VER}/tsetup.${TG_VER}.tar.xz"
tar -xvf tsetup.tar.xz ; mkdir -pv ~/.telegram ; cp -vrf Telegram/* ~/.telegram
cd

#install Bitwardern
cd
BITW_VER=$(curl -s "https://github.com/bitwarden/desktop/releases/latest" | grep releases | sed -E 's/.*"([^"]+)".*/\1/' | grep -Po "v\K[0-9.]+") 
curl -Lo bitw.deb https://github.com/bitwarden/desktop/releases/download/v${BITW_VER}/Bitwarden-${BITW_VER}-amd64.deb
sudo dpkg -i bitw.deb ; rm -v bitw.deb
cd

#install oh-my-zsh
#HTTps://ohmyz.sh/
sudo apt install zsh curl ; sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


