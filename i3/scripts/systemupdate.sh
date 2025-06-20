#!/usr/bin/env bash

# Function to check for updates
aurhlpr=$(command -v yay || command -v paru)
check_for_updates() {
    aur=$(${aurhlpr} -Qua | wc -l)

    # Check for flatpak updates
    ofc=$(checkupdates | wc -l)

    # Calculate total available updates
    upd=$(( ofc + aur ))

    echo "$upd"
}

# Initial check for updates
upd=$(check_for_updates)

# Show tooltip
if [[ "$upd" == 0 ]] ; then
    echo "$upd"
  #  notify-send "  Packages are up to date"
else
    echo "$upd"
    notify-send "󱓽 Updates Available: $upd"
fi

# Function to update packages
update_packages() {
    kitty --title systemupdate sh -c "${aurhlpr} -Syyu --noconfirm"
}

# Trigger upgrade
if [ "$1" == "up" ] ; then
    update_packages
    sleep 1

    # Recheck for updates after performing the update
    upd=$(check_for_updates)

    if [[ "$upd" -eq 0 ]] ; then
        notify-send "  Packages updated successfully"
    else
        notify-send "Could not update your packages."
    fi
fi

