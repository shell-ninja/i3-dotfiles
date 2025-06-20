#!/usr/bin/env bash

dir="$HOME/.config/rofi/menu"

case $1 in
    "1") theme="style-1"
        ;;
    "2") theme="style-2"
        ;;
esac

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
