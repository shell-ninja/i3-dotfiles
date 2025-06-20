#!/bin/bash

# took and modified from JaKooLit #

# Detect monitor resolution and scale
x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')

# Calculate width and height based on percentages and monitor resolution
width=$((x_mon * hypr_scale / 100))
height=$((y_mon * hypr_scale / 100))

# Set maximum width and height
max_width=1200
max_height=1000

# Set percentage of screen size for dynamic adjustment
percentage_width=70
percentage_height=70

# Calculate dynamic width and height
dynamic_width=$((width * percentage_width / 100))
dynamic_height=$((height * percentage_height / 100))

# Limit width and height to maximum values
dynamic_width=$(($dynamic_width > $max_width ? $max_width : $dynamic_width))
dynamic_height=$(($dynamic_height > $max_height ? $max_height : $dynamic_height))

# Launch yad with calculated width and height
yad --width=$dynamic_width --height=$dynamic_height \
    --center \
    --title="Keybindings" \
    --no-buttons \
    --list \
    --column=Key: \
    --column=Description: \
    --column=Command: \
    --timeout-indicator=bottom \
" = " "SUPER KEY (Windows Key)" "(Mod key)" \
"" "" "" \
" + Return" "Terminal" "(Kitty)" \
" + E" "Open File Manager" "(Thunar)" \
"" "" "" \
" + D" "App Launcher" "(Rofi)" \
" + SHIFT + D" "Emoji Selector" "(Rofi)" \
" + x" "Power Menu" "(Rofi)" \
" + Alt + b" "Shell (zsh/bash) Theme" "(Rofi)" \
" + + W" "Change wallpaper" "(Based on theme)" \
" + + T" "Change Theme" "(Only 3 for now)" \
"" "" "" \
" + Q" "close active window" "(not kill)" \
"" "" "" \
" + B" "Browser" "(Brave/Chromium)" \
" + SHIFT + B" "Browser" "(Firefox 󰈹 )" \
" + C" "Code Editor" "(Visual Studio Code 󰨞 )" \
"Print" "Screenshot" "(Full Screen)" \
" + Print" "Screenshot region (Select area)" " " \
" + SHIFT + L" "Screen lock" "(i3lock)" \
" + F" "Fullscreen" "(Toggles full-screen)" \
" + V" "Floating" "(Toggle floating window)" \
" + H" " " "Launch this app" \
"CTRL + Alt + Space" "Toggle Keyboard" "fcitx5 (Bangla & English)" \
"" "" "" \
"F9" "Volume" "(Volume Mute  )" \
"F10" "Volume" "(Volume Decrease  )" \
"F11" "Volume" "(Volume Increase  )" \
"" "" "" \
"CTRL + ESC" " " "Hide/Launch Polybar" \
"CTRL+ Alt + ESC" " " "Reload Polybar" \
"CTRL + Down Aero" "Move Polybar to bottom" " " \
"CTRL + Up Aero" "Move Polybar to up" " "\