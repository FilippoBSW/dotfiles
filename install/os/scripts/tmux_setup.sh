#!/usr/bin/env bash

TMUX_DIR="$HOME/.config/tmux"

mkdir -p "$TMUX_DIR/plugins"
if [[ ! -d "$TMUX_DIR/plugins/tpm" ]]; then
    git clone https://github.com/tmux-plugins/tpm "$TMUX_DIR/plugins/tpm"
fi

tmux new-session -d -s dev
tmux source-file "$TMUX_DIR/tmux.conf"
tmux run-shell -t dev "$TMUX_DIR/plugins/tpm/scripts/install_plugins.sh"
