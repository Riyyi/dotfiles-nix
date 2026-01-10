#!/bin/sh

# ------------------------------------------
# Init

if [ "$1" = "init" ]; then

    sketchybar \
        --add item clock right \
        --set clock \
        icon=  \
        update_freq=10 \
        script="$PLUGIN_DIR/clock.sh"

    return 0
fi

# ------------------------------------------
# Update

sketchybar --set "$NAME" label="$(date '+%I:%M %p')"
