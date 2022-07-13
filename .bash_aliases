###########################
# CUSTOM ALIASES
###########################

alias ta="tmux a -t"
alias tnew="tmux new -s"
alias tte="tmuxinator edit"
alias tts="tmuxinator start"
alias tenv="grep setenv ~/.tmux/tmux.conf --color"
alias checkip="while :; do clear; curl ip-api.com; sleep 30; done"
alias untar="tar -zxvf"
alias kalimux="sudo docker run --rm -it -v `pwd`:/resources -v /tmp/.X11-unix/:/tmp/.X11-unix/ --net=host --privileged -e DISPLAY=$DISPLAY kali bash"
alias jekyll="sudo docker run --rm -it --net=host -v `pwd`:/github jekyll"
alias ls='ls --color=auto'
alias grep='grep --color'
alias ls="exa -lh --icons  --classify --sort=ext --group-directories-first -S --color-scale"
alias lr="exa -lR  --classify --sort=ext --group-directories-first -S --color-scale"
alias https='openssl s_client -connect'
alias downarch="sudo pacman -U /var/cache/pacman/pkg/linux-$(uname -r | sed 's/-arch/.arch/')-x86_64.pkg.tar.zst"
alias deldock="sudo docker rm `sudo docker ps -aq`"
