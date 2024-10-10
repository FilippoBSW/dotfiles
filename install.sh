#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <git-name> <git-email>"
    exit 1
fi

cp -r ./.local/ ./.config/ ./.bashrc ~/

if ! command -v git &> /dev/null; then
    sudo pacman -S --noconfirm git
fi

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
rustup component add rust-analyzer

if ! command -v paru &> /dev/null; then
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/paru.git ~/programs/paru
    pushd ~/programs/paru
    makepkg -si --noconfirm
    popd
fi

/usr/bin/paru -Syu --noconfirm
/usr/bin/paru -S --needed --noconfirm $(<./install/os/packages/paru.pkg)

git clone -b feature/sort_by_depth https://github.com/FilippoBSW/fd.git ~/programs/fd
pushd ~/programs/fd
cargo install --path .
popd

sh ./install/os/scripts/git_setup.sh $1 $2
sh ./install/os/scripts/emacs_setup.sh
sh ./install/os/scripts/tmux_setup.sh
