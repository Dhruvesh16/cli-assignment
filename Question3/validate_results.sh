#!/bin/bash

# Script: validate_results.sh
# Description: Validates student results from marks.txt

# Check if marks file exists
if [ ! -f "marks.txt" ]; then
    echo "Error: marks.txt file not found!"
    exit 1
fi

echo "Student Results Validation"
echo "======================================"
echo ""

# Initialize counters
fail_one_count=0
pass_all_count=0

# Arrays to store student details
declare -a fail_one_students
declare -a pass_all_students

# Passing marks threshold
PASS_MARKS=33

echo "Students who failed in exactly ONE subject:"
echo "-------------------------------------------"

# Read marks.txt line by line
while IFS=',' read -r rollno name marks1 marks2 marks3; do
    # Trim whitespace
    rollno=$(echo "$rollno" | xargs)
    name=$(echo "$name" | xargs)
    marks1=$(echo "$marks1" | xargs)
    marks2=$(echo "$marks2" | xargs)
    marks3=$(echo "$marks3" | xargs)
    
    # Count failures
    fail_count=0
    
    if [ $marks1 -lt $PASS_MARKS ]; then
        fail_count=$((fail_count + 1))
    fi
    
    if [ $marks2 -lt $PASS_MARKS ]; then
        fail_count=$((fail_count + 1))
    fi
    
    if [ $marks3 -lt $PASS_MARKS ]; then
        fail_count=$((fail_count + 1))
    fi
    
    # Check if failed in exactly one subject
    if [ $fail_count -eq 1 ]; then
        echo "$rollno, $name, Marks: $marks1, $marks2, $marks3"
        fail_one_count=$((fail_one_count + 1))
    fi
    
    # Check if passed all subjects
    if [ $fail_count -eq 0 ]; then
        pass_all_students+=("$rollno, $name, Marks: $marks1, $marks2, $marks3")
        pass_all_count=$((pass_all_count + 1))
    fi
    
done < marks.txt

echo ""
echo "Students who passed in ALL subjects:"
echo "-------------------------------------"

# Display students who passed all subjects
for student in "${pass_all_students[@]}"; do
    echo "$student"
done

echo ""
echo "Summary:"
echo "========================================"
echo "Students failed in exactly ONE subject: $fail_one_count"
echo "Students passed in ALL subjects: $pass_all_count"
echo "========================================"
