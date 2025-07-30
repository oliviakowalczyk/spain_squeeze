# Path of the folder containing all data
dir="/data/project/SPAIN/derivatives/squeeze"

# List of subjects
declare -a sub=("sub-SPAIN01" "sub-SPAIN02" "sub-SPAIN04" "sub-SPAIN06" "sub-SPAIN07" "sub-SPAIN08" "sub-SPAIN11" "sub-SPAIN13" "sub-SPAIN15" "sub-SPAIN16" "sub-SPAIN19" "sub-SPAIN20" "sub-SPAIN21" "sub-SPAIN24" "sub-SPAIN25" "sub-SPAIN26" "sub-SPAIN27" "sub-SPAIN28" "sub-SPAIN30" "sub-SPAIN31" "sub-SPAIN32" "sub-SPAIN36" "sub-SPAIN38" "sub-SPAIN39" "sub-SPAIN40" "sub-SPAIN41" "sub-SPAIN44" "sub-SPAIN49" "sub-SPAIN52" "sub-SPAIN55")

cd ${dir}/derivatives/group_level/data_stacks/tmp/

for i in "${sub[@]}"; do
	for j in "1" "2"; do
		
		echo "Processing ${i}_run-${j}"
		
		file=cope1_${i}_run-${j}_first_trial_censored_avg.nii.gz
			
		fslchfiletype ANALYZE ${file} ${dir}/derivatives/reliability/icc/voxelwise/data/run_avg/run-${j}_avg_${i}_cope1_first_trial_censored
	done
	
	for k in "A" "B"; do
		
		echo "Processing ${i}_ses-${k}"
		
		file=cope1_${i}_ses-${k}_first_trial_censored_avg.nii.gz
			
		fslchfiletype ANALYZE ${file} ${dir}/derivatives/reliability/icc/voxelwise/data/ses_avg/ses-${k}_avg_${i}_cope1_first_trial_censored
	done
done
