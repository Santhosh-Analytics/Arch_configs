#!/bin/bash

# Directories for source and destination
SOURCE_DIR="$HOME/.config"
DEST_DIR="$HOME/.configs/.config"
EXCLUDE_FILE="$HOME/.config/usr_scripts/exclude_list.txt"
LOG_FILE="$HOME/.config/dotfile_sync.log"

# Function to log messages with timestamp
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Start the script
log "Script started."

# Ensure the destination directory exists
mkdir -p "$DEST_DIR"

# Setup inotify to watch the source directory recursively
log "Setting up inotifywait to watch $SOURCE_DIR recursively..."

# Trap errors to log if something goes wrong
trap 'log "Error occurred at $(date)"' ERR

# Start watching the directory recursively
while true; do
    # Wait for changes to occur in the source directory
    inotifywait -m -r -e modify,create,delete "$SOURCE_DIR" | while read path action file; do
        # Log the file being watched
        log "Watching $path$file"

        # Check if the path matches any pattern in the exclusion list
        if ! grep -q -F -f "$EXCLUDE_FILE" <<< "${path#$SOURCE_DIR/}"; then
            # Log change
            log "Change detected in $path$file - Action: $action"

            # Run rsync to sync changes to the destination directory
            log "Running rsync to sync $path$file..."
            rsync -av --delete --exclude-from="$EXCLUDE_FILE" "$SOURCE_DIR/" "$DEST_DIR/" >> "$LOG_FILE" 2>&1
            log "Rsync completed for $path$file."
        else
            # Log the exclusion (optional)
            log "Change detected in $path$file, but it is excluded based on the exclusion list."
        fi
    done
done

