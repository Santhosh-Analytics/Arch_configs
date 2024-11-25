#!/bin/bash

updates=$(checkupdates 2>/dev/null | wc -l)
aur_updates=$(yay -Qum 2>/dev/null | wc -l)

total=$((updates + aur_updates))

if [ "$total" -gt 0 ]; then
    echo "{\"text\": \"📦 $total\", \"tooltip\": \"$updates official, $aur_updates AUR\"}"
else
    echo "{\"text\": \"\"}"
fi
