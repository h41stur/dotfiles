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
		$INSTALLER bspwm sxhkd pavuaudio xsettingsd
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
$INSTALLER bat
cp .bash_aliases $HOME

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

# DOCKER
$INSTALLER docker
echo "leonardo ALL=(ALL:ALL) NOPASSWD:/usr/bin/docker" | sudo tee -a /etc/sudoers
echo "leonardo ALL=(ALL:ALL) NOPASSWD:/usr/bin/xhost" | sudo tee -a /etc/sudoers

# TERMINAL
$INSTALLER exa
cp .bash-preexec.sh $HOME

################################################################################

# TMUX
$INSTALLER tmux
$INSTALLER inetutils
$INSTALLER ruby
$INSTALLER jq

if [ $OS = '1' ]
then
    yay -S rsyslog
else
    $INSTALLER rsyslog
fi
gem install tmuxinator
set -e
set -u
set -o pipefail

is_app_installed() {
  type "$1" &>/dev/null
}

REPODIR="$(cd "$(dirname "$0")"; pwd -P)"
cd "$REPODIR";

if ! is_app_installed tmux; then
  printf "WARNING: \"tmux\" command is not found. \
Install it first\n"
  exit 1
fi

if [ ! -e "$HOME/.tmux/plugins/tpm" ]; then
  printf "WARNING: Cannot found TPM (Tmux Plugin Manager) \
 at default location: \$HOME/.tmux/plugins/tpm.\n"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ -e "$HOME/.tmux.conf" ]; then
  printf "Found existing .tmux.conf in your \$HOME directory. Will create a backup at $HOME/.tmux.conf.bak\n"
fi

cp -f "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak" 2>/dev/null || true
cp -a ./tmux/. "$HOME"/.tmux/
ln -sf .tmux/tmux.conf "$HOME"/.tmux.conf;

# Install TPM plugins.
# TPM requires running tmux server, as soon as `tmux start-server` does not work
# create dump __noop session in detached mode, and kill it when plugins are installed
printf "Install TPM plugins\n"
tmux new -d -s __noop >/dev/null 2>&1 || true 
tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "~/.tmux/plugins"
"$HOME"/.tmux/plugins/tpm/bin/install_plugins || true
tmux kill-session -t __noop >/dev/null 2>&1 || true

cp -r tmuxinator/ $HOME/.config/
sudo ln -sf /home/$USERINSTALL/.prog/start-project.sh /usr/bin/start-project

##################################################################

# RESTART
echo -e "[+] Aguarde a instalacao e reinicie a maquina"
