#!/bin/bash

# color defination (ascii)
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
megenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\x1b[38;5;214m"
end="\e[1;0m"

# cache dir
dir="$(dirname "$(realpath "$0")")"


# display msge
display_text() {
    clear && sleep 1
    cat << "EOF"
    Welcome to the' 'i3 wm installation script by,
   _____  __           __ __   _   __ _           _       
  / ___/ / /_   ___   / // /  / | / /(_)____     (_)____ _
  \__ \ / __ \ / _ \ / // /  /  |/ // // __ \   / // __ `/
 ___/ // / / //  __// // /  / /|  // // / / /  / // /_/ / 
/____//_/ /_/ \___//_//_/  /_/ |_//_//_/ /_/__/ / \__,_/  
                                           /___/          

EOF
}


# function for printing message
msg() {
    local actn="$1"
    local msg="$2"

    case $actn in
        act)
            printf "${green}=>${end} $msg\n"
            ;;
        ask)
            printf "${orange}??${end} $msg\n"
            ;;
        dn)
            printf "\n${cyan}::${end} $msg\n\n"
            ;;
        att)
            printf "${yellow}!!${end} $msg\n"
            ;;
        warn)
            printf "${yellow}[ WARNING ]${end}\n $msg\n"
            ;;
        wrng)
            printf "${red}[ WRONG ]${end}\n $msg\n"
            ;;
        nt)
            printf "${blue}\$\$${end} $msg\n"
            ;;
        skp)
            printf "${magenta}[ SKIP ]${end} $msg\n"
            ;;
        err)
            printf "\n${red}>< Ohh sheet! an error..${end}\n   $msg\n"
            sleep 1
            ;;
        *)
            printf "$msg\n"
            ;;
    esac
}



# check package manager
check_pkgman() {
    if command -v pacman &> /dev/null; then
        pkgman="pacman"
    elif command -v apt &> /dev/null; then
        pkgman="apt"
    fi

    . /etc/os-release
    msg act "Starting the script for ${cyan}$NAME${end} using '${pkgman}'"
}
