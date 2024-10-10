#!/usr/bin/env bash

if [[ ! -d "$HOME/.emacs.d" ]]; then
    git clone https://github.com/FilippoBSW/adhoc-emacs.git "$HOME/.emacs.d"
fi

"$HOME/.emacs.d/install.sh"
