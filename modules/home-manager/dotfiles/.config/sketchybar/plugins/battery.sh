#!/bin/sh

# ------------------------------------------
# Init

if [ "$1" = "init" ]; then
    sketchybar \
        --add item battery right \
        --subscribe battery system_woke power_source_change \
        --set battery \
        update_freq=120 \
        click_script="open 'x-apple.systempreferences:com.apple.Battery-Settings.extension'" \
        script="$PLUGIN_DIR/battery.sh"

    return 0
fi

# ------------------------------------------
# Update

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
    exit 0
fi

case "${PERCENTAGE}" in
    9[0-9]|100) ICON=""
    ;;
    [6-8][0-9]) ICON=""
    ;;
    [3-5][0-9]) ICON=""
    ;;
    [1-2][0-9]) ICON=""
    ;;
    *) ICON=""
esac

if [[ "$CHARGING" != "" ]]; then
    ICON=""
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%"
