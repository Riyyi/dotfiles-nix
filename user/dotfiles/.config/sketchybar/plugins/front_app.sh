#!/bin/sh

# ------------------------------------------
# Init

if [ "$1" = "init" ]; then
	sketchybar \
		--add item front_app q \
		--subscribe front_app front_app_switched \
		--set front_app \
		\
		icon.drawing=off \
		label.max_chars=30 \
		script="$PLUGIN_DIR/front_app.sh"

	return 0
fi

# ------------------------------------------
# Update

if [ "$SENDER" = "front_app_switched" ]; then
	sketchybar --set "$NAME" label="$INFO"
fi
