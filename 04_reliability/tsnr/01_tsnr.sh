# Path of the folder containing all data
dir="/data/project/SPAIN/derivatives/squeeze"
tsnr_dir="${dir}/derivatives/tsnr/"
output_csv="${tsnr_dir}/tsnr.csv"

# List of subjects
declare -a sub=("sub-SPAIN01" "sub-SPAIN02" "sub-SPAIN04" "sub-SPAIN06" "sub-SPAIN07" "sub-SPAIN08" "sub-SPAIN11" "sub-SPAIN13" "sub-SPAIN15" "sub-SPAIN16" "sub-SPAIN19" "sub-SPAIN20" "sub-SPAIN21" "sub-SPAIN24" "sub-SPAIN25" "sub-SPAIN26" "sub-SPAIN27" "sub-SPAIN28" "sub-SPAIN30" "sub-SPAIN31" "sub-SPAIN32" "sub-SPAIN36" "sub-SPAIN38" "sub-SPAIN39" "sub-SPAIN40" "sub-SPAIN41" "sub-SPAIN44" "sub-SPAIN49" "sub-SPAIN52" "sub-SPAIN55")

# Loop over all subjects 
for i in "${sub[@]}"; do
	for j in "ses-A" "ses-B"; do
        for l in "run-1" "run-2"; do
			
			cd ${dir}/derivatives/preprocessing/${i}/${j}/${l}/
			
			func=chop_MCnofilt
			anat=${i}_${j}_T2w
			
			# Check if tsnr file exists before continuing
			if [ -e "${i}_${j}_${l}_tsnr.nii.gz" ]; then
				echo "${i}_${j}_${l}_tsnr.nii.gz already exists, skipping."
			else
			
			echo "Processing: ${i}, ${j}, ${l}"
			
			# Calculate temporal standard deviation
			fslmaths ${func} -Tstd ${func}_tstd
			
			# Calculate tSNR
			fslmaths ${func}_tmean -div ${func}_tstd ${i}_${j}_${l}_tsnr
			tsnr_cord=$(fslstats ${i}_${j}_${l}_tsnr -k ${anat}_seg_reg -M)
			
			# Append results to CSV
			echo "${i},${j},${l},${tsnr_cord}" >> ${output_csv}
			fi
		done
	done
done
