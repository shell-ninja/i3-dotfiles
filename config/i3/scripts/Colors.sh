#!/bin/bash

if [ -d "$HOME/.cache/wal" ]; then
    rm -rf "$HOME/.cache/wal"
fi

wall="$HOME/.config/i3/.cache/current.png"

if [[ -f "$wall" ]]; then
    wal -i "$wall"
fi

# Extract colors from colors.json
colors_file=~/.cache/wal/colors.json
colors_conf=~/.config/i3/configs/colors.conf

# Extract colors using jq
background=$(jq -r '.special.background' "$colors_file")
foreground=$(jq -r '.special.foreground' "$colors_file")
cursor=$(jq -r '.special.cursor' "$colors_file")

for i in {0..8}; do
  eval "color$i=\$(jq -r \".colors.color$i\" \"\$colors_file\")"
done

cat > "$colors_conf" << EOF
# class                 border      backgr.    text        indicator   child_border
client.focused          $color4     $background $foreground $color4     $color4
client.focused_inactive $color2     $color0     $foreground $color3     $color3
client.unfocused        $color8     $color1     $color7     $color8     $color8
client.urgent           $color1     $color0     $foreground $color1     $color1
client.placeholder      $color6     $color6     $foreground $color6     $color6

client.background       $background
EOF


# ----- Polybar

# Path to colors-polybar file
polybar_config="$HOME/.config/polybar/colors.ini"

# Function to update Polybar colors
update_polybar_colors() {
    # Extract colors using jq
    background=$(jq -r '.special.background' "$colors_file")
    background_alt=$(jq -r '.colors.color1' "$colors_file")
    foreground=$(jq -r '.special.foreground' "$colors_file")
    foreground_alt=$(jq -r '.colors.color3' "$colors_file")
    primary=$(jq -r '.colors.color4' "$colors_file")
    secondary=$(jq -r '.colors.color5' "$colors_file")
    alert=$(jq -r '.colors.color6' "$colors_file")
    disabled=$(jq -r '.colors.color7' "$colors_file")

    clr1=$(jq -r '.colors.color8' "$colors_file")
    clr2=$(jq -r '.colors.color9' "$colors_file")
    clr3=$(jq -r '.colors.color12' "$colors_file")
    clr4=$(jq -r '.colors.color13' "$colors_file")

    # Update Polybar configuration
    sed -i "s/^background = .*/background = $background/g" "$polybar_config"
    sed -i "s/^background-alt = .*/background-alt = $background_alt/g" "$polybar_config"
    sed -i "s/^foreground = .*/foreground = $foreground/g" "$polybar_config"
    sed -i "s/^foreground-alt = .*/foreground-alt = $foreground_alt/g" "$polybar_config"
    sed -i "s/^primary = .*/primary = $primary/g" "$polybar_config"
    sed -i "s/^secondary = .*/secondary = $secondary/g" "$polybar_config"
    sed -i "s/^alert = .*/alert = $alert/g" "$polybar_config"
    sed -i "s/^disabled = .*/disabled = $disabled/g" "$polybar_config"
    sed -i "s/^clr1 = .*/clr1 = $clr1/g" "$polybar_config"
    sed -i "s/^clr2 = .*/clr2 = $clr2/g" "$polybar_config"
    sed -i "s/^clr3 = .*/clr3 = $clr3/g" "$polybar_config"
    sed -i "s/^clr4 = .*/clr4 = $clr4/g" "$polybar_config"
}

update_polybar_colors

# (__________________________)

# Path to your Kitty configuration file
kitty_config=~/.config/kitty/kitty.conf

# Extract colors using jq
background_color=$(jq -r '.special.background' "$colors_file")
foreground_color=$(jq -r '.special.foreground' "$colors_file")

# Normal colors
black=$(jq -r '.colors.color0' "$colors_file")
red=$(jq -r '.colors.color1' "$colors_file")
green=$(jq -r '.colors.color2' "$colors_file")
yellow=$(jq -r '.colors.color3' "$colors_file")
blue=$(jq -r '.colors.color4' "$colors_file")
magenta=$(jq -r '.colors.color5' "$colors_file")
cyan=$(jq -r '.colors.color6' "$colors_file")
white=$(jq -r '.colors.color7' "$colors_file")

