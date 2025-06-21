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
    cat << EOF
 ________                
/_  __/ /  ___ __ _  ___ 
 / / / _ \/ -_)  ; \/ -_)
/_/ /_//_/\__/_/_/_/\__/ 
                          
EOF
}

clear && display_text
printf " \n \n"

printf " \n"

###------ Startup ------###

# finding the presend directory and log file
# install script dir
dir="$(dirname "$(realpath "$0")")"

# log directory
parent_dir="$(dirname "$dir")"
source "$parent_dir/functions.sh"

log_dir="$parent_dir/Logs"
log="$log_dir/themes-$(date +%d-%m-%y).log"
mkdir -p "$log_dir"
touch "$log"

if [[ ! -d "$dir/.cache/themes" ]]; then
    msg act "Clonning themes repo..."
    git clone --depth=1 https://github.com/shell-ninja/themes_icons.git "$dir/.cache/themes" &> /dev/null

    sleep 1

    if [[ -d "$dir/.cache/themes" ]]; then
        cd "$dir/.cache/themes"
        chmod +x extract.sh
        ./extract.sh
    fi
fi


# setting default themes, icon and cursor
gsettings set org.gnome.desktop.interface gtk-theme 'TokyoNight'
gsettings set org.gnome.desktop.interface icon-theme 'TokyoNight'
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'


sleep 1 && clear
