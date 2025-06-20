#!/bin/bash

# i3 theme setup script
i3_dir="$HOME/.config/i3"
scripts_dir="$i3_dir/scripts"
theme_dir="$i3_dir/themes"
cache_dir="$i3_dir/.cache"
theme_file="$cache_dir/theme"

# Create necessary directories if they don't exist
mkdir -p "$cache_dir"
mkdir -p "$scripts_dir"
mkdir -p "$theme_dir"

# Initialize theme file if it doesn't exist
if [ ! -f "$theme_file" ]; then
    echo "current=nordic" > "$theme_file"
fi

# Sourcing the theme file
source "$theme_file"

# Function to change GTK theme
# change_gtk_theme() {
#   local gtk_theme="$1"
#   echo "Changing GTK theme to $gtk_theme"
#   gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
#   if [ $? -eq 0 ]; then
#     echo "GTK theme changed successfully"
#   else
#     echo "Failed to change GTK theme"
#   fi
# }


case "$current" in
    "nordic")
        echo "Changing to darkforest"
        notify-send "Theme" "Changing theme to Darkforest"
        sed -i "s/current=.*/current=darkforest/g" "$theme_file"
        # change_gtk_theme "Everforest-Dark-Soft-BL-MB"
        # update_theme_config "darkforest"
        ;;
    "darkforest")
        echo "Changing to gruvbox"
        notify-send "Theme" "Changing theme to GruvBox"
        sed -i "s/current=.*/current=gruvbox/g" "$theme_file"
        # change_gtk_theme "Gruvbox-Dark-BL-LB"
        # update_theme_config "gruvbox"
        ;;
    "gruvbox")
        echo "Changing to nordic"
        notify-send "Theme" "Changing theme to Nordic"
        sed -i "s/current=.*/current=nordic/g" "$theme_file"
        # change_gtk_theme "Nordic-darker"
        # update_theme_config "nordic"
        ;;
    *)
        echo "No theme available...sorry"
        ;;
esac

# Check if the wallpaper script exists before running it
if [ -f "$scripts_dir/Wallpaper.sh" ]; then
    "$scripts_dir/Wallpaper.sh"
else
    echo "Wallpaper script not found"
fi
