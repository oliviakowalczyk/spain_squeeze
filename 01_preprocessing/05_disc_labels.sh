# Path of the folder containing all data
dir="/root/dir"

# List of subjects
declare -a sub=("sub-SPAIN01" "sub-SPAIN02" "sub-SPAIN04" "sub-SPAIN06" "sub-SPAIN07" "sub-SPAIN08" "sub-SPAIN11" "sub-SPAIN13" "sub-SPAIN15" "sub-SPAIN16" "sub-SPAIN19" "sub-SPAIN20" "sub-SPAIN21" "sub-SPAIN24" "sub-SPAIN25" "sub-SPAIN26" "sub-SPAIN27" "sub-SPAIN28" "sub-SPAIN30" "sub-SPAIN31" "sub-SPAIN32" "sub-SPAIN36" "sub-SPAIN38" "sub-SPAIN39" "sub-SPAIN40" "sub-SPAIN41" "sub-SPAIN44" "sub-SPAIN49" "sub-SPAIN52" "sub-SPAIN55")

# Loop over all subjects 
for i in "${sub[@]}"; do
	for j in "ses-A" "ses-B"; do
        for l in "run-1" "run-2"; do
			
			cd ${dir}/derivatives/preprocessing/${i}/${j}/${l}/
			
			func=chop_MCnofilt
            anat=${i}_${j}_T2w

			echo $i $j $l 

            echo "Label discs 3-8 on functional data"
            sct_label_utils -i ${func}_tmean.nii.gz -create-viewer 3:8 -o {func}_tmean_labels_disc_3_8.nii.gz

		    echo "Label discs 3-8 on T2w "
		    sct_label_utils -i ${anat}.nii.gz -create-viewer 3:8 -o ${anat}_labels_disc_3_8.nii.gz

		    echo "Label discs 1-9 on T2w"
		    sct_label_utils -i ${anat}.nii.gz -create-viewer 1:9 -o ${anat}_labels_disc_1_9.nii.gz

        done
    done
done
