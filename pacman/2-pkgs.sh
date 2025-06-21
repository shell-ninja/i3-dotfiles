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
    ____                __                            
   / __ \ ____ _ _____ / /__ ____ _ ____ _ ___   _____
  / /_/ // __ `// ___// //_// __ `// __ `// _ \ / ___/
 / ____// /_/ // /__ / ,<  / /_/ // /_/ //  __/(__  ) 
/_/     \__,_/ \___//_/|_| \__,_/ \__, / \___//____/  
                                 /____/               
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
log="$log_dir/packages-$(date +%d-%m-%y).log"

# skip installed cache
cache_dir="$parent_dir/.cache"
installed_cache="$cache_dir/installed_packages"

if [[ -f "$log" ]]; then
    errors=$(grep "ERROR" "$log")
    last_installed=$(grep "xdg-desktop-portal-hyprland" "$log" | awk {'print $2'})
    if [[ -z "$errors" && "$last_installed" == "DONE" ]]; then
        msg skp "Skipping this script. No need to run it again..."
        sleep 1
        exit 0
    fi
else
    mkdir -p "$log_dir"
    touch "$log"
fi

aur_helper=$(command -v yay || command -v paru) # find the aur helper

_i3=(
    dunst
    eog
    feh
    firefox
    i3-wm
    i3lock
    jq
    kitty
    maim
    neovim
    polybar
    polkit-gnome
    qt5ct
    qt5-svg
    qt5-graphicaleffects
    qt5-quickcontrols
    qt6ct
    qt6-svg
    # ranger
    rofi
    rofi-greenclip
    nwg-look
    # picom-simpleanims-git

    btop
    brightnessctl
    curl
    fastfetch
    ffmpeg
    imagemagick
    kvantum
    libinput
    lxappearance
    network-manager-applet
    networkmanager
    ntfs-3g
    nvtop
    os-prober
    pacman-contrib
    pamixer
    pavucontrol
    parallel
    python-pywal
    python-pillow
    wget
    xdotool
    xorg-xinput
    # yazi

    ffmpegthumbnailer
    file-roller
    gvfs
    gvfs-mtp 
    thunar 
    thunar-volman 
    tumbler 
    thunar-archive-plugin
)


# checking already installed packages 
for skipable in "${_i3[@]}"; do
    skip_installed "$skipable"
done

to_install=($(printf "%s\n" "${_i3[@]}" | grep -vxFf "$installed_cache"))

printf "\n\n"

# Instlling main packages...
for __pkgs in "${to_install[@]}"; do
    install_package "$__pkgs"

    if sudo pacman -Q "$__pkgs" &>/dev/null; then
        echo "[ DONE ] - $__pkgs was installed successfully!\n" 2>&1 | tee -a "$log" &>/dev/null
    else
        echo "[ ERROR ] - Sorry, could not install $__pkgs!\n" 2>&1 | tee -a "$log" &>/dev/null
    fi
done

sleep 1 && clear
