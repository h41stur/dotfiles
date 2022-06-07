!/bin/bash

#if [ "$EUID" -ne 0 ]
#then
#		echo "Rode com sudo!"
#		exit
#fi

echo -e "Qual SO?\n"
echo -e "\n[1] Arch\n[2] Debian Based\n"

read -p '> ' OS

DEP=$(which bspwm sxhkd | wc -l)
DIR=$(pwd)
USERINSTALL=$(whoami)

if [ $OS -eq 1 ]
then
		INSTALLER="sudo pacman -S"
else
		INSTALLER="sudo apt install"
fi

# INSTALLER
installer() {

		# UPDATE
		if [ $OS -eq 1 ]
		then
				sudo pacman -Syu
		else
				sudo apt update
				sudo apt upgrade -y
		fi

		# INSTALLING BSPWM
		$INSTALLER bspwm sxhkd
		mkdir -p $HOME/.config/bspwm
		mkdir -p $HOME/.config/sxhkd
		cp bspwm/bspwmrc $HOME/.config/bspwm/
		if [ $OS = '1' ]
		then
				cp sxhkd/sxhkdrcarch $HOME/.config/sxhkd/sxhkdrc
		else
				cp sxhkd/sxhkdrcdeb $HOME/.config/sxhkd/sxhkdrc
		fi

		chmod +x $HOME/.config/bspwm/bspwmrc $HOME/.config/sxhkd/sxhkdrc
		echo -e "[+] Aguarde a instalacao, faca login escolhendo o bspwm e rode o installer novamente."
}

if [ $DEP -lt '2' ]
then
		installer
fi

# FEH ROFI COMPTON
$INSTALLER feh rofi compton
cp -r .wallpapers/ $HOME
cp .fehbg $HOME
cp -r rofi/ $HOME/.config/

# NUMLOCKX
$INSTALLER numlockx

# FONTS
mkdir -p $HOME/.local/share/fonts
cp -r fonts/* $HOME/.local/share/fonts/
fc-cache -fv

# I3LOCK
$INSTALLER i3lock

# POLYBAR
if [ $OS = '1' ]
then
	sudo pacman -S arandr
	YAY=$(which yay | wc -l)
	sudo rm /var/lib/pacman/db.lck
	if [ $YAY -lt '1' ]
	then
		cd $HOME
		git clone https://aur.archlinux.org/yay.git
		cd yay/
		makepkg -si
		cd $DIR 
		$INSTALLER bash-completion
	fi
	yay -S polybar ulauncher
	mkdir -p $HOME/.config/ulauncher/user-themes/
 	cp -R $DIR/Xfce-Setup-02/Theme\ Ulauncher/* $HOME/.config/ulauncher/user-themes/
else
	sudo apt install polybar
fi
	
cp -r polybar/ $HOME/.config/

# CASE INSENSITIVE
cp .inputrc $HOME

# KEYBOARD
cp -r .prog/ $HOME
sudo ln -sf /home/$USERINSTALL/.prog/keyb /usr/bin/keyb
sudo cp -f keyboard /etc/default/
sudo ln -sf /home/$USERINSTALL/.prog/sxhkd-help /usr/bin/sxhkd-help

# VIM
cp .vimrc $HOME
sudo cp .vimrc /root/

# ALACRITTY
$INSTALLER alacritty
cp .bashrc $HOME/
sudo cp .bashrcroot /root/.bashrc
cp -r alacritty/ $HOME/.config/
sudo mkdir -p /root/.config
sudo cp -r alacritty /root/.config

# PRINT
#$INSTALLER scrot xclip
$INSTALLER flameshot

# TOUCHPAD
sudo cp 50-libinput.conf /etc/X11/xorg.conf.d/

# RODAR JAVA APPLICATIONS
$INSTALLER wmname

# MOUSE
$INSTALLER xorg-xsetroot

# CARACTERES
sudo localectl set-locale LANG=en_US.UTF-8

# THEME
sudo cp -f gtkrc /usr/share/gtk-2.0/gtkrc

# TERMINAL
$INSTALLER exa
cp .bash-preexec.sh $HOME

# RESTART
echo -e "[+] Aguarde a instalacao e reinicie a maquina"
