# Path of the folder containing all data
dir="/root/dir"

# List of subjects
declare -a sub=("sub-SPAIN01" "sub-SPAIN02" "sub-SPAIN04" "sub-SPAIN06" "sub-SPAIN07" "sub-SPAIN08" "sub-SPAIN11" "sub-SPAIN13" "sub-SPAIN15" "sub-SPAIN16" "sub-SPAIN19" "sub-SPAIN20" "sub-SPAIN21" "sub-SPAIN24" "sub-SPAIN25" "sub-SPAIN26" "sub-SPAIN27" "sub-SPAIN28" "sub-SPAIN30" "sub-SPAIN31" "sub-SPAIN32" "sub-SPAIN36" "sub-SPAIN38" "sub-SPAIN39" "sub-SPAIN40" "sub-SPAIN41" "sub-SPAIN44" "sub-SPAIN49" "sub-SPAIN52" "sub-SPAIN55")

for cope in "cope1" "cope2"; do
    # Create a mean of all task runs/three task runs for each subject
    for i in "${sub[@]}"; do

        echo "Processing " ${i}
		
		# Stack COPEs from all task runs for each subject
        fslmerge -t ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_first_trial_censored_stack \
        ${dir}/derivatives/subject_level/${i}_ses-A_run-1_first_trial_censored.feat/stats/${cope}_reg.nii.gz \
        ${dir}/derivatives/subject_level/${i}_ses-A_run-2_first_trial_censored.feat/stats/${cope}_reg.nii.gz \
        ${dir}/derivatives/subject_level/${i}_ses-B_run-1_first_trial_censored.feat/stats/${cope}_reg.nii.gz \
        ${dir}/derivatives/subject_level/${i}_ses-B_run-2_first_trial_censored.feat/stats/${cope}_reg.nii.gz

		# Average the stacked COPEs
        fslmaths ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_first_trial_censored_stack -Tmean ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_run-1234_first_trial_censored_avg

		# Stack COPEs from three task runs
        fslmerge -t ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_first_trial_censored_stack \
        ${dir}/derivatives/subject_level/${i}_ses-A_run-1_first_trial_censored.feat/stats/${cope}_reg.nii.gz \
        ${dir}/derivatives/subject_level/${i}_ses-A_run-2_first_trial_censored.feat/stats/${cope}_reg.nii.gz \
        ${dir}/derivatives/subject_level/${i}_ses-B_run-1_first_trial_censored.feat/stats/${cope}_reg.nii.gz 

		# Average the stacked COPEs
        fslmaths ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_first_trial_censored_stack -Tmean ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_run-123_first_trial_censored_avg
        
        # Stack COPEs from three task runs
        fslmerge -t ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_first_trial_censored_stack \
        ${dir}/derivatives/subject_level/${i}_ses-A_run-1_first_trial_censored.feat/stats/${cope}_reg.nii.gz \
        ${dir}/derivatives/subject_level/${i}_ses-A_run-2_first_trial_censored.feat/stats/${cope}_reg.nii.gz \
        ${dir}/derivatives/subject_level/${i}_ses-B_run-2_first_trial_censored.feat/stats/${cope}_reg.nii.gz 

		# Average the stacked COPEs
        fslmaths ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_first_trial_censored_stack -Tmean ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_run-124_first_trial_censored_avg
    
		# Stack COPEs from three task runs
        fslmerge -t ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_first_trial_censored_stack \
        ${dir}/derivatives/subject_level/${i}_ses-A_run-2_first_trial_censored.feat/stats/${cope}_reg.nii.gz \
        ${dir}/derivatives/subject_level/${i}_ses-B_run-1_first_trial_censored.feat/stats/${cope}_reg.nii.gz \
        ${dir}/derivatives/subject_level/${i}_ses-B_run-2_first_trial_censored.feat/stats/${cope}_reg.nii.gz 

		# Average the stacked COPEs
        fslmaths ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_first_trial_censored_stack -Tmean ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_run-234_first_trial_censored_avg
    
		# Stack COPEs from three task runs
        fslmerge -t ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_first_trial_censored_stack \
        ${dir}/derivatives/subject_level/${i}_ses-A_run-1_first_trial_censored.feat/stats/${cope}_reg.nii.gz \
        ${dir}/derivatives/subject_level/${i}_ses-B_run-1_first_trial_censored.feat/stats/${cope}_reg.nii.gz \
        ${dir}/derivatives/subject_level/${i}_ses-B_run-2_first_trial_censored.feat/stats/${cope}_reg.nii.gz 

		# Average the stacked COPEs
        fslmaths ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_first_trial_censored_stack -Tmean ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_run-134_first_trial_censored_avg
    
		# Stack COPEs from ses-A run-1 and ses-B run-2
        fslmerge -t ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_first_trial_censored_stack \
        ${dir}/derivatives/subject_level/${i}_ses-A_run-1_first_trial_censored.feat/stats/${cope}_reg.nii.gz \
        ${dir}/derivatives/subject_level/${i}_ses-B_run-2_first_trial_censored.feat/stats/${cope}_reg.nii.gz 

		# Average the stacked COPEs
        fslmaths ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_first_trial_censored_stack -Tmean ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_run-14_first_trial_censored_avg

		# Stack COPEs from ses-A run-2 and ses-B run-1
        fslmerge -t ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_first_trial_censored_stack \
        ${dir}/derivatives/subject_level/${i}_ses-A_run-2_first_trial_censored.feat/stats/${cope}_reg.nii.gz \
        ${dir}/derivatives/subject_level/${i}_ses-B_run-1_first_trial_censored.feat/stats/${cope}_reg.nii.gz 

		# Average the stacked COPEs
        fslmaths ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_first_trial_censored_stack -Tmean ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_run-23_first_trial_censored_avg

    done
    
    # Create a mean of task runs within a session for each subject
    for j in "A" "B"; do 
		for i in "${sub[@]}"; do

			echo "Processing " ${i}
			
			# Stack COPEs from all task runs for each subject
			fslmerge -t ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_ses-${j}_first_trial_censored_stack \
			${dir}/derivatives/subject_level/${i}_ses-${j}_run-1_first_trial_censored.feat/stats/${cope}_reg.nii.gz \
			${dir}/derivatives/subject_level/${i}_ses-${j}_run-2_first_trial_censored.feat/stats/${cope}_reg.nii.gz 

			# Average the stacked COPEs
			fslmaths ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_ses-${j}_first_trial_censored_stack -Tmean ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_ses-${j}_first_trial_censored_avg
		done
	done
	
	# Create a mean of task runs between sessions for each subject
	for k in "1" "2"; do
		for i in "${sub[@]}"; do

			echo "Processing " ${i}

			# Stack COPEs from all task runs for each subject
			fslmerge -t ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_run-${k}_first_trial_censored_stack \
			${dir}/derivatives/subject_level/${i}_ses-A_run-${k}_first_trial_censored.feat/stats/${cope}_reg.nii.gz \
			${dir}/derivatives/subject_level/${i}_ses-B_run-${k}_first_trial_censored.feat/stats/${cope}_reg.nii.gz 

			# Average the stacked COPEs
			fslmaths ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_run-${k}_first_trial_censored_stack -Tmean ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_${i}_run-${k}_first_trial_censored_avg
		done
	done

	# Create subject stacks for randomise input - 4D files with sub being the fourth dimension
    echo "Stacking all subjects/sessions"
    list_run_1234_avg=$(ls ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_sub-SPAIN??_run-1234_first_trial_censored_avg.nii.gz)
    fslmerge -t ${dir}/derivatives/group_level/data_stacks/${cope}_run-1234-avg_first_trial_censored_stack ${list_run_1234_avg}
    
    echo "Stacking ses-A_run-1, ses-A_run-2, ses-B_run-1"
    list_run_123_avg=$(ls ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_sub-SPAIN??_run-123_first_trial_censored_avg.nii.gz)
    fslmerge -t ${dir}/derivatives/group_level/data_stacks/${cope}_run-123-avg_first_trial_censored_stack ${list_run_123_avg}

    echo "Stacking ses-A_run-1, ses-A_run-2, ses-B_run-2"
    list_run_124_avg=$(ls ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_sub-SPAIN??_run-124_first_trial_censored_avg.nii.gz)
    fslmerge -t ${dir}/derivatives/group_level/data_stacks/${cope}_run-124-avg_first_trial_censored_stack ${list_run_124_avg}
    
    echo "Stacking ses-A_run-2, ses-B_run-1, ses-B_run-2"
    list_run_234_avg=$(ls ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_sub-SPAIN??_run-234_first_trial_censored_avg.nii.gz)
    fslmerge -t ${dir}/derivatives/group_level/data_stacks/${cope}_run-234-avg_first_trial_censored_stack ${list_run_234_avg}
    
    echo "Stacking ses-A_run-1, ses-B_run-1, ses-B_run-2"
    list_run_134_avg=$(ls ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_sub-SPAIN??_run-134_first_trial_censored_avg.nii.gz)
    fslmerge -t ${dir}/derivatives/group_level/data_stacks/${cope}_run-134-avg_first_trial_censored_stack ${list_run_134_avg}

	echo "Stacking all runs in ses-A"
    list_run_12=$(ls ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_sub-SPAIN??_ses-A_first_trial_censored_avg.nii.gz)
    fslmerge -t ${dir}/derivatives/group_level/data_stacks/${cope}_run-12-avg_first_trial_censored_stack ${list_run_12}
    
    echo "Stacking all runs in ses-B"
    list_run_34=$(ls ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_sub-SPAIN??_ses-B_first_trial_censored_avg.nii.gz)
    fslmerge -t ${dir}/derivatives/group_level/data_stacks/${cope}_run-34-avg_first_trial_censored_stack ${list_run_34}

	echo "Stacking all first runs in a session"
    list_run_13=$(ls ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_sub-SPAIN??_run-1_first_trial_censored_avg.nii.gz)
    fslmerge -t ${dir}/derivatives/group_level/data_stacks/${cope}_run-13-avg_first_trial_censored_stack ${list_run_13}
    
    echo "Stacking all second runs in a session"
    list_run_24=$(ls ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_sub-SPAIN??_run-2_first_trial_censored_avg.nii.gz)
    fslmerge -t ${dir}/derivatives/group_level/data_stacks/${cope}_run-24-avg_first_trial_censored_stack ${list_run_24}
    
    echo "Stacking ses-A run-1 and ses-B run-2"
    list_run_14=$(ls ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_sub-SPAIN??_run-14_first_trial_censored_avg.nii.gz)
    fslmerge -t ${dir}/derivatives/group_level/data_stacks/${cope}_run-14-avg_first_trial_censored_stack ${list_run_14}
    
    echo "Stacking ses-A run-2 and ses-A run-1"
    list_run_23=$(ls ${dir}/derivatives/group_level/data_stacks/tmp/${cope}_sub-SPAIN??_run-23_first_trial_censored_avg.nii.gz)
    fslmerge -t ${dir}/derivatives/group_level/data_stacks/${cope}_run-23-avg_first_trial_censored_stack ${list_run_23}    

    echo "Stacking ses-A run-1"
    list_ses_A_run_1=$(ls ${dir}/derivatives/subject_level/sub-SPAIN??_ses-A_run-1_first_trial_censored.feat/stats/${cope}_reg.nii.gz)
    fslmerge -t ${dir}/derivatives/group_level/data_stacks/${cope}_ses-A-run-1_first_trial_censored_stack ${list_ses_A_run_1}

    echo "Stacking ses-A run-2"
    list_ses_A_run_2=$(ls ${dir}/derivatives/subject_level/sub-SPAIN??_ses-A_run-2_first_trial_censored.feat/stats/${cope}_reg.nii.gz)
    fslmerge -t ${dir}/derivatives/group_level/data_stacks/${cope}_ses-A-run-2_first_trial_censored_stack ${list_ses_A_run_2}

    echo "Stacking ses-B run-1"
    list_ses_B_run_1=$(ls ${dir}/derivatives/subject_level/sub-SPAIN??_ses-B_run-1_first_trial_censored.feat/stats/${cope}_reg.nii.gz)
    fslmerge -t ${dir}/derivatives/group_level/data_stacks/${cope}_ses-B-run-1_first_trial_censored_stack ${list_ses_B_run_1}

    echo "Stacking ses-B run-2"
    list_ses_B_run_2=$(ls ${dir}/derivatives/subject_level/sub-SPAIN??_ses-B_run-2_first_trial_censored.feat/stats/${cope}_reg.nii.gz)
    fslmerge -t ${dir}/derivatives/group_level/data_stacks/${cope}_ses-B-run-2_first_trial_censored_stack ${list_ses_B_run_2}
done
