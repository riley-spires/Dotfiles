set -xe

# This disables dynamic workspaces
gsettings set org.gnome.mutter dynamic-workspaces false

# This sets the number of static workspaces to 10
gsettings set org.gnome.desktop.wm.preferences num-workspaces 10

# Remove any conflicting keybinds for switching workspaces
gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false
for i in {1..9}; do
  gsettings set org.gnome.shell.keybindings switch-to-application-$i "['']"
done

# Set SUPER+(1-9) to SWITCH to workspace
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>0']"
for i in {1..9}; do
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
done

# Set SUPER+SHIFT+(1-9) to MOVE window to workspace
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 "['<Super><Shift>0']"
for i in {1..9}; do
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Super><Shift>$i']"
done

# Update shell to wezterm
gsettings set org.gnome.desktop.default-applications.terminal exec 'wezterm'
