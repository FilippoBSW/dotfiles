#!/usr/bin/env bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <username> <git-name> <git-email>"
    exit 1
fi

cp -r ./.local/ ./.config/ ./.bashrc ~/

# sh ~/.config/os/scripts/fedora_copr_setup.sh
# sudo dnf install -y $(<~/.config/os/packages/packages.dnf)
# cargo install $(<~/.config/os/packages/packages.cargo)

sudo pacman -S -y $(<~/.config/os/packages/packages.pacman)
paru -S -y $(<~/.config/os/packages/packages.paru)
pip install $(<~/.config/os/packages/packages.pip)

sh ~/.config/os/scripts/ddcutil_setup.sh $1
sh ~/.config/os/scripts/git_setup.sh $2 $3
sh ~/.config/os/scripts/tmux_setup.sh
sh ~/.config/os/scripts/emacs_setup.sh
