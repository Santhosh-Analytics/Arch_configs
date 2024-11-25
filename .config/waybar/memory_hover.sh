#!/bin/bash

# Get the top 5 memory-consuming applications
echo "Top 5 Memory-consuming Applications:"
ps -eo pmem,comm --sort=-pmem | head -n 6 | awk '{printf "%s: %s\n", $1, $2}'
