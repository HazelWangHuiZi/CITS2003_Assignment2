#!/bin/bash

input_file=$1

# 1. Keep only the required columns (1st to 5th)
# 2. Split the 4th column to extract month and year and append to the end
# 3. If there is a comma or slash in the 5th column, keep only the part before it
# 4. Remove lines with empty fields or incorrect date format
awk -F '\t' 'BEGIN {OFS = FS} {
    if (NF != 7 || $4 !~ /^[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4}$/) next
    split($4, date, "/")
    $4 = date[1] "/" date[2] "/" date[3]
    $6 = date[1]
    $7 = date[3]
    split($5, breach, "[,/]")
    $5 = breach[1]
    print $1, $2, $3, $4, $5, $6, $7
}' $input_file

