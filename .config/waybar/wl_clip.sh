#!/bin/bash

clipboard_content=$(wl-paste -n)

max_length=30

if [ ${#clipboard_content} -gt $max_length ]; then
    clipboard_content="${clipboard_content:0:max_length}..."
fi

echo "$clipboard_content"
