# Path of the folder containing all data
dir="/root/dir"
sct_dir="/sct/dir/6.5"

for file in `ls ${dir}/derivatives/group_level/data_stacks/cope*stack.nii.gz`; do
    # Extract the filename without path
    filename=$(basename "$file")
    
    echo "Processing ${filename}"

    # Extract the first and second field (after splitting by '_')
    first_field=$(echo "$filename" | cut -d'_' -f1)
    second_field=$(echo "$filename" | cut -d'_' -f2)

	echo ${first_field} ${second_field}
	
	# Run whole cord randomise  
	randomise_parallel -i ${file} -o ${dir}/derivatives/group_level/randomise_first_trial_censored_${second_field}/${first_field}/one_sampt -1 -T -m ${sct_dir}/data/PAM50/template/PAM50_cord.nii.gz
	
	# Run ROI randomise
	for mask in "c5" "c6" "c7" "c8" "t1"; do
		randomise_parallel -i ${file} -o ${dir}/derivatives/group_level/randomise_first_trial_censored_${second_field}/${first_field}/one_sampt_${mask} -1 -T -m ${dir}/masks/PAM50_spinal_level_${mask}.nii.gz
	done
done
