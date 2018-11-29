# K.Tahara's zshrc

# basic {{{
## general options
setopt ignore_eof autocd
setopt extended_glob nomatch print_eight_bit
unsetopt beep notify correct

## history
setopt histignorealldups sharehistory
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

## binding
EDITOR=vim
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
#}}}

# prompt {{{
## show hostname only if ssh
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    base_prompt="%F{green}%n@%m%k "
else
    base_prompt="%F{green}%n%k "
fi
post_prompt="%b%f%k"
base_prompt_no_color=${base_prompt//\%(F\{*\}|k)/}
post_prompt_no_color=${post_prompt//\%(F\{*\}|k)/}
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
    local base_prompt_expanded_no_color base_prompt_etc
    local prompt_length space_left

    base_prompt_expanded_no_color=$(print -P "$base_prompt_no_color")
    base_prompt_etc=$(print -P "$base_prompt%~")
    prompt_length=${#base_prompt_etc}
    if [[ $prompt_length -lt 40 ]]; then
        path_prompt="%B%F{blue}%~%F{white}"
    else
        space_left=$(( $COLUMNS - $#base_prompt_expanded_no_color - 2 ))
        path_prompt="%B%F{cyan}%${space_left}<...<%~$prompt_newline%F{white}"
    fi
    PS1="$base_prompt$path_prompt %# $post_prompt"
    PS2="$base_prompt$path_prompt %_> $post_prompt"
    PS3="$base_prompt$path_prompt ?# $post_prompt"

    if [ $my_prompt_vcs_enable = 1 ]; then
        vcs_info
        my_rprompt="${vcs_info_msg_0_}"
    else
        my_rprompt=""
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd my_prompt_precmd

## vi mode status indicator
vicmd_prompt="[N]"
zle-line-init zle-line-finish zle-keymap-select () {
    RPROMPT="${${KEYMAP/vicmd/$vicmd_prompt}/(main|viins)/}${my_rprompt}"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
#}}}

# completion {{{
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
    ls --color=auto;
}

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias l='ls -Ch'
alias ll='ls -Bltrh'
alias la='ls -altrh'
alias less='less -R'
alias info='info --vi-keys'
alias vima='vim -u ~/dotfiles/vimrc_alt'

# set envs just once.
# should be in ~/.profile or something. but I want to be portable.
if [ -z "${DOTFILES_ENV_SET+1}" ]; then
    export DOTFILES_ENV_SET=1
    export PATH=$PATH:$HOME/dotfiles/scripts
fi

# Plugins
## zsh-syntax-highlighting
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
