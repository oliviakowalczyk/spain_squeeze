# Path of the folder containing all data
dir="/root/dir"

# Threshold t-stat image with FWE-corr TFCE map
fslmaths ${dir}/derivatives/group_level/randomise_first_trial_censored_run-1-avg/cope1/one_sampt_tfce_corrp_tstat1.nii.gz \
-thr 0.95 -bin -mul ${dir}/derivatives/group_level/randomise_first_trial_censored_run-1-avg/cope1/one_sampt_tstat1.nii.gz \
${dir}/derivatives/group_level/randomise_first_trial_censored_run-1-avg/cope1/one_sampt_tstat1_thr_0.05.nii.gz

# Binarise the thresholded t-stat image
fslmaths ${dir}/derivatives/group_level/randomise_first_trial_censored_run-1-avg/cope1/one_sampt_tstat1_thr_0.05.nii.gz -bin \
${dir}/derivatives/group_level/randomise_first_trial_censored_run-1-avg/cope1/one_sampt_tstat1_thr_0.05_bin.nii.gz

fslmaths ${dir}/derivatives/group_level/randomise_first_trial_censored_ses-A-avg/cope1/one_sampt_tfce_corrp_tstat1.nii.gz \
-thr 0.95 -bin -mul ${dir}/derivatives/group_level/randomise_first_trial_censored_ses-A-avg/cope1/one_sampt_tstat1.nii.gz \
${dir}/derivatives/group_level/randomise_first_trial_censored_ses-A-avg/cope1/one_sampt_tstat1_thr_0.05.nii.gz

fslmaths ${dir}/derivatives/group_level/randomise_first_trial_censored_ses-A-avg/cope1/one_sampt_tstat1_thr_0.05.nii.gz -bin \
${dir}/derivatives/group_level/randomise_first_trial_censored_ses-A-avg/cope1/one_sampt_tstat1_thr_0.05_bin.nii.gz

# Extract mean signal from the mask
fslmeants -i ${dir}/derivatives/group_level/data_stacks/cope1_run-1-avg_first_trial_censored_stack.nii.gz \
-o ${dir}/derivatives/reliability/icc/mean_z/cope1_run-1_network_mean.txt \
-m ${dir}/derivatives/group_level/randomise_first_trial_censored_run-1-avg/cope1/one_sampt_tstat1_thr_0.05_bin.nii.gz

fslmeants -i ${dir}/derivatives/group_level/data_stacks/cope1_run-2-avg_first_trial_censored_stack.nii.gz \
-o ${dir}/derivatives/reliability/icc/mean_z/cope1_run-2_network_mean.txt \
-m ${dir}/derivatives/group_level/randomise_first_trial_censored_run-1-avg/cope1/one_sampt_tstat1_thr_0.05_bin.nii.gz

fslmeants -i ${dir}/derivatives/group_level/data_stacks/cope1_ses-A-avg_first_trial_censored_stack.nii.gz \
-o ${dir}/derivatives/reliability/icc/mean_z/cope1_ses-A_network_mean.txt \
-m ${dir}/derivatives/group_level/randomise_first_trial_censored_ses-A-avg/cope1/one_sampt_tstat1_thr_0.05_bin.nii.gz

fslmeants -i ${dir}/derivatives/group_level/data_stacks/cope1_ses-B-avg_first_trial_censored_stack.nii.gz \
-o ${dir}/derivatives/reliability/icc/mean_z/cope1_ses-B_network_mean.txt \
-m ${dir}/derivatives/group_level/randomise_first_trial_censored_ses-A-avg/cope1/one_sampt_tstat1_thr_0.05_bin.nii.gz

# Extract mean signal from each ROI
for i in "spinal_level_c5" "spinal_level_c6" "spinal_level_c7" "spinal_level_c8" "spinal_level_t1" "cord"; do

	fslmeants -i ${dir}/derivatives/group_level/data_stacks/cope1_run-1-avg_first_trial_censored_stack.nii.gz \
	-o ${dir}/derivatives/reliability/icc/mean_z/cope1_run-1_${i}_mean.txt \
	-m ${dir}/masks/PAM50_${i}.nii.gz
	
	fslmeants -i ${dir}/derivatives/group_level/data_stacks/cope1_run-2-avg_first_trial_censored_stack.nii.gz \
	-o ${dir}/derivatives/reliability/icc/mean_z/cope1_run-2_${i}_mean.txt \
	-m ${dir}/masks/PAM50_${i}.nii.gz
	
	fslmeants -i ${dir}/derivatives/group_level/data_stacks/cope1_ses-A-avg_first_trial_censored_stack.nii.gz \
	-o ${dir}/derivatives/reliability/icc/mean_z/cope1_ses-A_${i}_mean.txt \
	-m ${dir}/masks/PAM50_${i}.nii.gz
	
	fslmeants -i ${dir}/derivatives/group_level/data_stacks/cope1_ses-B-avg_first_trial_censored_stack.nii.gz \
	-o ${dir}/derivatives/reliability/icc/mean_z/cope1_ses-B_${i}_mean.txt \
	-m ${dir}/masks/PAM50_${i}.nii.gz
done
