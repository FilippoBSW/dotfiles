#!/bin/sh

SINK=$(pactl list sinks | rg -B 1 RUNNING | rg Sink | awk '{print $2}' | sed 's/#//g')

if [ "$1" == "toggle" ]; then
    pactl set-sink-mute $SINK toggle
    exit 0
elif [ "$1" == "inc" ]; then
    VOLUME_CHANGE=+5%
elif [ "$1" == "dec" ]; then
    VOLUME_CHANGE=-5%
else
    echo "Error..."
    exit 1
fi

pactl set-sink-mute $SINK 0
pactl set-sink-volume $SINK $VOLUME_CHANGE
