#!/usr/bin/env bash

if [[ ! -d "$HOME/.config/emacs/themes/gruber-material-dark" ]]; then
    git clone https://github.com/FilippoBSW/gruber-material-dark.git "$HOME/.config/emacs/themes/gruber-material-dark"
fi

emacs --batch --eval "(progn
 (load-file \"~/.config/emacs/init.el\")
  (require 'treesit-auto)
  (let ((yes-or-no-p (lambda (&rest args) t)))
    (treesit-auto-install-all)))"
