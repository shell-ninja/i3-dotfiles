#!/bin/bash

display() {
    cat << "EOF"
   ____         __              __  __        __     __     
  / __/_ _____ / /____ __ _    / / / /__  ___/ /__ _/ /____ 
 _\ \/ // (_-</ __/ -_)  ' \  / /_/ / _ \/ _  / _ `/ __/ -_)
/___/\_, /___/\__/\__/_/_/_/  \____/ .__/\_,_/\_,_/\__/\__/ 
    /___/                         /_/                       
                                                     
EOF
}

display
printf "\n"

if [ -n "$(command -v pacman)" ]; then
    aur=$(command -v yay || command -v paru)
    "$aur" -Syyu --noconfirm
elif [ -n "$(command -v dnf)" ]; then
    sudo dnf update && sudo dnf upgrade -y
elif [ -n "$(command -v zypper)" ]; then
    sudo zypper up -y
elif [ -n "$(command -v apt)" ]; then
    sudo apt update -y && sudo apt upgrade -y
fi

sleep 1

printf "\n\n<> Please press ENTER to close "
read
