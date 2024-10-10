#!/usr/bin/env bash

git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
tmux new -d -As "Setup"
tmux send-keys -t "Setup" "tmux source-file ~/.config/tmux/tmux.conf" Enter
tmux send-keys -t "Setup" "tmux run-shell ~/.config/tmux/plugins/tpm/scripts/install_plugins.sh" Enter
