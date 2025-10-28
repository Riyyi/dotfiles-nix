#!/usr/bin/env sh

# AeroSpace Workspace Indicators
# https://nikitabobko.github.io/AeroSpace/goodness#show-aerospace-workspaces-in-sketchybar

# ------------------------------------------
# Init

if [ "$1" = "init" ]; then
    sketchybar --add event aerospace_workspace_change

    WORKSPACES="一 二 三 四 五 六 七 八 九 十"
    for sid in $WORKSPACES; do
        sketchybar \
            --add item "space.$sid" left \
            --subscribe "space.$sid" aerospace_workspace_change \
            --set "space.$sid" \
            \
            padding_left=0 \
            padding_right=0 \
            icon.padding_left=0 \
            icon.padding_right=0 \
            label.padding_left=12 \
            label.padding_right=12 \
            background.color=$BGCOLOR \
            background.corner_radius=0 \
            background.height=32 \
            background.drawing=off \
            label="$sid" \
            \
            click_script="aerospace workspace $sid" \
            script="$CONFIG_DIR/plugins/aerospace.sh $sid"
    done

    return 0
fi

# ------------------------------------------
# Update

source "$CONFIG_DIR/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on label.color=$FGCOLOR
else
    # FIXME: This doesnt update properly when killing apps, also do a poll (?)
    # $ aerospace list-workspaces --focused

    # Make the workspace faded if there are no windows on it
    if aerospace list-workspaces --monitor all --empty no | grep -q -- "$1"; then
        color=$FGCOLOR_INACTIVE
    else
        color=$BGCOLOR
    fi

    sketchybar --set $NAME background.drawing=off label.color=$color
fi
