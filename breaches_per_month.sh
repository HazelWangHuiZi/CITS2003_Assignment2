#!/bin/bash

input_file=$1

# Compute the total number of incidents per month
incidents_per_month=$(awk -F '\t' '{print $6}' $input_file | sort | uniq -c)

# Compute the median and MAD of the incidents
median=$(echo "$incidents_per_month" | awk '{print $1}' | datamash median 1)
mad=$(echo "$incidents_per_month" | awk '{print $1}' | datamash mad 1)

# Define an array to map the month number to its name
declare -a month_name=("Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")

# Convert the bash array to a string
month_name_string=$(IFS=','; echo "${month_name[*]}")

# Print the median and MAD
echo "Median: $median"
echo "MAD: $mad"

# Print the results
echo "$incidents_per_month" | awk -v median=$median -v mad=$mad -v month_name_string="$month_name_string" 'BEGIN {
    split(month_name_string, month_name, ",")
} {
    if ($1 > median + mad) sign = "++"
    else if ($1 < median - mad) sign = "--"
    else sign = ""
    printf "%s\t%d\t%s\n", month_name[$2], $1, sign
}'

