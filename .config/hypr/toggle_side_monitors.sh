#!/bin/sh

enable_monitors() {
    hyprctl keyword monitor "DP-3, preferred, 0x0, 1.2, transform, 3"
    hyprctl keyword monitor "DP-2, preferred, 6400x0, 1.2, transform, 1"
}

disable_monitors() {
    hyprctl keyword monitor "DP-2, disable"
    hyprctl keyword monitor "DP-3, disable"
}

if hyprctl monitors | grep -A 20 "DP-2" | grep -q "disabled: false" && \
   hyprctl monitors | grep -A 20 "DP-3" | grep -q "disabled: false"; then
    disable_monitors
else
    enable_monitors
fi
