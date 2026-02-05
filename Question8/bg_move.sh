#!/bin/bash

# Script: bg_move.sh
# Description: Moves files to backup directory using background processes

# Check if directory argument is provided
if [ $# -ne 1 ]; then
    echo "Error: Please provide exactly one directory path."
    echo "Usage: $0 <directory>"
    exit 1
fi

source_dir="$1"

# Validate directory exists
if [ ! -d "$source_dir" ]; then
    echo "Error: Directory '$source_dir' does not exist."
    exit 1
fi

# Create backup subdirectory
backup_dir="$source_dir/backup"
mkdir -p "$backup_dir"

echo "Background File Mover"
echo "========================================"
echo "Source directory: $source_dir"
echo "Backup directory: $backup_dir"
echo ""
echo "Moving files in background..."
echo ""

# Array to store PIDs
declare -a pids

# Counter for files
file_count=0

# Move each file in background
for file in "$source_dir"/*; do
    # Skip if it's the backup directory itself
    if [ "$file" = "$backup_dir" ]; then
        continue
    fi
    
    # Process only regular files
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        
        # Move file in background
        (
            mv "$file" "$backup_dir/"
            echo "  [PID $$] Moved: $filename"
        ) &
        
        # Store the PID
        pid=$!
        pids+=($pid)
        
        echo "Started background process for '$filename' with PID: $pid"
        file_count=$((file_count + 1))
    fi
done

echo ""
echo "Total files being moved: $file_count"
echo "Waiting for all background processes to complete..."
echo ""

# Wait for all background processes
for pid in "${pids[@]}"; do
    wait $pid
    echo "Process $pid completed"
done

echo ""
echo "All background processes finished!"
echo "========================================"
echo "All files have been moved to $backup_dir"
