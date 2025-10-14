#!/usr/bin/env sh

FILE="/tmp/sketchybar-btc-plugin"

# ------------------------------------------
# Init

if [ "$1" = "init" ]; then

    sketchybar \
        --add item btc e \
        --set btc \
		drawing=off \
        update_freq=900 \
        script="$PLUGIN_DIR/btc.sh"

    sketchybar \
        --add item btc.price e \
        --set btc.price \
		padding_right=0 \
        icon=
    sketchybar \
        --add item btc.change e \
        --set btc.change \
		icon.drawing=off \

	return 0
fi

# ------------------------------------------
# Update

source "$CONFIG_DIR/colors.sh"

# Enable mathematics in POSIX shell
calc() { awk "BEGIN { printf(\"%.2f\", $*) }"; }

data() {
	[ -z "$1" ] && return 1

	url="$1"
	curl --location --request GET --silent "$url"
}

output() {
	[ -z "$1" ] && return 1

	# Get symbol and color
	difference="$1"
	possitive=$(calc "$difference >= 0" | cut -c 1)
	if [ "$possitive" -eq 1 ]; then
		symbol=""
		color="$COLOR2"
	else
		symbol=""
		color="$COLOR1"
	fi

	# Result
	echo "$symbol $difference%:$color"
}

if [ ! -f "$FILE" ]; then
	touch "$FILE"
fi

# Only pull if older than 10 seconds
lastModified=$(calc "$(date +%s) - $(date +%s -r $FILE) >= 10" | cut -c 1)
if [ "$lastModified" -eq 0 ]; then
	data="$(cat "$FILE")"
else
	url="https://api.gemini.com/v1/pricefeed"
	data="$(data "$url")"
	echo "$data" > "$FILE"
fi

if [ -z "$data" ]; then
	sketchybar --set "$NAME.price" drawing=off
	sketchybar --set "$NAME.change" drawing=off
	exit 1
fi

price=$(echo "$data" | jq '.[] | select(.pair=="BTCUSD").price | tonumber')
change=$(echo "$data" | jq '.[] | select(.pair=="BTCUSD").percentChange24h | tonumber')
price=$(numfmt --grouping $price) # readable big number

format="$(output "$change")"
text="$(echo $format | cut -f 1 -d ':')"
color="$(echo $format | cut -f 2 -d ':')"

sketchybar --set "$NAME.price" drawing=on label="\$$price"
sketchybar --set "$NAME.change" drawing=on label="$text" label.color=$color
