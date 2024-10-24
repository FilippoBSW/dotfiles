#!/bin/sh

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <username> <git-name> <git-email>"
    exit 1
fi

sh ~/.config/os/scripts/fedora_copr_setup.sh

sudo dnf install -y $(<~/.config/os/packages/packages.dnf)
cargo install $(<~/.config/os/packages/packages.cargo)
pip install $(<~/.config/os/packages/packages.pip)

sh ~/.config/os/scripts/ddcutil_setup.sh $1
sh ~/.config/os/scripts/git_setup.sh $2 $3
sh ~/.config/os/scripts/tmux_setup.sh
