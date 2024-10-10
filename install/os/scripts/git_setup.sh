#!/usr/bin/env bash

git config --global user.name "$1"
git config --global user.email "$2"
git config --global core.editor "emacsclient -n"
git config --global init.defaultBranch main
cat ~/.config/delta/config >> ~/.gitconfig
bat cache --build
ssh-keygen -t ed25519 -C "$2"
