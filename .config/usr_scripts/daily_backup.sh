#!/bin/bash

# Backup directories
BACKUP_SOURCE_HOME="$HOME"
BACKUP_SOURCE_ETC="/etc"
BACKUP_SOURCE_USR="/usr/share/applications"

# Backup destination
BACKUP_DEST="file:///run/media/Drive_Backup/Deja"

# Log file for backup
LOG_FILE="/var/log/duplicity_backup.log"

# Passphrase for encryption (make sure it's secure and private)
export PASSPHRASE=$(cat ~/.duplicity_passphrase)

# Retention policy (keep backups for 30 days)
RETENTION="--archive-dir ~/.cache/duplicity --no-encryption --no-compression --volsize 100 --full-if-older-than 30D"

# Check for sufficient disk space (example: check if there's 10GB free space)
FREE_SPACE=$(df /run/media/Drive_Backup | tail -1 | awk '{print $4}')
if [ $FREE_SPACE -lt 10000000 ]; then
    echo "Not enough space on the backup drive. Backup aborted." >> "$LOG_FILE"
    exit 1
fi

# Run backup for each directory
{
    echo "Backup started: $(date)"
    
    # Home backup
    if duplicity $RETENTION $BACKUP_SOURCE_HOME "$BACKUP_DEST/home"; then
        echo "Home backup completed successfully"
    else
        echo "Home backup failed with exit code $?"
    fi

    # Etc backup
    if duplicity $RETENTION $BACKUP_SOURCE_ETC "$BACKUP_DEST/etc"; then
        echo "Etc backup completed successfully"
    else
        echo "Etc backup failed with exit code $?"
    fi

    # Usr/share backup
    if duplicity $RETENTION $BACKUP_SOURCE_USR "$BACKUP_DEST/usr-share-applications"; then
        echo "Usr/share backup completed successfully"
    else
        echo "Usr/share backup failed with exit code $?"
    fi

    echo "Backup finished: $(date)"
} >> "$LOG_FILE" 2>&1

# Remove old backups
duplicity remove-older-than 30D --force "$BACKUP_DEST/home"
duplicity remove-older-than 30D --force "$BACKUP_DEST/etc"
duplicity remove-older-than 30D --force "$BACKUP_DEST/usr-share-applications"

# Unset passphrase for security
unset PASSPHRASE

