#!/bin/bash

i3_dir="$HOME/.config/i3"
scripts_dir="$i3_dir/scripts"
cache_dir="$i3_dir/.cache"

wallpaper_dir="$i3_dir/Wallpapers"

pics=($(find "$wallpaper_dir" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \)))
random_pic=${pics[RANDOM % ${#pics[@]}]}
RANDOM_PIC_NAME="Random"

# Rofi command ( style )
case $1 in
  style1)
      rofi_command="rofi -show -dmenu -config ~/.config/rofi/themes/conf-wall.rasi"
      ;;
  style2)
      rofi_command="rofi -show -dmenu -config ~/.config/rofi/themes/conf-wall-2.rasi"
      ;;
esac

menu() {
  for pic in "${pics[@]}"; do
    printf "%s\x00icon\x1f%s\n" "$(basename "$pic")" "$pic"
  done
  printf "%s\x00icon\x1frandom.png\n" "$RANDOM_PIC_NAME"
}

main() {
    # Debug: Print the list of wallpapers
    echo "Available wallpapers:"
    menu

    choice=$(menu | ${rofi_command})

    # No choice case
    if [[ -z $choice ]]; then
      exit 0
    fi

    # Random choice case
    if [[ $choice == "$RANDOM_PIC_NAME" ]]; then
      selected_pic="$random_pic"
    else
      selected_pic="$wallpaper_dir/$choice"
    fi

    # Set the selected wallpaper
    if [[ -f "$selected_pic" ]]; then
      feh --bg-scale "$selected_pic"
      ln -sf "$selected_pic" "$cache_dir/current.png"
      # notify-send -i "$selected_pic" "Changing wallpaper"
    else
      echo "Image not found: $selected_pic"
      exit 1
    fi
}

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
  exit 0
fi

main

sleep 0.5
"$scripts_dir/Colors.sh"

magick "$random_pic" -blur 0x15 ~/.config/i3/.cache/blured.png
