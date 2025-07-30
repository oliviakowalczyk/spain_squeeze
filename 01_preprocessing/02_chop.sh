#!/bin/bash

dir="/data/project/SPAIN/derivatives/squeeze/"

# read subject, session, and z coordinate variables from a csv file
while IFS="," read -r data chop_z; do
    echo "Data: ${data}"
    echo "Chop z coordinate: ${chop_z}"

    # Extract subject, session, and run values from data
    sub=$(echo "$data" | cut -d'_' -f1)
    ses=$(echo "$data" | cut -d'_' -f2)
    run=$(echo "$data" | cut -d'_' -f4)

    echo "Subject: $sub, Session: $ses, Run: $run"

    # Ensure the directory exists before changing into it
    target_dir="${dir}/derivatives/preprocessing/${sub}/${ses}/${run}"
    if [ -d "$target_dir" ]; then
        cd "$target_dir" || exit  # Exit if cd fails
    else
        echo "Directory ${target_dir} does not exist. Skipping."
        continue
    fi

    # Check if a file containing "chop" already exists
    chop_file=$(ls *chop* 2>/dev/null)
    if [ -n "$chop_file" ]; then
        echo "A 'chop' file already exists: $chop_file. Aborting operation for this subject."
        continue  # Skip to the next iteration if a chop file exists
    fi

    # Add 1 to the chop_z value safely using arithmetic expression
    chop_z_func_plus_one=$((chop_z + 1))
    echo "Separating cord of ${data} at z ${chop_z_func_plus_one}..."

    # Check if a file containing "shifted" exists in the directory
    shifted=$(ls *shifted.nii.gz* 2>/dev/null)
    if [ -n "$shifted" ]; then
        echo "Found a shifted file: $shifted"
    else
        shifted="${data}"  # Default value if no shifted file is found
        echo "No shifted file found, using default: $shifted"
    fi

    # Perform fslroi operation - use quotes around file paths to handle spaces
    fslroi "$shifted" "chop" 0 -1 0 -1 0 ${chop_z_func_plus_one} 0 -1

done < "${dir}/code/chop_z.csv"
