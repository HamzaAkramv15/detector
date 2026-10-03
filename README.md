# Detector

Keeps the **Ubuntu Unity** launcher visible, but hides it only while a window is **maximized or fullscreen** on your current workspace. Un-maximize or switch workspace and the launcher comes back.

Unity's built-in autohide hides the launcher all the time. This gives you the always-visible launcher for normal work, and the extra screen space for maximized windows and fullscreen apps.

## How it works

A small background script polls every 0.5 seconds. It uses `xprop` to look at every window on the current workspace (windows on other workspaces and minimized windows are ignored; windows on all workspaces still count). If any of them is maximized or fullscreen, it sets Unity's `launcher-hide-mode` to autohide (`1`). Otherwise it sets it back to never hide (`0`). The setting is only written when the state actually changes.

If the script is stopped, it resets the launcher to always visible before exiting.

## Install

```bash
git clone https://github.com/HamzaAkramv15/detector.git
cd detector
./install.sh
```

The installer:

- writes the script to `~/.local/bin/unity-launcher-fs.sh`
- adds an autostart entry at `~/.config/autostart/unity-launcher-fs.desktop` (3 second delay at login)
- starts it immediately, so no logout is needed

Requirements: Ubuntu Unity (`unityshell` gsettings schema), `gsettings`, and `xprop` (`sudo apt install x11-utils`). X11 only.

## Uninstall

```bash
./uninstall.sh
```

Stops the script, removes it and the autostart entry, and sets the launcher back to always visible.
