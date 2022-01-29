#!/bin/bash

dir=$(pwd)

sudo pacman -S bash-completion
sudo pacman -S firefox

# ADICIONANDO WINDOWS
sudo pacman -S os-prober
sudo os-prober
sudo fdisk -l
echo "Insira a particao"
read dev

sudo mkdir -p /dev/windows
sudo mount $dev /dev/windows
sudo grub-mkconfig -o /boot/grub/grub.cfg

# APARENCIA
sudo pacman -S git
cd /tmp
git clone http://github.com/vinceliuice/Qogir-theme.git
cd Qogir-theme/
./install.sh
cd ..
git clone http://github.com/vinceliuice/Qogir-icon-theme.git
cd Qogir-icon-theme/
./install.sh
cd src/cursors/
./install.sh
mkdir ~/.fonts
cp -R $dir/Xfce-Setup-02/fonts/* ~/.fonts/
sudo pacman -S plank
mkdir -p ~/.local/share/plank/themes/
cp -R $dir/Xfce-Setup-02/Theme\ Plank/azeny-plank-1.0.0/ ~/.local/share/plank/themes/
plan --preferences

sudo pacman -S --needed base-devel yajl
cd /tmp
git clone https://aur.archlinux.org/package-query.git
cd package-query/
makepkg -si && cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si
yay -S pamac
pamac build ulauncher
mkdir -p ~/.config/ulauncher/user-themes/
cp -R $dir/Xfce-Setup-02/Theme\ Ulauncher/* ~/.config/ulauncher/user-themes/

sudo pacman -S gtk-engine-murrine gtk-engines


# AUDIO
pulseaudio --check
pulseaudio -D

# DEV
sudo pacman -S pycharm-community-edition
yay -S code-git
yay -S google-chrome

