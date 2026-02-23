# Paths
dir="/root/dir"
csv_file="${dir}/derivatives/reliability/icc/mean_t/mean_master.csv"
txt_dir="${dir}/derivatives/reliability/icc/mean_t"

# Define order for sessions and ROIs
sessions=("run-1-avg" "run-2-avg" "ses-A-avg" "ses-B-avg")
roi_order=("cord" "network" "spinal_level_c5" "spinal_level_c6" "spinal_level_c7" "spinal_level_c8" "spinal_level_t1")

# Collect all txt files and their column names
declare -a file_list=()
declare -a header_list=()

# Build file list and headers in the specified order: condition-roi-session
for condition in "standard" "paramod"; do
    for roi in "${roi_order[@]}"; do
        for session in "${sessions[@]}"; do
            if [[ $roi == "network" ]]; then
                # Network files have different naming convention
                if [[ $condition == "standard" ]]; then
                    txt_file="${txt_dir}/cope1_${session}_network_mean.txt"
                    col_name="${condition}_${roi}_${session}"
                else
                    txt_file="${txt_dir}/cope1_${session}_paramod_network_mean.txt"
                    col_name="${condition}_${roi}_${session}"
                fi
            else
                # ROI files
                if [[ $condition == "standard" ]]; then
                    txt_file="${txt_dir}/cope1_${session}_${roi}_mean.txt"
                    col_name="${condition}_${roi}_${session}"
                else
                    txt_file="${txt_dir}/cope1_${session}_paramod_${roi}_mean.txt"
                    col_name="${condition}_${roi}_${session}"
                fi
            fi
            
            # Add to arrays
            file_list+=("$txt_file")
            header_list+=("$col_name")
        done
    done
done

# Find the maximum number of lines across all files
max_lines=0
for file in "${file_list[@]}"; do
    if [[ -f "$file" ]]; then
        lines=$(wc -l < "$file")
        if [[ $lines -gt $max_lines ]]; then
            max_lines=$lines
        fi
    fi
done

# Create header
header="Row"
for col in "${header_list[@]}"; do
    header="${header},${col}"
done
echo "${header}" > ${csv_file}

# Create data rows
for ((row=1; row<=max_lines; row++)); do
    data_row="$row"
    for file in "${file_list[@]}"; do
        if [[ -f "$file" ]]; then
            value=$(sed -n "${row}p" "$file" | tr -d '\n')  # Get specific line
            if [[ -z "$value" ]]; then
                value="NA"  # If line doesn't exist
            fi
        else
            value="NA"
        fi
        data_row="${data_row},${value}"
    done
    echo "${data_row}" >> ${csv_file}
done

echo "CSV file created: ${csv_file}"
echo "Total columns: $((${#header_list[@]} + 1))"
echo "Total rows: $((max_lines + 1))"
echo "Files processed: ${#file_list[@]}"
