#!/bin/bash
# author: Mauricio Pasten (mrp4sten)

DESKTOP_NAME=$(gum input --placeholder "Enter name desktop entry file")
DISYPLAY_NAME=$(gum input --placeholder "Enter display for application")
DESCRIPTION=$(gum input --placeholder "Enter description from application")
VERSION=$(gum input --placeholder "Enter application version")
EXEC=$(gum input --placeholder "Enter command to execute application")
ICON=$(gum input --placeholder "Enter icon path for application")

FILE="${DESKTOP_NAME}.desktop"

if [ -z "$DESKTOP_NAME" ] || [ -z "$DISYPLAY_NAME" ] || [ -z "$VERSION" ] || [ -z "$EXEC" ]; then
    echo "Error: Desktop entry, display name, version and exec are required."
    exit 1
fi

cat > "${FILE}" << EOF
[Desktop Entry]
Version=${VERSION}
Encoding=UTF-8
Name=${DISYPLAY_NAME}
Comment=${DESCRIPTION}
Exec=${EXEC}
Icon=${ICON}
Terminal=false
Type=Application
EOF

sudo install -D -m 0644 "${FILE}" /usr/share/applications/"${FILE}"