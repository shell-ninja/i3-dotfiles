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

yes_no="[ ${green}Y${end}/${red}N${end} ]"

display_text() {
    cat << "EOF"
    __  ___               _  __              
   /  |/  /____   ____   (_)/ /_ ____   _____
  / /|_/ // __ \ / __ \ / // __// __ \ / ___/
 / /  / // /_/ // / / // // /_ / /_/ // /    
/_/  /_/ \____//_/ /_//_/ \__/ \____//_/     
                                             
EOF
}

clear && display_text
printf " \n \n"

###------ Startup ------###

# install script dir
dir="$(dirname "$(realpath "$0")")"

parent_dir="$(dirname "$dir")"
source "$parent_dir/functions.sh"

# log directory
log_dir="$parent_dir/Logs"
log="$log_dir/display-$(date +%d-%m-%y).log"


monitor=($(xrandr -q | grep " connected" | cut -d ' ' -f1))

X=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
Y=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)

res=${X}x${Y}
msg ask "Is your monitor resolution${orange} ${res}p ${end}? $yes_no"
read -p "Select: " size

if [[ "$size" =~ ^[Yy]$ ]]; then

    msg ask "What is your monitor supported refresh rate? ${orange}\n  1) 60Hz \n  2) 75Hz \n  3) 144Hz${end}"
    read -r -p "Select: " refresh
    case $refresh in
        1) hz="60"
            ;;
        2) hz="75"
            ;;
        3) hz="144"
            ;;
        *) msg wrng "Select from 1, 2 or 3"
            ;;
    esac

    msg act "Setting your monitor resolution and refresh rate to ${res}p ${hz}Hz"
    sleep 2
    
    startup="$HOME/.config/i3/configs/startup.conf"
    if ! grep -q "exec xrandr --output $monitor --mode $res --rate $hz" "$startup"; then
        echo -e "\nexec xrandr --output $monitor --mode $res --rate $hz" >> "$startup"
        msg dn "Monitor setup command added to startup script." 
    else
        msg att "Monitor setup command already exists in startup script." 2>&1 | tee -a "$log"
    fi
else
    msg err "Could not find the correct resolution of your monitor...\n  Exiting without setting up monitor resulation and refresh rate...\n" 2>&1 | tee -a "$log"
fi
