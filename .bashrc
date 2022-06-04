#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
		    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
				# We have color support; assume it's compliant with Ecma-48
				# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
				# a case would tend to support setf rather than setaf.)
				color_prompt=yes
			 else
				color_prompt=
			fi
fi

if [ "$color_prompt" = yes ]; then
		    prompt_color='\[\033[1;34m\]'
			path_color='\[\033[1;32m\]'
			if [ "$EUID" -eq 0 ]; then # Change prompt colors for root user
				prompt_color='\[\033[1;31m\]'
				path_color='\[\033[1;34m\]'
			fi
			PS1=$USER':'$(basename `pwd`)$prompt_color'\u@\h\[\033[00m\]:'$path_color'\w\[\033[00m\]\$ '
			unset prompt_color path_color
else
			PS1=$USER':'$(basename `pwd`)'\u@\h:\w\$ '
fi


FGBLK=$( tput setaf 0 ) # 000000
FGRED=$( tput setaf 1 ) # ff0000
FGGRN=$( tput setaf 2 ) # 00ff00
FGYLO=$( tput setaf 3 ) # ffff00
FGBLU=$( tput setaf 4 ) # 0000ff
FGMAG=$( tput setaf 5 ) # ff00ff
FGCYN=$( tput setaf 6 ) # 00ffff
FGWHT=$( tput setaf 7 ) # ffffff

BGBLK=$( tput setab 0 ) # 000000
BGRED=$( tput setab 1 ) # ff0000
BGGRN=$( tput setab 2 ) # 00ff00
BGYLO=$( tput setab 3 ) # ffff00
BGBLU=$( tput setab 4 ) # 0000ff
BGMAG=$( tput setab 5 ) # ff00ff
BGCYN=$( tput setab 6 ) # 00ffff
BGWHT=$( tput setab 7 ) # ffffff

RESET=$( tput sgr0 )
BOLDM=$( tput bold )
UNDER=$( tput smul )
REVRS=$( tput rev )

if [ "$PS1" ]; then
		  # PS1="[\u@\h:\l \W]\\$ "
		  PS1="\[$FGCYN\]╭──\[$RESET\][\[$FGYLO\]\u\[$FGCYN\]💀\[$FGGRN\]\h\[$RESET\]]-[\[$FGBLU\]\W\[$RESET\]]\n\[$FGCYN\]╰─➤\[$RESET\] \\\$ "
fi
export EDITOR=vim
export VISUAL=vim
export PATH="~/go/bin:$PATH"

alias ls="exa -lh --icons  --classify --sort=ext --group-directories-first -S --color-scale"
alias lr="exa -lR  --classify --sort=ext --group-directories-first -S --color-scale"
alias github="echo ghp_lSot"

# FUNCTIONS

function commit {
	if [ $# -eq 0 ]
	then
		echo -n "Usage:\n\tcommit <message>"
		echo
	else
		git add .
		git commit -m $1
	fi
}

function push {
	gt=$(github | wc -c)
	dir=$(basename `pwd`)
	if [ $gt -lt 10 ]
	then
		echo -n "GitHub Token needed on ~/.zshrc"
		echo
	else
		git push https://`github`@github.com/h41stur/$dir.git
	fi
}

function cert {
	if [ $# -eq 0 ]
	then
		echo -n "cert domain"
		echo
	else
		curl -s "https://crt.sh/?q=%.$1" -o /tmp/rawdata; cat /tmp/rawdata | grep "<TD>" | grep -vE "style" | cut -d ">" -f 2 | grep -Po '.*(?=....$)' | sort -u | grep -v "*"
	fi
}
