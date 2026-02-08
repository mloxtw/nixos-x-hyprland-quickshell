
THEME=${1:-}
THEMES_DIR="$HOME/.config/themes"

declare -A THEMES=(
    ["catppuccin-mocha"]="#1e1e2e"
    ["nord"]="#2e3440"
    ["gruvbox"]="#282828"
    ["dracula"]="#282a36"
    ["tokyo-night"]="#1a1b26"
)

if [ -z "$THEME" ]; then
    CURRENT=$(cat ~/.cache/current-theme 2>/dev/null || echo "catppuccin-mocha")
    echo "Current theme: $CURRENT"
    echo ""
    echo "Available themes:"
    for t in "${!THEMES[@]}"; do
        [ "$t" = "$CURRENT" ] && echo "  → $t" || echo "    $t"
    done
    echo ""
    echo "Usage: theme-switch <theme>"
    exit 0
fi

if [[ ! -v THEMES["$THEME"] ]]; then
    echo "Theme not found: $THEME"
    exit 1
fi

echo "Applying theme: $THEME"

# Save theme
echo "$THEME" > ~/.cache/current-theme

# Waybar
ln -sf "$THEMES_DIR/waybar/$THEME/style.css" ~/.config/waybar/style.css 2>/dev/null
pkill waybar; waybar &>/dev/null &

# Rofi
ln -sf "$THEMES_DIR/rofi/$THEME.rasi" ~/.config/rofi/current-theme.rasi 2>/dev/null

# Hyprland
#mkdir -p ~/.config/hypr/themes
#ln -sf "$THEMES_DIR/hypr/$THEME.conf" ~/.config/hypr/themes/current.conf 2>/dev/null
#hyprctl reload &>/dev/null

# Quickshell - update color
cat > ~/.config/quickshell/shell.qml << QSEOF
import Quickshell
import Quickshell.Wayland

ShellRoot {
    PanelWindow {
        anchors {
            left: true
            right: true
            top: true
        }
        height: 30
        color: "${THEMES[$THEME]}"
    }
}
QSEOF

pkill quickshell
quickshell &>/dev/null &

echo "✓ Theme applied: $THEME"
