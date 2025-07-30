# Path of the folder containing all data
dir="/data/project/SPAIN/derivatives/squeeze"
sct_dir="/nan/ceph/network/system/el8/sct/6.5"

# List of subjects
declare -a sub=("sub-SPAIN01" "sub-SPAIN02" "sub-SPAIN04" "sub-SPAIN06" "sub-SPAIN07" "sub-SPAIN08" "sub-SPAIN11" "sub-SPAIN13" "sub-SPAIN15" "sub-SPAIN16" "sub-SPAIN19" "sub-SPAIN20" "sub-SPAIN21" "sub-SPAIN24" "sub-SPAIN25" "sub-SPAIN26" "sub-SPAIN27" "sub-SPAIN28" "sub-SPAIN30" "sub-SPAIN31" "sub-SPAIN32" "sub-SPAIN36" "sub-SPAIN38" "sub-SPAIN39" "sub-SPAIN40" "sub-SPAIN41" "sub-SPAIN44" "sub-SPAIN49" "sub-SPAIN52" "sub-SPAIN55")

# Loop over all subjects 
for i in "${sub[@]}"; do
	for j in "ses-A" "ses-B"; do
        for l in "run-1" "run-2"; do
			
            cd $dir/derivatives/subject_level/${i}_${j}_${l}_first_trial_censored.feat/stats

            echo "Processing " ${i} ${j} ${l}
            for m in "cope1" "cope2"; do

			    sct_apply_transfo -i ${m}.nii.gz -d ${sct_dir}/data/PAM50/template/PAM50_t2s.nii.gz -w ${dir}/derivatives/preprocessing/${i}/${j}/${l}/warp_fmri2template.nii.gz -x linear
			done
        done
    done
done
