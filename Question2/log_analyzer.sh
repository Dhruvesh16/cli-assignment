#!/bin/bash

# Script: log_analyzer.sh
# Description: Analyzes log files and generates summary reports

# Check if log file argument is provided
if [ $# -ne 1 ]; then
    echo "Error: Please provide exactly one log file as argument."
    echo "Usage: $0 <logfile>"
    exit 1
fi

logfile="$1"

# Validate file exists
if [ ! -f "$logfile" ]; then
    echo "Error: File '$logfile' does not exist."
    exit 1
fi

# Check if file is readable
if [ ! -r "$logfile" ]; then
    echo "Error: File '$logfile' is not readable."
    exit 1
fi

echo "Analyzing log file: $logfile"
echo "========================================"

# Count total log entries
total_entries=$(wc -l < "$logfile")
echo "Total log entries: $total_entries"

# Count INFO, WARNING, and ERROR messages
info_count=$(grep -c "INFO" "$logfile")
warning_count=$(grep -c "WARNING" "$logfile")
error_count=$(grep -c "ERROR" "$logfile")

echo "INFO messages: $info_count"
echo "WARNING messages: $warning_count"
echo "ERROR messages: $error_count"

# Display most recent ERROR message
echo ""
echo "Most recent ERROR message:"
most_recent_error=$(grep "ERROR" "$logfile" | tail -1)

if [ -n "$most_recent_error" ]; then
    echo "$most_recent_error"
else
    echo "No ERROR messages found."
fi

# Generate report file with current date
current_date=$(date +%Y-%m-%d)
report_file="log_summary_${current_date}.txt"

echo ""
echo "Generating report file: $report_file"

# Create report
{
    echo "Log Analysis Report"
    echo "==================="
    echo "Generated on: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Log file analyzed: $logfile"
    echo ""
    echo "Summary Statistics:"
    echo "-------------------"
    echo "Total log entries: $total_entries"
    echo "INFO messages: $info_count"
    echo "WARNING messages: $warning_count"
    echo "ERROR messages: $error_count"
    echo ""
    echo "Most Recent ERROR:"
    echo "------------------"
    if [ -n "$most_recent_error" ]; then
        echo "$most_recent_error"
    else
        echo "No ERROR messages found."
    fi
} > "$report_file"

echo "Report generated successfully!"
echo "========================================"
