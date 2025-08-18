# Path of the folder containing all data
dir="/root/dir"

# List of subjects
declare -a sub=("sub-SPAIN01" "sub-SPAIN02" "sub-SPAIN04" "sub-SPAIN06" "sub-SPAIN07" "sub-SPAIN08" "sub-SPAIN11" "sub-SPAIN13" "sub-SPAIN15" "sub-SPAIN16" "sub-SPAIN19" "sub-SPAIN20" "sub-SPAIN21" "sub-SPAIN24" "sub-SPAIN25" "sub-SPAIN26" "sub-SPAIN27" "sub-SPAIN28" "sub-SPAIN30" "sub-SPAIN31" "sub-SPAIN32" "sub-SPAIN36" "sub-SPAIN38" "sub-SPAIN39" "sub-SPAIN40" "sub-SPAIN41" "sub-SPAIN44" "sub-SPAIN49" "sub-SPAIN52" "sub-SPAIN55")

# Loop over all subjects 
for i in "${sub[@]}"; do
	for j in "ses-A" "ses-B"; do
        for l in "run-1" "run-2"; do
			
            echo "Processing " ${i} ${j} ${l}

			x_param=${dir}/derivatives/preprocessing/${i}/${j}/${l}/chop_MCnofilt_x_params.nii.gz
            y_param=${dir}/derivatives/preprocessing/${i}/${j}/${l}/chop_MCnofilt_y_params.nii.gz
            
            cd ${dir}/derivatives/phys/${i}/${j}/${l}/

            cp pnm_evlist.txt pnm_evlist_mc.txt

            echo "${x_param}" >> pnm_evlist_mc.txt #append x_param directories at the end of ev_list_moco file
            echo "${y_param}" >> pnm_evlist_mc.txt #append y_param directories at the end of ev_list_moco file

        done
    done
done
