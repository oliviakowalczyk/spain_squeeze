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

# Threshold and binarise t-stat images for FWE coorrection
for paramod in "standard" "paramod"; do
	analysis=${analyses[$paramod]}
	for key in "run-1-avg" "ses-A-avg"; do
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
done

# Threshold and binarise t-stat images for uncorrected results
for paramod in "standard" "paramod"; do
	analysis=${analyses[$paramod]}
	for key in "run-1-avg" "ses-A-avg"; do
		avg=${avgs[$key]}
		echo "Processing ${analysis}_${avg}..."

		fslmaths ${dir}/derivatives/group_level/${analysis}_${avg}/cope1/one_sampt_tstat1.nii.gz -thr 3.5 -bin \
			${dir}/derivatives/group_level/${analysis}_${avg}/cope1/one_sampt_tstat1_thr_uncorr_bin.nii.gz
	done
done

# Extract mean signal from the FWE-corrected mask
for paramod in "standard" "paramod"; do
	analysis=${analyses[$paramod]}
	for key in "${!avgs[@]}"; do
		if [[ $key == "run-1-avg" || $key == "run-2-avg" ]]; then
			mask="run-13-avg"
		else
			mask="run-12-avg"
		fi
		avg=${avgs[$key]}
		if [[ $paramod == "standard" ]]; then
			in_stack="cope1_${avg}_first_trial_censored_stack.nii.gz"
			out_name="cope1_${key}_network_mean.txt"
		else
			in_stack="cope1_${avg}_first_trial_censored_paramod_stack.nii.gz"
			out_name="cope1_${key}_paramod_network_mean.txt"
		fi
		echo "Extracting mean for ${out_name} from ${in_stack} using mask ${mask}..."
        fslmeants -i ${dir}/derivatives/group_level/data_stacks/${in_stack} \
        	-o ${dir}/derivatives/reliability/icc/mean_t/${out_name} \
        	-m ${dir}/derivatives/group_level/${analysis}_${mask}/cope1/one_sampt_tstat1_thr_0.05_bin.nii.gz
    done
done

# Extract mean signal from the uncorrected mask
for paramod in "standard" "paramod"; do
	analysis=${analyses[$paramod]}
	for key in "${!avgs[@]}"; do
		if [[ $key == "run-1-avg" || $key == "run-2-avg" ]]; then
			mask="run-13-avg"
		else
			mask="run-12-avg"
		fi
		avg=${avgs[$key]}
		if [[ $paramod == "standard" ]]; then
			in_stack="cope1_${avg}_first_trial_censored_stack.nii.gz"
			out_name="cope1_${key}_network_uncorr_mean.txt"
		else
			in_stack="cope1_${avg}_first_trial_censored_paramod_stack.nii.gz"
			out_name="cope1_${key}_paramod_network_uncorr_mean.txt"
		fi
		echo "Extracting mean for ${out_name} from ${in_stack} using mask ${mask}..."
        fslmeants -i ${dir}/derivatives/group_level/data_stacks/${in_stack} \
        	-o ${dir}/derivatives/reliability/icc/mean_t/${out_name} \
        	-m ${dir}/derivatives/group_level/${analysis}_${mask}/cope1/one_sampt_tstat1_thr_uncorr_bin.nii.gz
    done
done

# Extract mean signal from each ROI
rois=("spinal_level_c5" "spinal_level_c6" "spinal_level_c7" "spinal_level_c8" "spinal_level_t1" "cord")
for i in "${rois[@]}"; do
    for paramod in "standard" "paramod"; do
        for key in "${!avgs[@]}"; do
            if [[ $paramod == "standard" ]]; then
                in_stack="cope1_${avgs[$key]}_first_trial_censored_stack.nii.gz"
                out_name="cope1_${key}_${i}_mean.txt"
            else
                in_stack="cope1_${avgs[$key]}_first_trial_censored_${paramod}_stack.nii.gz"
                out_name="cope1_${key}_${paramod}_${i}_mean.txt"
            fi
			echo "Extracting mean for ${out_name} from ${in_stack}..."
            fslmeants -i ${dir}/derivatives/group_level/data_stacks/${in_stack} \
            	-o ${dir}/derivatives/reliability/icc/mean_t/${out_name} \
            	-m ${dir}/masks/PAM50_${i}.nii.gz
        done
    done
done
