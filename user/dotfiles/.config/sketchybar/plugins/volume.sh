#!/bin/sh

# ------------------------------------------
# Init

if [ "$1" = "init" ]; then
    sketchybar \
        --add item volume right \
        --subscribe volume volume_change mouse.clicked mouse.scrolled \
        --set volume \
        script="$PLUGIN_DIR/volume.sh"

    return 0
fi

# ------------------------------------------
# Update

source "$CONFIG_DIR/colors.sh"

# Event: mouse.clicked returns a JSON object
# {
#     "button": "left",
#     "button_code": 0,
#     "modifier": "none",
#     "modfier_code": 0
# }

if [ "$SENDER" = "mouse.clicked" ]; then
    BUTTON="$(echo "$INFO" | jq -r '.button')"
    if [ "$BUTTON" = "left" ]; then
        open 'x-apple.systempreferences:com.apple.Sound-Settings.extension'
    else
        osascript -e 'set volume output muted not (output muted of (get volume settings))'
    fi
fi

# Event: mouse.scrolled returns a JSON object
# {
#     "delta": 0,
#     "modifier": "none",
#     "modfier_code": 0
# }

if [ "$SENDER" = "mouse.scrolled" ]; then
    DIRECTION="$(echo $INFO | jq -r '.delta')"

    if [ "$DIRECTION" -gt 1 ]; then
        osascript -e "set volume output volume (output volume of (get volume settings) + 2)"
    elif [ "$DIRECTION" -lt -1 ]; then
        osascript -e "set volume output volume (output volume of (get volume settings) - 2)"
    fi

    sketchybar --trigger volume_change
fi

# Event: volume_change returns the current volume percentage

if [ "$SENDER" = "volume_change" ]; then
    VOLUME="$INFO"

    COLOR="$FGCOLOR"

    case "$VOLUME" in
        [5-9][0-9]|100)
            ICON="󰕾"
            ;;
        [2-4][0-9])
            ICON="󰖀"
            ;;
        [1-9]|1[0-9])
            ICON="󰕿"
            ;;
        *)
            ICON="󰖁"
            COLOR="$FGCOLOR_INACTIVE"
            ;;
    esac

    sketchybar --set "$NAME" \
        icon="$ICON" icon.color="$COLOR" \
        label="$VOLUME%" label.color="$COLOR"
fi
