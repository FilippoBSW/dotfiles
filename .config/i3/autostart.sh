#!/bin/bash

nitrogen --restore &
nm-applet &
picom &
xsetroot -cursor_name left_ptr &
xautolock -time 15 -locker 'pgrep i3lock > /dev/null || i3lock -c 000000; sleep 1; systemctl suspend' &
