#!/bin/bash
set -e

BIN="$HOME/.local/bin/unity-launcher-fs.sh"
DESKTOP="$HOME/.config/autostart/unity-launcher-fs.desktop"

mkdir -p "$HOME/.local/bin" "$HOME/.config/autostart"

# stop any running copy before replacing it
pkill -f unity-launcher-fs.sh 2>/dev/null || true

cat > "$BIN" << 'SCRIPT_EOF'
#!/bin/bash
# Launcher stays visible, but autohides while a visible window on the
# current workspace is maximized or fullscreen.

KEY="org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/"
last=""

trap 'gsettings set "$KEY" launcher-hide-mode 0; exit' INT TERM

while true; do
    cur=$(xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}')
    want=0

    for id in $(xprop -root _NET_CLIENT_LIST | grep -o '0x[0-9a-f]*'); do
        info=$(xprop -id "$id" _NET_WM_STATE _NET_WM_DESKTOP 2>/dev/null)
        desk=$(echo "$info" | awk '/_NET_WM_DESKTOP/ {print $3}')

        # skip windows on other workspaces (4294967295 = on all workspaces)
        [ "$desk" != "$cur" ] && [ "$desk" != "4294967295" ] && continue
        # skip minimized windows
        echo "$info" | grep -q HIDDEN && continue

        if echo "$info" | grep -qE "MAXIMIZED_VERT|FULLSCREEN"; then
            want=1
            break
        fi
    done

    if [ "$want" != "$last" ]; then
        gsettings set "$KEY" launcher-hide-mode "$want"
        last=$want
    fi

    sleep 0.5
done
SCRIPT_EOF
chmod +x "$BIN"

cat > "$DESKTOP" << DESKTOP_EOF
[Desktop Entry]
Type=Application
Name=Unity Launcher Fullscreen Hide
Comment=Hide the launcher only when a window is maximized or fullscreen
Exec=$BIN
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=3
DESKTOP_EOF

# start it now, no logout needed
nohup "$BIN" > /dev/null 2>&1 &

echo "Installed. Running now and will start on every login."
