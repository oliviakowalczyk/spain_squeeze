# Path of the folder containing all data
dir="/root/dir"

# Define conditions and mask types
declare -A analyses=(
    ["standard"]="randomise_first_trial_censored"
    ["paramod"]="randomise_first_trial_censored_paramod"
)
declare -A avgs=(
    ["run-1-avg"]="run-13-avg"
    ["run-2-avg"]="run-24-avg"
    ["ses-A-avg"]="run-12-avg"
    ["ses-B-avg"]="run-34-avg"
)

# Threshold and binarise t-stat images
for paramod in "standard" "paramod"; do
	analysis=${analyses[$paramod]}
	for key in "${!avgs[@]}"; do
		avg=${avgs[$key]}
		echo "Processing ${analysis}_${avg}..."

		# Threshold
		fslmaths ${dir}/derivatives/group_level/${analysis}_${avg}/cope1/one_sampt_tfce_corrp_tstat1.nii.gz \
			-thr 0.95 -bin -mul ${dir}/derivatives/group_level/${analysis}_${avg}/cope1/one_sampt_tstat1.nii.gz \
			${dir}/derivatives/group_level/${analysis}_${avg}/cope1/one_sampt_tstat1_thr_0.05.nii.gz

		# Binarise
		fslmaths ${dir}/derivatives/group_level/${analysis}_${avg}/cope1/one_sampt_tstat1_thr_0.05.nii.gz -bin \
			${dir}/derivatives/group_level/${analysis}_${avg}/cope1/one_sampt_tstat1_thr_0.05_bin.nii.gz
	done
	for key in "${!avgs[@]}"; do
		if [[ $key == "run-1-avg" ]]; then
			avg_2="run-24-avg"
			output="run_avg"
		elif [[ $key == "ses-A-avg" ]]; then
			avg_2="run-34-avg"
			output="ses_avg"
		else 
			continue
		fi
		avg_1=${avgs[$key]}
		
		# Get Dice coefficient
		echo "Running Dice on ${output} with ${avg_1} and ${avg_2} - ${paramod}..."
		
		afni 3ddot -dodice \
			${dir}/derivatives/group_level/${analysis}_${avg_1}/cope1/one_sampt_tstat1_thr_0.05_bin.nii.gz \
			${dir}/derivatives/group_level/${analysis}_${avg_2}/cope1/one_sampt_tstat1_thr_0.05_bin.nii.gz >> \
			${dir}/derivatives/reliability/dice/${output}_${paramod}.txt
	done
done
