#!/usr/bin/env bash

mkdir -p "$HOME/opt"
if [[ ! -d "$HOME/opt/fd" ]]; then
    git clone -b feature/sort_by_depth https://github.com/FilippoBSW/fd.git "$HOME/opt/fd"
fi
pushd "$HOME/opt/fd" >/dev/null
git pull --ff-only
cargo install --path . --force
popd >/dev/null
