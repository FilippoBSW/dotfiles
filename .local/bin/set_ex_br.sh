#!/usr/bin/env bash

DISPLAY_INDEX=${2:-1}
sudo ddcutil setvcp 10 "$1" --display "$DISPLAY_INDEX"
