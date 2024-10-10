#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <git-name> <git-email>"
    exit 1
fi

cp -r ./.local/ ./.config/ ./.bashrc ~/

if ! command -v paru &> /dev/null; then
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/paru.git ~/programs/paru
    pushd ~/programs/paru
    makepkg -si --noconfirm
    popd
fi

paru -S --needed -y $(<~/.config/os/packages/packages.paru)

git clone -b feature/sort_by_depth https://github.com/FilippoBSW/fd.git ~/programs/fd
pushd ~/programs/fd
cargo install --path .
popd

sh ~/.config/os/scripts/git_setup.sh $1 $2
sh ~/.config/os/scripts/tmux_setup.sh
sh ~/.config/os/scripts/emacs_setup.sh
