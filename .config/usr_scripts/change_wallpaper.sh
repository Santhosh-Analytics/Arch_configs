#!/bin/bash

# This script will randomly cycle through images in a directory and set them as wallpaper at regular intervals.

if [[ $# -lt 1 ]] || [[ ! -d $1 ]]; then
    echo "Usage: $0 <directory containing images>"
    exit 1
fi

# Set transition options for swww
export SWWW_TRANSITION_FPS=144
export SWWW_TRANSITION_STEP=2
export SWWW_TRANSITION_TYPE=random

# Set the interval in seconds for switching images
INTERVAL=300

while true; do
    # Get all images from the provided directory
    find "$1" -type f | shuf | while read -r img; do
        if [[ -f "$img" ]]; then
            swww img "$img"
            sleep "$INTERVAL"
        fi
    done
done

