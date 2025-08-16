#!/bin/bash

pic_dir="$HOME/Pictures"
save_dir="$pic_dir/Screenshots"
save_file="$(date +%s).png"

mkdir -p "$save_dir"

send_notification() {
    local msg="$1"
    notify-send "Taking Screenshot in" "$msg"
    sleep 1
    pkill dunst
}

# Function to hide the cursor and store its position
hide_cursor() {
    eval $(xdotool getmouselocation --shell)
    xdotool mousemove -- -100 1080
}

# Function to restore the cursor to its original position
restore_cursor() {
    xdotool mousemove $X $Y
}

take_screenshot() {
    maim "$save_dir/$save_file"
}

option1="Fullscreen (delay 3 sec)"
option2="Selected Area"
option3="Crop Screenshot"

options="$option1\n$option2\n$option3"

choice=$(echo -e "$options" | rofi -dmenu -replace -config ~/.config/rofi/themes/config-screenshots.rasi)

case "$choice" in
    $option1)
        for i in 3 2 1; do
            send_notification "$i"
        done
        sleep 1
        hide_cursor
        take_screenshot
        restore_cursor
        ;;
    $option2)
        hide_cursor
        maim -s "$save_dir/$save_file"
        restore_cursor
        ;;
    $option3)
        hide_cursor
        maim -u | feh -F - &
        maim -s -k "$save_dir/$save_file"
        kill $!
        restore_cursor
        ;;
    *)
        echo "Usage: $0 {--full|--select|--crop}"
        exit 1
        ;;
esac

if [ -f "$save_dir/$save_file" ]; then
    notify-send "Saved in" "$save_dir" -i "$save_dir/$save_file"
fi

