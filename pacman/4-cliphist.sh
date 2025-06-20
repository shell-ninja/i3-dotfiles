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
   ______ __ _         __     _        __ 
  / ____// /(_)____   / /_   (_)_____ / /_
 / /    / // // __ \ / __ \ / // ___// __/
/ /___ / // // /_/ // / / // /(__  )/ /_  
\____//_//_// .___//_/ /_//_//____/ \__/  
           /_/                            
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
log="$log_dir/cliphist-$(date +%d-%m-%y).log"


# Create Greenclip configuration
mkdir -p ~/.config
cat << EOF > ~/.config/greenclip.toml
[greenclip]
  history_file = "~/.cache/greenclip.history"
  max_history_length = 50
  max_selection_size_bytes = 0
  trim_space_from_selection = true
  use_primary_selection_as_input = false
  blacklisted_applications = []
  enable_image_support = true
  image_cache_directory = "/tmp/greenclip"
  static_history = [
  ]
EOF

# Create systemd service for Greenclip
mkdir -p ~/.config/systemd/user/
cat << EOF > ~/.config/systemd/user/greenclip.service
[Unit]
Description=Greenclip daemon

[Service]
ExecStart=/usr/bin/greenclip daemon
Restart=always

[Install]
WantedBy=default.target
EOF

# Reload systemd user units and start Greenclip service
systemctl --user daemon-reload 2>&1 | tee -a "$log"
systemctl --user enable greenclip.service 2>&1 | tee -a "$log"
systemctl --user start greenclip.service 2>&1 | tee -a "$log"

msg dn "Greenclip and Rofi clipboard manager setup complete!" 2>&1 | tee -a "$log"

sleep 1 && clear
