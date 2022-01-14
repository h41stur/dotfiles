#!/bin/sh


echo "Qual SO?\n"
echo "\n[1] Arch\n[2] Debian Based\n"

read -p '> ' OS

DEP=$(which bspwm sxhkd | wc -l)

# INSTALLER
installer() {
	if [ $OS = '1'  ]
	then
			INSTALLER="pacman -S"
	else
			INSTALLER="apt install"
	fi

	# UPDATING
	if [ $OS = '1'  ]
	then
			sudo pacman -Syu
	else
			sudo apt update && sudo apt upgrade -y
	fi

	# INSTALLING BSPWM
	sudo $INSTALLER bspwm sxhkd
	mkdir -p ~/.config/{bspwm,sxhkd}
	cp bspwm/bspwmrc ~/.config/bspwm/
	if [ $OS = '1'  ]
	then
			cp sxhkd/sxhkdrcarch ~/.config/sxhkd/sxhkdrc
	else
			cp sxhkd/sxhkdrcdeb ~/.config/sxhkd/sxhkdrc
	fi

	chmod +x ~/.config/bspwm/bspwmrc ~/.config/sxhkd/sxhkdrc
}

if [ $DEP -lt '2' ]
then
		installer
fi

# FEH ROFI COMPTON
sudo $INSTALLER feh rofi compton
cp -r .wallpapers/ ~/
cp .fehbg ~/
cp -r rofi/ ~/.config/

# NUMLOCKX
sudo $INSTALLER numlockx

# FONTS
mkdir -p ~/.local/fonts
cp fonts/*.ttf ~/.local/fonts/
cp fonts/*.otf ~/.local/fonts/
fc-cache -fv

# POLYBAR
sudo $INSTALLER polybar
cp -r polybar/ ~/.config/

# CASE INSENSITIVE
cp .inputrc ~/

# KEYBOARD
cp -r .prog/ ~/
sudo ln -sf $HOME/.prog/keyb /usr/bin/keyb

# RESTART
sudo shutdown -r now
