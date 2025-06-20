#!/usr/bin/env bash

# Current Theme
main_dir="$HOME/.config/rofi"
dir="$main_dir/power_option"
theme='style-4'

# CMDs
uptime="$(uptime -p | sed -e 's/up //g')"
host=$(hostname)

# Options
shutdown=' ⏻ '
reboot='  '
lock='  '
logout=' 󰍃 '
yes=''
no=''

# Rofi CMD
rofi_cmd() {
    rofi show -dmenu -theme ${dir}/${theme}.rasi
}

# Ask for confirmation
confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$lock\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
        if [[ $1 == '--shutdown' ]]; then
            systemctl poweroff
        elif [[ $1 == '--reboot' ]]; then
            systemctl reboot
        elif [[ $1 == '--lock' ]]; then
            if [[ -x '/usr/bin/i3lock' ]]; then
                i3lock -i "$HOME/.config/i3/.cache/blur.png"
            elif [[ -x '/usr/bin/hyprlock' ]]; then
                hyprlock
            elif [[ -x '/usr/bin/swaylock' ]]; then
                swaylock
            fi
        elif [[ $1 == '--logout' ]]; then
            i3 exit
        fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
        run_cmd --shutdown
        ;;
    $reboot)
        run_cmd --reboot
        ;;
    $lock)
        run_cmd --lock
        ;;
    $suspend)
        run_cmd --suspend
        ;;
    $logout)
        run_cmd --logout
        ;;
esac
