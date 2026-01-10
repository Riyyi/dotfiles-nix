#!/usr/bin/env sh

# ------------------------------------------
# Init

if [ "$1" = "init" ]; then
	sketchybar \
		--add item wifi right \
		--subscribe wifi wifi_change \
		--set wifi \
		\
		icon=󰖪 \
		label.drawing=off \
		\
		update_freq=10 \
		click_script="open 'x-apple.systempreferences:com.apple.wifi-settings-extension'" \
		script="$PLUGIN_DIR/wifi.sh"

	return 0
fi

# ------------------------------------------
# Update

. "$CONFIG_DIR/colors.sh"

if ipconfig getsummary en0 | grep -q 'LinkStatusActive : TRUE'; then
	ICON="󰖩"
	COLOR="$FGCOLOR"
else
	ICON="󰖪"
	COLOR="$BGCOLOR"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR"
