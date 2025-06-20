#!/bin/bash

# Path to your custom Rofi theme
rofi_theme="$HOME/.config/rofi/themes/rofi-clipboard.rasi"

case $1 in
    --hist)
        greenclip print | rofi -dmenu -p "Clipboard" -theme "$rofi_theme" | xargs -r -d '\n' -I '{}' greenclip print '{}' | xclip -selection clipboard
        echo "$(greenclip print | wc -l)"
        ;;
    --num) greenclip print | wc -l
        ;;
    --clr)
        if [ "$(echo -e "Yes\nNo" | rofi -dmenu -theme-str 'entry { placeholder: "Clear Clipboard History?";}' -theme "$rofi_theme")" == "Yes" ] ; then
            greenclip clear
            pkill greenclip
            nohup greenclip daemon &
        fi
        ;;
esac
