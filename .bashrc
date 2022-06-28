#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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
export SHELL="/bin/bash"
export PATH="~/go/bin:$PATH"
export PATH="~/.local/share/gem/ruby/3.0.0/bin:$PATH"

alias github="echo ghp_8D"

# aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# FUNCTIONS

function start-project {
    if [ $# -eq 0 ]
    then
        echo -e "Usage:\n\tstart-project <project name>"
        echo
    else
        cwd="$HOME/pentest/$1"

        mkdir -p $cwd/{1-recon/{osint/{manual,tools},scanning/{ports/{custom,tools},web/{custom,toos}}},2-expl/{exploits,payloads},3-post/{1-recon/{manual,tools},2-expl/privesc.3-pivot},4-loot/{scripts,creds,dumps,files,keylog,screenshots},5-logs/{videos,tmuxlogs,rsyslogcommands}}
        touch $cwd/5-logs/rsyslogcommands/commands.log

        cd $HOME/pentest/$1

        echo -e "Projeto $1 iniciado.\n"

        tts PENTEST $1
    fi
}

function commit {
	if [ $# -eq 0 ]
	then
		echo -n "Usage:\n\tcommit <message>"
		echo
	else
		git add .
		git commit -m "$1"
	fi
}

function push {
		gt=$(github | wc -c)
		dir=$(basename `pwd`)
		if [ $gt -lt 10 ]
		then
			echo -n "GitHub Token needed on ~/.zshrc"
			echo $dir
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

function e64 {
		if [ $# -eq 0 ]; then
				input=$(</dev/stdin)
		else
				input=$1
		fi

		echo -n "$input" | base64
}

function d64 {
    if [ $# -eq 0 ]; then
        input=$(</dev/stdin)
    else
        input=$1
    fi

    echo -n "$input" | base64 -d
    echo
}

function scTmux {
	[ ! -d "./5-logs/tmuxlogs" ] && mkdir -p "./5-logs/tmuxlogs"
	script -a -f -O ./5-logs/tmuxlogs/"$1"-"$2".log -c bash
}

function logCommands {
    jsonlog="{\"hostname\":\"$(hostname)\",\"user\":\"$(whoami)\",\"pid\":$$,\"cwd\":\"$(pwd)\",\"command\":\"$(history 1 | sed 's/^[ ]*[0-9]\+[ ]*//' )\",\"status_code\":$status_code,\"date_begin\":$date_begin,\"date_end\":$date_end,\"elapsed\":$elapsed}"
    logger -p local6.debug "$jsonlog"
}

# BASH PREEXEC
if [[ -f ~/.bash-preexec.sh ]]; then
    unset preexec_functions
    unset precmd_functions
    export date_begin=0
    export date_end=0

    preexec_timestamp() { 
        export date_begin=$(date +%s);
        echo -e "Begin: $(date +%Y%m%d%H%M%S)\n"; 
    }

    precmd_timestamp() {
        export status_code="$?";
        export date_end=$(date +%s); 
        echo -e "\nEnd: $(date +%Y%m%d%H%M%S)";
        export elapsed=$(( $date_end-$date_begin ));
        echo "Elapsed: $elapsed seconds"; 
    }

    preexec_functions=(preexec_timestamp ${preexec_functions[@]})
    precmd_functions=(precmd_timestamp ${precmd_functions[@]})
    source ~/.bash-preexec.sh
fi
