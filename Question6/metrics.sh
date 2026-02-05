#!/bin/bash

# Script: metrics.sh
# Description: Analyzes text file and provides word statistics

# Check if input file is provided
if [ $# -ne 1 ]; then
    echo "Error: Please provide exactly one text file as argument."
    echo "Usage: $0 <input.txt>"
    exit 1
fi

input_file="$1"

# Validate file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' does not exist."
    exit 1
fi

echo "Text File Metrics Analyzer"
echo "========================================"
echo "Analyzing: $input_file"
echo ""

# Extract all words (convert to lowercase, one word per line)
words=$(tr -cs 'A-Za-z' '\n' < "$input_file" | tr 'A-Z' 'a-z' | grep -v '^$')

# Find longest word
longest=$(echo "$words" | awk '{ if (length($0) > max) {max = length($0); word = $0} } END {print word}')
longest_len=$(echo "$longest" | wc -c)
longest_len=$((longest_len - 1))  # Remove newline

echo "Longest word: $longest (length: $longest_len)"

# Find shortest word
shortest=$(echo "$words" | awk '{ if (NR == 1 || length($0) < min) {min = length($0); word = $0} } END {print word}')
shortest_len=$(echo "$shortest" | wc -c)
shortest_len=$((shortest_len - 1))  # Remove newline

echo "Shortest word: $shortest (length: $shortest_len)"

# Calculate average word length
total_length=$(echo "$words" | awk '{sum += length($0)} END {print sum}')
word_count=$(echo "$words" | wc -l)

if [ $word_count -gt 0 ]; then
    avg_length=$(echo "scale=2; $total_length / $word_count" | bc)
    echo "Average word length: $avg_length"
else
    echo "Average word length: 0"
fi

# Count unique words
unique_count=$(echo "$words" | sort | uniq | wc -l)
echo "Total unique words: $unique_count"

echo ""
echo "Additional Statistics:"
echo "----------------------"
echo "Total words (including duplicates): $word_count"
echo "========================================"
