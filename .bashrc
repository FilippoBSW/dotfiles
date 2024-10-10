[[ $- != *i* ]] && return

PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
HISTCONTROL=ignoreboth
HISTSIZE=-1
HISTFILESIZE=-1

shopt -s histappend
shopt -s cmdhist

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export VISUAL="emacsclient -n"
export EDITOR="emacsclient -n"

export FZF_CTRL_T_COMMAND='~/.cargo/bin/fd --sort-by-depth --full-path --hidden --no-ignore --color=never --exclude .git'
export FZF_DEFAULT_OPTS="--layout=reverse --info=inline --border --margin=1 --padding=1 -i"

alias ls='eza -alg --color=always --group-directories-first'
alias ll='eza -lg --color=always --group-directories-first'
alias vim='nvim'
alias ..='cd ..'
alias e='emacsclient -n'
alias ff='sh find_file.sh'
alias fr='sh grep_file.sh'

eval "$(fzf --bash)"
eval "$(starship init bash)"
eval "$(zoxide init --cmd cd bash)"
