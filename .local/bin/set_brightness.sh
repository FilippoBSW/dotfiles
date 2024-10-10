#!/bin/sh

CURRENT_BRIGHTNESS=$(xrandr --verbose --current | grep Brightness | awk '{print $2}')
CONNECTED_MONITOR=$(xrandr --verbose --current | rg -w connected | grep -v "None" | awk '{print $1}')

echo $CONNECTED_MONITOR

if [ "$1" == "inc" ]; then
    BRIGHTNESS_CHANGE=0.05
    NEW_BRIGHTNESS=$(echo "$CURRENT_BRIGHTNESS + $BRIGHTNESS_CHANGE" | bc)
elif [ "$1" == "dec" ]; then
    BRIGHTNESS_CHANGE=-0.05
    NEW_BRIGHTNESS=$(echo "$CURRENT_BRIGHTNESS + $BRIGHTNESS_CHANGE" | bc)
elif [ "$1" == "def" ]; then
    BRIGHTNESS_CHANGE=-0.05
    NEW_BRIGHTNESS=0.75
else
    echo "Invalid action entered. Exiting..."
    exit 1
fi

if (( $(echo "$NEW_BRIGHTNESS > 1" | bc -l) )); then
  NEW_BRIGHTNESS=1
elif (( $(echo "$NEW_BRIGHTNESS < 0" | bc -l) )); then
  NEW_BRIGHTNESS=0
fi

echo $NEW_BRIGHTNESS
xrandr --output $CONNECTED_MONITOR --brightness $NEW_BRIGHTNESS
