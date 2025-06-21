#!/bin/bash

upd_script="$HOME/.config/i3/scripts/pkgupdate.sh"
scripts_dir="$HOME/.config/i3/scripts"

# function to check the package manager
check_update() {
    if [ -n "$(command -v pacman)" ]; then
        # Function to check for updates
        aurhlpr=$(command -v yay || command -v paru)

        check_for_updates() {
            aur=$(${aurhlpr} -Qua | wc -l)
            ofc=$(checkupdates | wc -l)

            # Calculate total available updates
            upd=$(( ofc + aur ))

            echo "$upd"
        }

        # tooltip in waybar
        aur=$(${aurhlpr} -Qua | wc -l)
        ofc=$(checkupdates | wc -l)

        # Initial check for updates
        upd=$(check_for_updates)
        echo "$upd"

    elif [ -n "$(command -v dnf)" ]; then
        # Calculate total available updates fedora
        upd=$(dnf check-update -q | grep -vE 'Last metadata expiration|^$' | wc -l)
        echo "$upd"
    elif [ -n "$(command -v zypper)" ]; then
        # count the number of available updates
        ofc=$(zypper lu --best-effort | grep -c 'v  |')

        # Calculate total available updates
        upd=$(( ofc ))
        echo "$upd"

    elif [ -n "$(command -v apt)" ]; then
        # check for updates
        upd=$(apt list --upgradable 2> /dev/null | grep -c '\[upgradable from')
        echo "$upd"
    fi
}

package_update() {
    kitty --title update sh -c "${upd_script}"
}

case $1 in
    --check)
        check_update  # Check for available updates
        ;;
    --update)
        package_update  # Perform package update
        ;;
    *)
        echo "Invalid option"
        ;;
esac
