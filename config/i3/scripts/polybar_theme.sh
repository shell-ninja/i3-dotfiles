#!/bin/bash

launchScript="$HOME/.config/polybar/launch.sh"

theme1="square"
theme2="rounded"

options="$theme1\n$theme2"

choice=$(echo -e "$options" | rofi -dmenu -replace -config ~/.config/rofi/themes/config-screenshots.rasi)

killall rofi

sed -i "s/^THEME=.*/THEME=$choice/g" "$launchScript"

# pkill polybar
