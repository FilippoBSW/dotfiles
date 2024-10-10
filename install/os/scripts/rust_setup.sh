#!/usr/bin/env bash

if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    if [[ -f "$HOME/.cargo/env" ]]; then
        source "$HOME/.cargo/env"
    fi
fi

if command -v rustup &> /dev/null; then
    if ! rustup component list --installed 2>/dev/null | grep -q '^rust-analyzer'; then
        rustup component add rust-analyzer
    fi
fi
