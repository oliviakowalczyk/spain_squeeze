# Path of the folder containing all data
dir="/root/dir"

# List of subjects
declare -a sub=("sub-SPAIN01" "sub-SPAIN02" "sub-SPAIN04" "sub-SPAIN06" "sub-SPAIN07" "sub-SPAIN08" "sub-SPAIN11" "sub-SPAIN13" "sub-SPAIN15" "sub-SPAIN16" "sub-SPAIN19" "sub-SPAIN20" "sub-SPAIN21" "sub-SPAIN24" "sub-SPAIN25" "sub-SPAIN26" "sub-SPAIN27" "sub-SPAIN28" "sub-SPAIN30" "sub-SPAIN31" "sub-SPAIN32" "sub-SPAIN36" "sub-SPAIN38" "sub-SPAIN39" "sub-SPAIN40" "sub-SPAIN41" "sub-SPAIN44" "sub-SPAIN49" "sub-SPAIN52" "sub-SPAIN55")

# Loop over all subjects 
for i in "${sub[@]}"; do
	for j in "ses-A" "ses-B"; do
        for l in "run-1" "run-2"; do
			
			cd ${dir}/derivatives/preprocessing/${i}/${j}/${l}/
			
			data=chop_MCnofilt_tmean_bold_seg

			echo $i $j $l 

			sct_maths -i ${data}.nii.gz -dilate 3 -o ${data}_dil3.nii.gz
			sct_maths -i ${data}.nii.gz -dilate 1 -o ${data}_dil1.nii.gz
			sct_maths -i ${data}_dil3.nii.gz -sub ${data}_dil1.nii.gz -o csf.nii.gz

			rm ${data}_dil3.nii.gz ${data}_dil1.nii.gz

        done
    done
done    
