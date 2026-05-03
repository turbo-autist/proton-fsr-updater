#!/bin/bash

# Configuration
CACHE_DIR="$HOME/.cache/protonfixes/upscalers"
MASTER_NAME="amdxcffx64_v4.1.0_69A0952A304a000.dll"
TEMP_DIR="/tmp/fsr_upgrade"

# Function to map internal versions to Marketing names
get_marketing_name() {
    local ver=$1
    if [[ $ver == 1.0.0.* ]]; then echo "FSR 4.0.0 (Early 2025)";
    elif [[ $ver == 1.0.1.* ]]; then echo "FSR 4.0.1";
    elif [[ $ver == 1.0.2.* ]]; then echo "FSR 4.0.2";
    elif [[ $ver == 1.0.3.* ]]; then echo "FSR 4.0.3";
    elif [[ $ver == 2.1.0.* ]]; then echo "FSR 4.1.0";
    elif [[ $ver == 2.2.0.* ]]; then echo "FSR 4.1.1";
    elif [[ $ver == 2.3.0.* ]]; then echo "FSR 4.2.0 (Future Release)";
    else echo "FSR Next-Gen ($ver)"; fi
}

mkdir -p "$CACHE_DIR" "$TEMP_DIR"

echo "--- Extracting: $(basename "$1") ---"
7z e -r "$1" "amdxcffx64.dll" -o"$TEMP_DIR" -y > /dev/null 2>&1
NEW_DLL=$(ls -S "$TEMP_DIR"/amdxcffx64.dll | head -n 1)

if [ ! -f "$NEW_DLL" ]; then echo "Error: DLL not found in this package."; exit 1; fi

# 1. Get Metadata for New DLL
NEW_VER=$(exiftool -s -S -FileVersion "$NEW_DLL" || echo "0.0.0.0")
NEW_NAME=$(get_marketing_name "$NEW_VER")

# 2. Check Cache
FINAL_PATH="$CACHE_DIR/$MASTER_NAME"
if [ -f "$FINAL_PATH" ]; then
    OLD_VER=$(exiftool -s -S -FileVersion "$FINAL_PATH" || echo "0.0.0.0")
    OLD_NAME=$(get_marketing_name "$OLD_VER")

    echo " [Comparison]"
    echo "   - Extracted: $NEW_NAME ($NEW_VER)"
    echo "   - Existing:  $OLD_NAME ($OLD_VER)"

    if [[ "$NEW_VER" < "$OLD_VER" ]]; then
        echo " [!] Result: Skipping. Existing cache is already newer."
        rm -rf "$TEMP_DIR"; exit 0
    elif [[ "$NEW_VER" == "$OLD_VER" ]]; then
        echo " [!] Result: Already up to date."
        rm -rf "$TEMP_DIR"; exit 0
    fi
else
    echo " [!] Cache is empty. Initializing first-time setup."
fi

# 3. Deployment
echo " [+] Result: Upgrading cache to $NEW_NAME..."
cp "$NEW_DLL" "$FINAL_PATH"

# 4. Success Output
echo "------------------------------------------------------------"
echo " SUCCESS: FSR Component Updated to $NEW_NAME"
echo " SAVED TO: $FINAL_PATH"
echo "------------------------------------------------------------"
echo " To enable in Steam, use these Launch Options:"
echo ""
echo " FSR4_UPGRADE=1 PROTON_FSR4_INDICATOR=1 %command%"
echo "------------------------------------------------------------"

rm -rf "$TEMP_DIR"
