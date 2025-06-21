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

# initial texts
attention="[${orange} ATTENTION ${end}]"
action="[${green} ACTION ${end}]"
note="[${magenta} NOTE ${end}]"
done="[${cyan} DONE ${end}]"
ask="[${orange} QUESTION ${end}]"
error="[${red} ERROR ${end}]"

# sourcing the intaraction functions
dir="$(dirname "$(realpath "$0")")"
parent_dir="$(dirname "$dir")"
cache_dir="$parent_dir/.cache"
installed_cache="$cache_dir/installed_packages"
source "$parent_dir/functions.sh"

# Create installed cache if it doesn't exist
[[ ! -f "$installed_cache" ]] &&  touch "$installed_cache"

# Skip already installed packages
skip_installed() {

    [[ -z "$installed_cache" ]] && touch "$installed_cache"

    if dpkg -s "$1" &> /dev/null; then
        msg skp "$1 is already installed. Skipping..." && sleep 0.1
        if ! grep -qx "$1" "$installed_cache"; then
            echo "$1" >> "$installed_cache"
        fi
        return 0
    fi
    return 1
}

# Install package using apt
install_package() {

    msg act "Installing $1..."
    sudo apt-get install -y "$1"

    if dpkg -s "$1" &> /dev/null; then
        msg dn "$1 was installed successfully!"
        echo "$1" >> "$installed_cache"
    else
        msg err "$1 failed to install. Please check manually."
    fi
}


