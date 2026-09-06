#!/usr/bin/env bash

# Applications use several independent sources for the system colour scheme.
# Set both major desktop stacks so portals and toolkit-native applications
# report the same preference in a Hyprland session.
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark

if command -v plasma-apply-colorscheme >/dev/null 2>&1; then
    plasma-apply-colorscheme BreezeDark >/dev/null
elif command -v kwriteconfig6 >/dev/null 2>&1; then
    kwriteconfig6 --file kdeglobals --group General --key ColorScheme BreezeDark
fi
