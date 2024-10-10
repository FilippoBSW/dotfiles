#!/usr/bin/env bash

git clone https://github.com/FilippoBSW/gruber-material-dark.git ~/.config/emacs/themes/gruber-material-dark

emacs --batch --eval "(progn
 (load-file \"~/.config/emacs/init.el\")
  (require 'treesit-auto)
  (let ((yes-or-no-p (lambda (&rest args) t)))
    (treesit-auto-install-all)))"
