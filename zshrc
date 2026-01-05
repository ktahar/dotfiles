# ktaha's zshrc

# basic {{{
## general options
setopt ignore_eof autocd
setopt extended_glob nomatch print_eight_bit
unsetopt beep notify correct

## history
setopt histignorealldups sharehistory histignorespace
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

## binding
KEYTIMEOUT=1
bindkey -v
bindkey "^J" vi-cmd-mode
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "^?" backward-delete-char
bindkey "^H" backward-delete-char
bindkey "^W" backward-kill-word
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd "^V" edit-command-line
bindkey -M vicmd "/" history-incremental-search-backward
bindkey -M vicmd "?" history-incremental-search-forward
## buffer stack
setopt noflowcontrol # unbind "^S" and "^Q"
stty -ixon # do the same for terminal apps like vim
show_buffer_stack() {
    POSTDISPLAY="
stack: $LBUFFER"
    zle push-line-or-edit
}
zle -N show_buffer_stack
bindkey "^Q" show_buffer_stack

## builtin
disable r
#}}}

# prompt {{{
## show hostname only if ssh
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    base_prompt="%F{cyan}%n@%m"
else
    base_prompt="%F{cyan}%n"
fi
base_prompt="${base_prompt} %B%40<...<%~%<<%b%f"
prompt_newline=$'\n%{\r%}'

## vcs
autoload -Uz vcs_info
autoload -Uz colors
colors

setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}*"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats "[%b|%a]"

my_prompt_vcs_enable=1
my_prompt_vcs_toggle () {
    if [ $my_prompt_vcs_enable = 1 ]; then
        my_prompt_vcs_enable=0
    else
        my_prompt_vcs_enable=1
    fi
}
zle -N my_prompt_vcs_toggle
bindkey "^F" my_prompt_vcs_toggle
bindkey -M vicmd "^F" my_prompt_vcs_toggle

my_prompt_precmd () {
    setopt noxtrace localoptions
    local p
    extra_prompt=""
    if [[ -n $VIRTUAL_ENV ]]; then
        p=":$(basename $VIRTUAL_ENV)"
        extra_prompt="${extra_prompt}[P${p}]"
    fi
    if [[ -n $ROS_DISTRO ]]; then
        if [[ -n $ROS_WORKSPACE ]]; then
            p=":$(basename $ROS_WORKSPACE)"
        else
            p=""
        fi
        extra_prompt="${extra_prompt}[R${p}]"
    fi
    if [ $my_prompt_vcs_enable = 1 ]; then
        vcs_info
        extra_prompt="${extra_prompt}${vcs_info_msg_0_}"
    fi
    extra_prompt="%F{white}$extra_prompt%f"

    PS1="$base_prompt $extra_prompt$prompt_newline%F{white}%# %f"
    PS2="%F{white}%_> %f"
    PS3="%F{white}?# %f"

    # set window title
    local title="${USER}@${HOST}"
    case $TERM in
        screen*)
            print -Pn "\ePtmux;\e\e]0;tmux $title\a\e\\"
            ;;
        xterm*)
            print -Pn "\e]0;xterm $title\a"
            ;;
        rxvt-unicode*)
            print -Pn "\e]0;urxvt $title\a"
            ;;
        gnome*)
            print -Pn "\e]0;GNOME Terminal $title\a"
            ;;
        *)
            ;;
    esac
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd my_prompt_precmd

## vi mode status indicator
zle-line-init zle-line-finish zle-keymap-select () {
    vicmd_prompt="${${KEYMAP/vicmd/[N]}/(main|viins)/}"
    PS1="$base_prompt $extra_prompt%F{white}$vicmd_prompt$prompt_newline%# %f"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
#}}}

# completion {{{
fpath+=~/.zfunc
zmodload -i zsh/complist
autoload -Uz compinit
compinit

setopt auto_param_slash auto_param_keys complete_in_word
setopt auto_pushd pushd_ignore_dups
unsetopt menu_complete # should be unset to use auto_menu
setopt auto_menu auto_list
DIRSTACKSIZE=20

## default bind for tab (^I) is expand-or-complete.
## change complete-word when using completer _expand.
bindkey "^I" complete-word
bindkey -M menuselect "h" vi-backward-char
bindkey -M menuselect "j" vi-down-line-or-history
bindkey -M menuselect "k" vi-up-line-or-history
bindkey -M menuselect "l" vi-forward-char

## other completers: _match _prefix _list _history _correct
zstyle ':completion:*' completer _expand _complete _approximate _ignored
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' format '[%B%d%b]'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt '%Sat %p (%l): Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt '%Sscrolling: at %p (%l)%s'
zstyle ':completion:*' use-compctl true # should be true to use ROS's completion
zstyle ':completion:*' verbose true
## ignore backup or object files. but do not ignore for rm.
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?~' '*?.o'

## cd
cdpath=(.. ~)
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
#}}}

# commands, aliases, envs
chpwd () {
    ls --color=auto -BC;
}

wq () {
    if ! tmux info &> /dev/null; then
        return 1 # tmux server is not running.
    fi
    read -q ans\?'Save status and kill tmux server? [y/N]:'
    echo
    if [ $ans = 'y' ]; then
        ~/.tmux/plugins/tmux-resurrect/scripts/save.sh
        tmux kill-server
    fi
}
alias wqa='wq'
alias ...='cd ../../'
alias ....='cd ../../../'

alias svim='sudo vim --noplugin'
alias so='source'
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
alias info='info --vi-keys'
alias etree='eza --tree --git-ignore --color=always'
alias g='git'
alias gi='git'
alias t='tmux'
alias q='exit'
alias qa!='tmux kill-server'
alias ipy='ipython3'
alias docker_rm_all='docker rm -f $(docker ps -aq)'
alias docker_rmi_all='docker rmi -f $(docker images -q)'
alias ut='utop -init ~/dotfiles/ocaml/ocamlinit_utop'
alias uc='utop -init ~/dotfiles/ocaml/ocamlinit_core'
alias za='zathura'
alias f='feh -.'
alias fz='feh -.Z'
alias py="python3"
alias jdate="TZ=Asia/Tokyo date"
alias cdate="TZ=America/Chicago date"
alias edate="TZ=America/Detroit date"
alias pdate="TZ=America/Los_Angeles date"

# Tools, Plugins and Extensions
## opam
test -r ${HOME}/.opam/opam-init/init.zsh && . ${HOME}/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

## zsh-syntax-highlighting
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

## fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# fzf commands (ref. https://github.com/junegunn/fzf/wiki/Examples)
# fe [FUZZY PATTERN] - Open the selected file with the default editor
fe() {
    local files
    IFS=$'\n' files=($(fzf-tmux --query="$1" --multi -0 -1))
    [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}
# fo [FUZZY PATTERN] - Open the selected file with xdg-open (for images etc.)
fo() {
    local files
    IFS=$'\n' files=($(fzf-tmux --query="$1" --multi -0 -1))
    if [ -n "$files" ]; then
        for f in $files; do
            xdg-open $f &
        done
    fi
}
# vg [REGEX PATTERN] - fuzzy grep open via ag
vg() {
    local file line
    IFS=' ' read -r file line <<< "$(rg -n --no-heading $@ | fzf -0 -1 | awk -F: '{print $1, $2}')"

    if [[ -n $file ]]; then
        vim $file +$line
    fi
}
