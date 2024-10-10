#!/bin/sh

TARGET_WORKSPACE=$1
CURRENT_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true).name')
CURRENT_WORKSPACE=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true).activeWorkspace.id')
TARGET_MONITOR=$(hyprctl workspaces -j | jq -r --arg TARGET "$TARGET_WORKSPACE" '.[] | select(.id == ($TARGET | tonumber)).monitor')
TARGET_MONITOR_ACTIVE_WORKSPACE=$(hyprctl monitors -j | jq -r --arg TARGET_MONITOR "$TARGET_MONITOR" '.[] | select(.name == $TARGET_MONITOR).activeWorkspace.id')

if [ "$TARGET_MONITOR" != "$CURRENT_MONITOR" ] && [ "$TARGET_MONITOR" != "" ]; then
    if [ "$TARGET_WORKSPACE" == "$TARGET_MONITOR_ACTIVE_WORKSPACE" ]; then
        hyprctl dispatch moveworkspacetomonitor "$TARGET_WORKSPACE $CURRENT_MONITOR"
        hyprctl dispatch moveworkspacetomonitor "$CURRENT_WORKSPACE $TARGET_MONITOR"
    else
        hyprctl dispatch moveworkspacetomonitor "$TARGET_WORKSPACE $CURRENT_MONITOR"
    fi
else
    hyprctl dispatch moveworkspacetomonitor "$TARGET_WORKSPACE $CURRENT_MONITOR"
fi

hyprctl dispatch workspace "$TARGET_WORKSPACE"
