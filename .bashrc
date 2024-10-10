[[ $- != *i* ]] && return

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export VISUAL="emacsclient -n"
export EDITOR="emacsclient -n"

alias ls='eza -alg --color=always --group-directories-first'
alias ll='eza -lg --color=always --group-directories-first'
alias vim='nvim'
alias ..='cd ..'
alias e='emacsclient -n'
alias tx='tmux new -As dev'
alias ff='sh find_file.sh'
alias fr='sh grep_file.sh'

eval "$(fzf --bash)"
eval "$(starship init bash)"
eval "$(zoxide init --cmd cd bash)"
