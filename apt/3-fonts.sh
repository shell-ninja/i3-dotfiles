#!/bin/bash

# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\e[1;38;5;214m"
end="\e[1;0m"

display_text() {
    cat << "EOF"
    ______               __       
   / ____/____   ____   / /_ _____
  / /_   / __ \ / __ \ / __// ___/
 / __/  / /_/ // / / // /_ (__  ) 
/_/     \____//_/ /_/ \__//____/  
                                  
EOF
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"
source "$dir/1-global.sh"

parent_dir="$(dirname "$dir")"
source "$parent_dir/functions.sh"

# log directory
log_dir="$parent_dir/Logs"
log="$log_dir/fonts-$(date +%d-%m-%y).log"

# skip installed cache
cache_dir="$parent_dir/.cache"

FONT_DIR="$HOME/.local/share/fonts/i3-dotfiles"
mkdir -p "$FONT_DIR"

cd "$FONT_DIR" || exit

declare -a nerd_fonts=(
    "JetBrainsMono"
    "Melso"
    "Iosevka"
)

for font in "${nerd_fonts[@]}"; do
    msg act "Downloading $font Nerd Font..."
    wget -q --show-progress "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/$font.zip" 2>&1 | tee -a "$log"
    unzip -q "$font.zip" -d "$font"
    rm "$font.zip"
done


printf "\n\n"

# Instlling main packages...
    install_package fonts-font-awesome
    if dpkg -s "$font" &>/dev/null; then
        echo "[ DONE ] - $font was installed successfully!\n" 2>&1 | tee -a "$log" &>/dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $font!\n" 2>&1 | tee -a "$log" &>/dev/null
    fi

msg act "Rebuilding font cache..."
fc-cache -fv &> /dev/null

sleep 1 && clear
