#!/bin/bash

# Script: sync.sh
# Description: Compares two directories and reports differences

# Check if exactly two arguments are provided
if [ $# -ne 2 ]; then
    echo "Error: Please provide exactly two directory paths."
    echo "Usage: $0 <dirA> <dirB>"
    exit 1
fi

dirA="$1"
dirB="$2"

# Validate both directories exist
if [ ! -d "$dirA" ]; then
    echo "Error: Directory '$dirA' does not exist."
    exit 1
fi

if [ ! -d "$dirB" ]; then
    echo "Error: Directory '$dirB' does not exist."
    exit 1
fi

echo "Directory Synchronization Checker"
echo "========================================"
echo "Comparing: $dirA and $dirB"
echo ""

# List files present only in dirA
echo "Files present ONLY in $dirA:"
echo "----------------------------"
only_in_A=0
for file in "$dirA"/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        if [ ! -f "$dirB/$filename" ]; then
            echo "  - $filename"
            only_in_A=$((only_in_A + 1))
        fi
    fi
done

if [ $only_in_A -eq 0 ]; then
    echo "  (none)"
fi

echo ""

# List files present only in dirB
echo "Files present ONLY in $dirB:"
echo "----------------------------"
only_in_B=0
for file in "$dirB"/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        if [ ! -f "$dirA/$filename" ]; then
            echo "  - $filename"
            only_in_B=$((only_in_B + 1))
        fi
    fi
done

if [ $only_in_B -eq 0 ]; then
    echo "  (none)"
fi

echo ""

# Check files with same name for content differences
echo "Files with SAME name - Content comparison:"
echo "-------------------------------------------"
common_files=0
matching_content=0
different_content=0

for file in "$dirA"/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        if [ -f "$dirB/$filename" ]; then
            common_files=$((common_files + 1))
            
            # Compare file contents using cmp
            if cmp -s "$file" "$dirB/$filename"; then
                echo "  ✓ $filename - Contents MATCH"
                matching_content=$((matching_content + 1))
            else
                echo "  ✗ $filename - Contents DIFFER"
                different_content=$((different_content + 1))
            fi
        fi
    fi
done

if [ $common_files -eq 0 ]; then
    echo "  (no common files)"
fi

echo ""
echo "Summary:"
echo "========================================"
echo "Files only in $dirA: $only_in_A"
echo "Files only in $dirB: $only_in_B"
echo "Common files with matching content: $matching_content"
echo "Common files with different content: $different_content"
echo "========================================"
