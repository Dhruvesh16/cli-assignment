#!/bin/bash

# Script: patterns.sh
# Description: Categorizes words based on vowel/consonant patterns

# Check if input file is provided
if [ $# -ne 1 ]; then
    echo "Error: Please provide exactly one text file as argument."
    echo "Usage: $0 <textfile>"
    exit 1
fi

input_file="$1"

# Validate file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' does not exist."
    exit 1
fi

echo "Word Pattern Analyzer"
echo "========================================"
echo "Processing: $input_file"
echo ""

# Clear output files if they exist
> vowels.txt
> consonants.txt
> mixed.txt

# Extract words and process them
tr -cs 'A-Za-z' '\n' < "$input_file" | grep -v '^$' | while read -r word; do
    # Convert to lowercase for checking
    word_lower=$(echo "$word" | tr 'A-Z' 'a-z')
    
    # Check if word contains only vowels (aeiou)
    if echo "$word_lower" | grep -q '^[aeiou]\+$'; then
        echo "$word" >> vowels.txt
    # Check if word contains only consonants
    elif echo "$word_lower" | grep -q '^[bcdfghjklmnpqrstvwxyz]\+$'; then
        echo "$word" >> consonants.txt
    # Check if word starts with consonant and contains both vowels and consonants
    elif echo "$word_lower" | grep -q '^[bcdfghjklmnpqrstvwxyz]' && \
         echo "$word_lower" | grep -q '[aeiou]' && \
         echo "$word_lower" | grep -q '[bcdfghjklmnpqrstvwxyz]'; then
        echo "$word" >> mixed.txt
    fi
done

# Count words in each category
vowel_count=$(wc -l < vowels.txt 2>/dev/null || echo 0)
consonant_count=$(wc -l < consonants.txt 2>/dev/null || echo 0)
mixed_count=$(wc -l < mixed.txt 2>/dev/null || echo 0)

echo "Categorization Complete!"
echo ""
echo "Words containing ONLY vowels: $vowel_count"
echo "Words containing ONLY consonants: $consonant_count"
echo "Mixed words starting with consonant: $mixed_count"
echo ""

# Display samples from each category
echo "Sample words from each category:"
echo "--------------------------------"
echo ""
echo "Vowels only (first 5):"
head -5 vowels.txt 2>/dev/null || echo "  (none)"
echo ""

echo "Consonants only (first 5):"
head -5 consonants.txt 2>/dev/null || echo "  (none)"
echo ""

echo "Mixed (first 10):"
head -10 mixed.txt 2>/dev/null || echo "  (none)"

echo ""
echo "Results saved to:"
echo "  - vowels.txt"
echo "  - consonants.txt"
echo "  - mixed.txt"
echo "========================================"
