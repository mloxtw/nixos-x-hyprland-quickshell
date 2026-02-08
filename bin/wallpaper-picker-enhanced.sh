i#!/bin/bash

# Ultra-Fast Wallpaper Picker - Instant loading for large collections
# Uses pre-built cache for sub-second startup with 1000+ wallpapers

WALLPAPER_DIR="$HOME/wallpapers/lwalpapers/wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper-picker"
THUMBNAIL_DIR="$CACHE_DIR/thumbnails"
CURRENT_WALLPAPER_FILE="$CACHE_DIR/current_wallpaper"
OPTIONS_CACHE="$CACHE_DIR/rofi_options.cache"
PATH_MAP="$CACHE_DIR/path_map.cache"
LAST_SCAN="$CACHE_DIR/last_scan"

mkdir -p "$CACHE_DIR"
mkdir -p "$THUMBNAIL_DIR"

# Check if swww daemon is running
if ! pgrep -x swww-daemon > /dev/null; then
    swww-daemon &
    sleep 0.5
fi

if [ ! -d "$WALLPAPER_DIR" ]; then
    rofi -e "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

# Function to rebuild cache in background
rebuild_cache_bg() {
    {
        echo "Scanning for wallpapers..."
        
        # Fast find with minimal depth
        WALLPAPERS=$(find "$WALLPAPER_DIR" -maxdepth 2 -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) 2>/dev/null | sort)
        
        if [ -z "$WALLPAPERS" ]; then
            exit 1
        fi
        
        # Build path map (filename -> full path) in one pass
        declare -A PATH_LOOKUP
        > "$PATH_MAP.tmp"
        
        while IFS= read -r wallpaper; do
            filename=$(basename "$wallpaper")
            echo "$filename|$wallpaper" >> "$PATH_MAP.tmp"
        done <<< "$WALLPAPERS"
        
        mv "$PATH_MAP.tmp" "$PATH_MAP"
        
        # Check ImageMagick
        if ! command -v convert &> /dev/null; then
            # No thumbnails - use original images
            > "$OPTIONS_CACHE.tmp"
            while IFS= read -r wallpaper; do
                filename=$(basename "$wallpaper")
                echo -e "${filename}\0icon\x1f${wallpaper}" >> "$OPTIONS_CACHE.tmp"
            done <<< "$WALLPAPERS"
            mv "$OPTIONS_CACHE.tmp" "$OPTIONS_CACHE"
            date +%s > "$LAST_SCAN"
            exit 0
        fi
        
        # Generate missing thumbnails
        > "$OPTIONS_CACHE.tmp"
        PENDING=()
        
        while IFS= read -r wallpaper; do
            filename=$(basename "$wallpaper")
            # Use first 16 chars of md5 for speed
            hash=$(echo -n "$wallpaper" | md5sum | cut -c1-16)
            thumbnail="$THUMBNAIL_DIR/${hash}.jpg"
            
            if [ -f "$thumbnail" ]; then
                echo -e "${filename}\0icon\x1f${thumbnail}" >> "$OPTIONS_CACHE.tmp"
            else
                echo -e "${filename}\0icon\x1f${wallpaper}" >> "$OPTIONS_CACHE.tmp"
                PENDING+=("$wallpaper|$hash")
            fi
        done <<< "$WALLPAPERS"
        
        mv "$OPTIONS_CACHE.tmp" "$OPTIONS_CACHE"
        date +%s > "$LAST_SCAN"
        
        # Generate thumbnails in background if any are missing
        if [ ${#PENDING[@]} -gt 0 ]; then
            (
                # Create batch conversion script
                BATCH_SCRIPT=$(mktemp)
                cat > "$BATCH_SCRIPT" << 'EOF'
#!/bin/bash
IFS='|' read -r img hash <<< "$1"
[ -f "$2/${hash}.jpg" ] && exit 0
convert "$img" -thumbnail 150x150^ -gravity center -extent 150x150 -quality 70 "$2/${hash}.jpg" 2>/dev/null &
EOF
                chmod +x "$BATCH_SCRIPT"
                
                # Limit parallel jobs to avoid system overload
                JOBS=$(($(nproc) * 2))
                printf "%s\n" "${PENDING[@]}" | xargs -P $JOBS -I {} "$BATCH_SCRIPT" {} "$THUMBNAIL_DIR"
                
                rm -f "$BATCH_SCRIPT"
                
                # Rebuild cache with new thumbnails
                > "$OPTIONS_CACHE.tmp"
                while IFS= read -r wallpaper; do
                    filename=$(basename "$wallpaper")
                    hash=$(echo -n "$wallpaper" | md5sum | cut -c1-16)
                    thumbnail="$THUMBNAIL_DIR/${hash}.jpg"
                    
                    if [ -f "$thumbnail" ]; then
                        echo -e "${filename}\0icon\x1f${thumbnail}" >> "$OPTIONS_CACHE.tmp"
                    else
                        echo -e "${filename}\0icon\x1f${wallpaper}" >> "$OPTIONS_CACHE.tmp"
                    fi
                done <<< "$WALLPAPERS"
                mv "$OPTIONS_CACHE.tmp" "$OPTIONS_CACHE"
                
                notify-send "Wallpaper Picker" "Thumbnails generated!"
            ) &
        fi
    } >/dev/null 2>&1
}

# Check if cache needs rebuild
REBUILD=0

if [ "$1" = "--rebuild" ]; then
    REBUILD=1
elif [ ! -f "$OPTIONS_CACHE" ] || [ ! -f "$PATH_MAP" ]; then
    REBUILD=1
elif [ ! -f "$LAST_SCAN" ]; then
    REBUILD=1
else
    # Only rebuild if wallpaper dir changed in last 5 minutes
    LAST_MODIFIED=$(stat -c %Y "$WALLPAPER_DIR" 2>/dev/null || echo 0)
    LAST_SCAN_TIME=$(cat "$LAST_SCAN" 2>/dev/null || echo 0)
    
    if [ $LAST_MODIFIED -gt $LAST_SCAN_TIME ]; then
        REBUILD=1
    fi
fi

if [ $REBUILD -eq 1 ]; then
    # Show loading message
    notify-send "Wallpaper Picker" "Rebuilding cache..."
    rebuild_cache_bg
    wait  # Wait for cache to be built
fi

# INSTANT LOAD - Just cat the pre-built cache
SELECTED=$(cat "$OPTIONS_CACHE" 2>/dev/null | rofi -dmenu -i \
    -p "Wallpaper (${#WALLPAPER_ARRAY[@]})" \
    -show-icons \
    -theme-str 'window { location: north; anchor: north; width: 100%; y-offset: 0; }' \
    -theme-str 'listview { lines: 1; columns: 8; }' \
    -theme-str 'element { padding: 8px; orientation: vertical; }' \
    -theme-str 'element-icon { size: 3.5em; }' \
    -theme-str 'element-text { horizontal-align: 0.5; }' \
    -format s \
    -no-custom)

[ -z "$SELECTED" ] && exit 0

# Fast path lookup using grep (faster than bash loop for 940 files)
SELECTED_PATH=$(grep -m1 "^${SELECTED}|" "$PATH_MAP" 2>/dev/null | cut -d'|' -f2-)

# Set wallpaper
if [ -n "$SELECTED_PATH" ] && [ -f "$SELECTED_PATH" ]; then
    swww img "$SELECTED_PATH" --transition-type fade --transition-fps 60 --transition-duration 2 &
    echo "$SELECTED_PATH" > "$CURRENT_WALLPAPER_FILE"
    notify-send "Wallpaper Changed" "$(basename "$SELECTED_PATH")"
else
    rofi -e "Wallpaper not found: $SELECTED"
fi
