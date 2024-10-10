#!/usr/bin/env bash

emacs --batch --eval "(progn
 (load-file \"~/.config/emacs/init.el\")
  (require 'treesit-auto)
  (let ((yes-or-no-p (lambda (&rest args) t)))
    (treesit-auto-install-all)))"
