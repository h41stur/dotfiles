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
