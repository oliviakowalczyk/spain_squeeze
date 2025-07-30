# Path of the folder containing all data
dir="/data/project/SPAIN/derivatives/squeeze"

# List of cervical spine images
declare -a sub=("sub-SPAIN01" "sub-SPAIN02" "sub-SPAIN04" "sub-SPAIN06" "sub-SPAIN07" "sub-SPAIN08" "sub-SPAIN11" "sub-SPAIN13" "sub-SPAIN15" "sub-SPAIN16" "sub-SPAIN19" "sub-SPAIN20" "sub-SPAIN21" "sub-SPAIN24" "sub-SPAIN25" "sub-SPAIN26" "sub-SPAIN27" "sub-SPAIN28" "sub-SPAIN30" "sub-SPAIN31" "sub-SPAIN32" "sub-SPAIN36" "sub-SPAIN38" "sub-SPAIN39" "sub-SPAIN40" "sub-SPAIN41" "sub-SPAIN44" "sub-SPAIN49" "sub-SPAIN52" "sub-SPAIN55")

# Loop over all subjects 
for i in "${sub[@]}"; do

    mkdir ${dir}/derivatives/preprocessing/${i}

	for j in "ses-A" "ses-B"; do

        mkdir ${dir}/derivatives/preprocessing/${i}/${j}

        for l in "run-1" "run-2"; do

            mkdir ${dir}/derivatives/preprocessing/${i}/${j}/${l}
            cp ${dir}/data/${i}/${j}/func/${i}_${j}_task-squeeze_${l}_bold.nii.gz ${dir}/derivatives/preprocessing/${i}/${j}/${l}
            
            cp ${dir}/data/${i}/${j}/anat/${i}_${j}_T2w.nii.gz ${dir}/derivatives/preprocessing/${i}/${j}/${l}

        done
    done
done
