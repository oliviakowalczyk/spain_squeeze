# Path of the folder containing all data
dir="/data/project/SPAIN/derivatives/squeeze"

# List of subjects
declare -a sub=("sub-SPAIN01" "sub-SPAIN02" "sub-SPAIN04" "sub-SPAIN06" "sub-SPAIN07" "sub-SPAIN08" "sub-SPAIN11" "sub-SPAIN13" "sub-SPAIN15" "sub-SPAIN16" "sub-SPAIN19" "sub-SPAIN20" "sub-SPAIN21" "sub-SPAIN24" "sub-SPAIN25" "sub-SPAIN26" "sub-SPAIN27" "sub-SPAIN28" "sub-SPAIN30" "sub-SPAIN31" "sub-SPAIN32" "sub-SPAIN36" "sub-SPAIN38" "sub-SPAIN39" "sub-SPAIN40" "sub-SPAIN41" "sub-SPAIN44" "sub-SPAIN49" "sub-SPAIN52" "sub-SPAIN55")

# Loop over all subjects 
for i in "${sub[@]}"; do
	for j in "ses-A" "ses-B"; do
        for l in "run-1" "run-2"; do
			
			cd ${dir}/derivatives/preprocessing/${i}/${j}/${l}/
			
			data=chop

			echo $data

			fslmaths ${data} -Tmean ${data}_tmean
			sct_get_centerline -i ${data}_tmean.nii.gz -c t2s
			sct_create_mask -i ${data}_tmean.nii.gz -p centerline,${data}_tmean_centerline.nii.gz -size 10 -f gaussian -o ${data}_tmean_mask_gaussian.nii.gz 

			${dir}/code/03_neptune_moco.sh ${data} ${data}_tmean ${data}_tmean_mask_gaussian
		done
	done
done
