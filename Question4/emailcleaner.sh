#!/bin/bash

# Script: emailcleaner.sh
# Description: Extracts and validates email addresses from emails.txt

# Check if emails.txt exists
if [ ! -f "emails.txt" ]; then
    echo "Error: emails.txt file not found!"
    exit 1
fi

echo "Email Cleaner - Processing emails.txt"
echo "========================================"

# Valid email pattern: <letters_and_digits>@<letters>.com
# Using grep with extended regex
grep -E '^[a-zA-Z0-9]+@[a-zA-Z]+\.com$' emails.txt | sort | uniq > valid.txt

# Extract invalid emails (lines that don't match valid pattern)
grep -v -E '^[a-zA-Z0-9]+@[a-zA-Z]+\.com$' emails.txt > invalid.txt

# Count results
valid_count=$(wc -l < valid.txt)
invalid_count=$(wc -l < invalid.txt)

echo "Processing complete!"
echo ""
echo "Valid emails (after removing duplicates): $valid_count"
echo "Invalid emails: $invalid_count"
echo ""
echo "Results saved to:"
echo "  - valid.txt (unique valid emails)"
echo "  - invalid.txt (invalid emails)"
echo ""

# Display samples
echo "Sample valid emails (first 5):"
head -5 valid.txt

echo ""
echo "Sample invalid emails (first 5):"
head -5 invalid.txt

echo ""
echo "========================================"
