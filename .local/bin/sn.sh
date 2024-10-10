#!/bin/sh

fd "" -IH --type f | \
fzf \
    --prompt 'Files> ' \
    --header 'CTRL-D: Directories / CTRL-F: Files' \
    --layout=reverse \
    --info=inline \
    --border \
    --margin=1 \
    --padding=1 \
    --preview='if [ -d {} ]; then eza -alg --color=always --group-directories-first {}; else bat --color=always --style=numbers --theme="gruvbox-dark" {}; fi' \
    --bind shift-up:preview-page-up,shift-down:preview-page-down \
    --bind 'ctrl-d:change-prompt(Directories> )+reload(fd "" -IH --type d)' \
    --bind 'ctrl-f:change-prompt(Files> )+reload(fd "" -IH --type f)' \
    --bind 'enter:become(emacsclient -n {1})' \
    --bind 'ctrl-o:become(open {1})'
