#!/bin/bash

# -----------------------------------------------------
#
#     i3 wm configuration and installation script
#     by
#       _____ __         ____   _   ___         _      
#      / ___// /_  ___  / / /  / | / (_)___    (_)___ _
#      \__ \/ __ \/ _ \/ / /  /  |/ / / __ \  / / __ `/
#     ___/ / / / /  __/ / /  / /|  / / / / / / / /_/ / 
#    /____/_/ /_/\___/_/_/  /_/ |_/_/_/ /_/_/ /\__,_/  
#                                        /___/
#
# -----------------------------------------------------




# --------------- color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\e[1;38;5;214m"
end="\e[1;0m"

# --------------- color defination (hex for gum)
red_hex="#FF0000"       # Bright red
green_hex="#00FF00"     # Bright green
yellow_hex="#FFFF00"    # Bright yellow
blue_hex="#0000FF"      # Bright blue
magenta_hex="#FF00FF"   # Bright magenta (corrected spelling)
cyan_hex="#00FFFF"      # Bright cyan
orange_hex="#FFAF00"    # Approximation for color code 214 in ANSI (orange)

# -------------- log directory
dir="$(dirname "$(realpath "$0")")"
source "$dir/functions.sh"
log_dir="$dir/Logs"
log="$log_dir"/i3wm-$(date +%d-%m-%y).log
# mkdir -p "$log_dir"
# touch "$log"

cache="$dir/.cache"
mkdir -p "$cache"

clear && sleep 1



#--------------------------------#
#           asking
#--------------------------------#

msg warn "This configuration have no support for any GPU..." && sleep 1

echo

msg ask "Would you like to exit here? [ ${green}Y${end}/${red}N${end} ]"
read -p "Select: " scrExit

if [[ "$scrExit" =~ ^[Y|y]$ ]]; then
    msg act "Exiting the script here..." && sleep 2
    exit 0
else
    msg act "Starting the main script here..." && sleep 2 && clear
fi



#--------------------------------#
#           startup
#--------------------------------#

display_text && sleep 2



#--------------------------------#
#         Checking PKG 
#--------------------------------#

check_pkgman && sleep 2 && clear



#--------------------------------#
#         starting  scritps
#--------------------------------#

scriptsDir="$dir/$pkgman"

# installing aur if it's arch

if [[ "$pkgman" == "pacman" ]]; then
    aur=$(command -v yay || command -v paru)

    if [ -z $aur ]; then

        touch "$dir/Logs/aur.log"
        aurlog="$dir/Logs/aur.log"

        msg att "Need to install an ${green}aur${end} helper first."
        msg ask "Choose one...\n1)paru\n2)yay"
        read -p "Select: " aurHlpr

        case "$aurHlpr" in
            1)
                msg act "Installing paru..."
                git clone --depth=1 https://aur.archlinux.org/paru.git "$dir/.cache/paru" 2>&1 | tee -a "$aurlog"
                cd "$dir/.cache/paru" 2>&1 | tee -a "$aurlog"
                makepkg -si --noconfirm 2>&1 | tee -a "$aurlog"
                ;;
            2)
                msg act "Installing yay..."
                git clone --depth=1 https://aur.archlinux.org/yay.git "$dir/.cache/yay" 2>&1 | tee -a "$aurlog"
                cd "$dir/.cache/yay" 2>&1 | tee -a "$aurlog"
                makepkg -si --noconfirm 2>&1 | tee -a "$aurlog"
                ;;
            *)
                msg err "Invalid option. Please run the script again and select from 1 and 2.."
                ;;
        esac
        
        if [ -n $aur ]; then
            msg dn "Aur helper installed successfully!" 2>&1 | tee -a "$aurlog"
        else
            msg err "Could not install aur helper.." 2>&1 | tee -a "$aurlog"
            exit 1
        fi

    else
        echo
        msg dn "Aur helper was located, moving on.." 2>&1 | tee -a "$aurlog"
    fi
fi


sleep 1 && clear 


chmod +x "$scriptsDir"/*
chmod +x "$dir/common"/*


"$scriptsDir/2-pkgs.sh"
"$scriptsDir/3-fonts.sh"
"$scriptsDir/4-cliphist.sh"
"$scriptsDir/6-sddm.sh"


sleep 1 && clear



#--------------------------------#
#        copying dotfiles
#--------------------------------#

configs="$dir/config"
backupDir="$HOME/.config/i3_Backups_${USER}"
mkdir -p "$backupDir"

_dirs=(
    dunst
    fastfetch
    gtk-3.0
    gtk-4.0
    i3
    kitty
    nvim
    polybar
    rofi
)

# backing up dir
for __dir in "${_dirs[@]}"; do
    dirPath="$HOME/.config/$__dir"
    if [[ -d "$dirPath" ]]; then
        msg "$__dir directory was found. Backing it up inside $backupDir"
        mv "$dirPath" "$backupDir/"
    fi
done

piconConf="$HOME/.config/picom.conf"
if [[ -d "$piconConf" ]]; then
    msg "$piconConf directory was found. Backing it up inside $backupDir"
    mv "$piconConf" "$backupDir/"
fi

sleep 1 && clear

msg act "Now copying configs..."

cp -r "$configs"/* "$HOME/.config/"

if [[ -d "$HOME/.config/i3/scripts" ]]; then
    chmod +x "$HOME/.config/i3/scripts"/*
    chmod +x "$HOME/.config/polybar/launch.sh"
fi


# if [[ "$pkgman" == "pacman" ]]; then
#     mv "$HOME/.config/picom.conf.arch" "picom.conf"
# else
#     echo
# fi
#


wall="$HOME/.config/i3/Wallpapers/cyberpunk-soldier-sci-fi.jpg"
if [[ -f "$wall" ]]; then
    ln -sf "$wall" "$HOME/.config/i3/.cache/current.png"
fi


"$scriptsDir/5-display.sh"

sleep 1 && clear



#--------------------------------#
#           Wallpapers
#--------------------------------#

msg ask "Would you like to add more ${green}Wallpapers${end}? [ ${green}Y${end}/${red}N${end} ]"
read -p "Select: " wallpaper

echo

if [[ "$wallpaper" =~ ^[Y|y]$ ]]; then
    msg act "Downloading some wallpapers..."
    
    # cloning the wallpapers in a temporary directory
    git clone --depth=1 https://github.com/shell-ninja/Wallpapers.git ~/.cache/wallpaper-cache 2>&1 | tee -a "$log" &> /dev/null

    # copying the wallpaper to the main directory
    if [[ -d "$HOME/.cache/wallpaper-cache" ]]; then
        cp -r "$HOME/.cache/wallpaper-cache"/* ~/.config/i3/Wallpapers/ &> /dev/null
        rm -rf "$HOME/.cache/wallpaper-cache" &> /dev/null
        msg dn "Wallpapers were downloaded successfully..." 2>&1 | tee -a "$log" & sleep 0.5
    else
        msg err "Sorry, could not download more wallpapers. Going forward with the limited wallpapers..." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log") && sleep 0.5
    fi
fi


msg dn "Script ends here. Need to reboot your system." && sleep 2 && clear

for time in 5 4 3 2 1; do
    msg att "The system will reboot in ${time}s" && sleep 1 && clear
done

systemctl reboot --now


#----------------------------------#
#        Script Ends Here
#----------------------------------#
