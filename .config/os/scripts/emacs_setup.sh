#!/bin/sh

git clone https://github.com/Sampie159/odin-ts-mode.git ~/.config/emacs/
emacs --batch --eval "(load-file \"~/.config/emacs/init.el\")"