# Bright colors
bright_black=$(jq -r '.colors.color8' "$colors_file")
bright_red=$(jq -r '.colors.color9' "$colors_file")
bright_green=$(jq -r '.colors.color10' "$colors_file")
bright_yellow=$(jq -r '.colors.color11' "$colors_file")
bright_blue=$(jq -r '.colors.color12' "$colors_file")
bright_magenta=$(jq -r '.colors.color13' "$colors_file")
bright_cyan=$(jq -r '.colors.color14' "$colors_file")
bright_white=$(jq -r '.colors.color15' "$colors_file")

# Update Kitty configuration file with new colors
sed -i "s/^background .*/background $background_color/g" "$kitty_config"
sed -i "s/^foreground .*/foreground $foreground_color/g" "$kitty_config"

sed -i "s/^color0 .*/color0 $black/g" "$kitty_config"
sed -i "s/^color1 .*/color1 $red/g" "$kitty_config"
sed -i "s/^color2 .*/color2 $green/g" "$kitty_config"
sed -i "s/^color3 .*/color3 $yellow/g" "$kitty_config"
sed -i "s/^color4 .*/color4 $blue/g" "$kitty_config"
sed -i "s/^color5 .*/color5 $magenta/g" "$kitty_config"
sed -i "s/^color6 .*/color6 $cyan/g" "$kitty_config"
sed -i "s/^color7 .*/color7 $white/g" "$kitty_config"

sed -i "s/^color8 .*/color8 $bright_black/g" "$kitty_config"
sed -i "s/^color9 .*/color9 $bright_red/g" "$kitty_config"
sed -i "s/^color10 .*/color10 $bright_green/g" "$kitty_config"
sed -i "s/^color11 .*/color11 $bright_yellow/g" "$kitty_config"
sed -i "s/^color12 .*/color12 $bright_blue/g" "$kitty_config"
sed -i "s/^color13 .*/color13 $bright_magenta/g" "$kitty_config"
sed -i "s/^color14 .*/color14 $bright_cyan/g" "$kitty_config"
sed -i "s/^color15 .*/color15 $bright_white/g" "$kitty_config"


 # setting rofi theme
 ln -sf ~/.cache/wal/colors-rofi-dark.rasi ~/.config/rofi/themes/rofi-pywal.rasi

 # ----- Dunst
 dunst_file="$HOME/.config/dunst/dunstrc"

 # Function to update Dunst colors
 update_dunst_colors() {
     frame=$(jq -r '.colors.color4' "$colors_file")
     low_bg=$(jq -r '.colors.color0' "$colors_file")
     low_fg=$(jq -r '.colors.color7' "$colors_file")
     normal_bg=$(jq -r '.special.background' "$colors_file")
     normal_fg=$(jq -r '.special.foreground' "$colors_file")
     critical_bg=$(jq -r '.colors.color1' "$colors_file")
     critical_fg=$(jq -r '.colors.color7' "$colors_file")
     critical_frame=$(jq -r '.colors.color1' "$colors_file")

     echo "$normal_bg"
     echo "$normal_fg"

     # Update Dunst configuration
     sed -i "s/frame_color = .*/frame_color = \"$frame\"/g" "$dunst_file"
     sed -i "/^\[urgency_low\]/,/^\[/ s/^    background = .*/    background = \"$low_bg\"/g" "$dunst_file"
     sed -i "/^\[urgency_low\]/,/^\[/ s/^    foreground = .*/    foreground = \"$low_fg\"/g" "$dunst_file"
     sed -i "/^\[urgency_normal\]/,/^\[/ s/^    background = .*/    background = \"${normal_bg}80\"/g" "$dunst_file"
     sed -i "/^\[urgency_normal\]/,/^\[/ s/^    foreground = .*/    foreground = \"$normal_fg\"/g" "$dunst_file"
     sed -i "/^\[urgency_critical\]/,/^\[/ s/^    background = .*/    background = \"$critical_bg\"/g" "$dunst_file"
     sed -i "/^\[urgency_critical\]/,/^\[/ s/^    foreground = .*/    foreground = \"$critical_fg\"/g" "$dunst_file"
     sed -i "/^\[urgency_critical\]/,/^\[/ s/^    frame_color = .*/    frame_color = \"$critical_frame\"/g" "$dunst_file"
 }

 update_dunst_colors

pkgs=(
    dunst
    polybar
)

# restarting dunst
for pkg in "${pkgs[@]}"; do
    if pidof "$pkg"; then
        killall "$pkg"
    fi
done

# restart i3wm
i3-msg restart
# ------------------------
