#!/bin/bash

if [ "$EUID" -ne 0 ]
then
		echo "Rode com sudo!"
		exit
fi

echo -e "Qual SO?\n"
echo -e "\n[1] Arch\n[2] Debian Based\n"

read -p '> ' OS

DEP=$(which bspwm sxhkd | wc -l)
DIR=$(pwd)
USERINSTALL=$SUDO_USER

if [ $OS -eq 1 ]
then
		INSTALLER="pacman -S"
else
		INSTALLER="apt install"
fi

# INSTALLER
installer() {

		# UPDATE
		if [ $OS -eq 1 ]
		then
				pacman -Syu
		else
				apt update && apt upgrade -y
		fi

		# INSTALLING BSPWM
		$INSTALLER bspwm sxhkd
		sudo -u $USERINSTALL mkdir -p /home/$USERINSTALL/.config/{bspwm,sxhkd}
		sudo -u $USERINSTALL cp bspwm/bspwmrc /home/$USERINSTALL/.config/bspwm/
		if [ $OS = '1' ]
		then
				sudo -u $USERINSTALL cp sxhkd/sxhkdrcarch /home/$USERINSTALL/.config/sxhkd/sxhkdrc
		else
				sudo -u $USERINSTALL cp sxhkd/sxhkdrcdeb /home/$USERINSTALL/.config/sxhkd/sxhkdrc
		fi

		sudo -u $USERINSTALL chmod +x /home/$USERINSTALL/.config/bspwm/bspwmrc /home/$USERINSTALL/.config/sxhkd/sxhkdrc
		echo -e "[+] Aguarde a instalacao, faca login escolhendo o bspwm e rode o installer novamente."
}

if [ $DEP -lt '2' ]
then
		installer
fi

# FEH ROFI COMPTON
$INSTALLER feh rofi compton
sudo -u $USERINSTALL cp -r .wallpapers/ /home/$USERINSTALL
sudo -u $USERINSTALL cp .fehbg /home/$USERINSTALL
sudo -u $USERINSTALL cp -r rofi/ /home/$USERINSTALL/.config/

# NUMLOCKX
$INSTALLER numlockx

# FONTS
sudo -u $USERINSTALL mkdir -p /home/$USERINSTALL/.local/share/fonts
sudo -u $USERINSTALL cp -r fonts/* /home/$USERINSTALL/.local/share/fonts/
sudo -u $USERINSTALL fc-cache -fv

# POLYBAR
if [ $OS = '1' ]
then
	pacman -S arandr
	YAY=$(which yay | grep git | wc -l)
	rm /var/lib/pacman/db.lck
	if [ $YAY -lt '1' ]
	then
		cd /home/$USERINSTALL
		sudo -u $USERINSTALL git clone https://aur.archlinux.org/yay.git
		cd yay/
		sudo -u $USERINSTALL makepkg -si
		cd $DIR 
		$INSTALLER bash-completion
	fi
	sudo -u $USERINSTALL yay -S polybar ulauncher
	mkdir -p ~/.config/ulauncher/user-themes/
 	cp -R $dir/Xfce-Setup-02/Theme\ Ulauncher/* ~/.config/ulauncher/user-themes/
else
	apt install polybar
fi
	
sudo -u $USERINSTALL cp -r polybar/ /home/$USERINSTALL/.config/

# CASE INSENSITIVE
sudo -u $USERINSTALL cp .inputrc /home/$USERINSTALL/

# KEYBOARD
sudo -u $USERINSTALL cp -r .prog/ /home/$USERINSTALL/
ln -sf $DIR/.prog/keyb /usr/bin/keyb
cp -f keyboard /etc/default/

# VIM
sudo -u $USERINSTALL cp .vimrc /home/$USERINSTALL

# PRINT
$INSTALLER scrot xclip

# TOUCHPAD
cp 50-libinput.conf /etc/X11/xorg.conf.d/

# RODAR JAVA APPLICATIONS
$INSTALLER wmname

# RESTART
echo -e "[+] Aguarde a instalacao e reinicie a maquina"
