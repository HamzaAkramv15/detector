#!/bin/bash

KEY="org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/"

# stop the running script (its trap also resets the launcher)
pkill -f unity-launcher-fs.sh 2>/dev/null || true
sleep 1

rm -f "$HOME/.local/bin/unity-launcher-fs.sh"
rm -f "$HOME/.config/autostart/unity-launcher-fs.desktop"

# make sure the launcher is back to always visible
gsettings set "$KEY" launcher-hide-mode 0

echo "Uninstalled. Launcher restored to always visible."
