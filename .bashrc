case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export VISUAL=nvim
export EDITOR=nvim

alias ls='eza -alg --color=always --group-directories-first'
alias ll='eza -lg --color=always --group-directories-first'

alias vim='nvim'
alias ..='cd ..'
alias e='emacsclient -n'

eval "$(starship init bash)"
eval "$(zoxide init --cmd cd bash)"
