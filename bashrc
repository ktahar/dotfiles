# NOTE: this bashrc is intended to be used on Windows (Git Bash).
# use zsh (see zshrc / zshenv) on Linux.

PS1="\[\e[32m\]\u@\h\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \$ "

_title="${USER}@${HOSTNAME}"
case $TERM in
    screen*)
        _title="\ePtmux;\e\e]0;tmux $_title\a\e\\"
        ;;
    xterm*)
        _title="\e]0;xterm $_title\a"
        ;;
    rxvt-unicode*)
        _title="\e]0;urxvt $_title\a"
        ;;
    gnome*)
        _title="\e]0;GNOME Terminal $_title\a"
        ;;
    *)
        _title="\e]0;$_title\a"
        ;;
esac
export PROMPT_COMMAND='echo -ne $_title'
set -o vi
bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'
bind '"\C-j": vi-movement-mode'

set -o ignoreeof

alias s='sudo -E'
alias svim='sudo vim --noplugin'
alias v='vim'
alias vi='vim'

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias l='ls --color -BC'
alias ll='ls --color -Blh'
alias la='ls --color -alh'
alias lt='ls --color -Bltrh'
alias lta='ls --color -altrh'
alias lat='ls --color -altrh'
alias less='less -R'
alias info='info --vi-keys'

alias gis='git status'
alias gid='git diff'
alias gia='git add'
alias gic='git commit'
alias gil='git log'
alias gig='git graph'

alias q='exit'
alias ipy='ipython3'
alias ipy3='ipython3'
alias ipy2='ipython2'

if [ -t 0 ]; then    # stdin is opened
    stty stop undef  # unbind C-s
    stty start undef # unbind C-q
fi

# set envs just once.
# should be in ~/.profile or something. but I want to be portable.
if [ -z "${DOTFILES_ENV_SET+1}" ]; then
    export DOTFILES_ENV_SET=1
    export PATH=$PATH:$HOME/dotfiles/bin
    export PYTHONPATH=$PYTHONPATH:$HOME/dotfiles/py
fi
