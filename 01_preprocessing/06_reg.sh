# Paths
dir="/data/project/SPAIN/derivatives/squeeze"
sct_dir="/nan/ceph/network/system/el8/sct/6.5"

# List of subjects
declare -a sub=("sub-SPAIN01" "sub-SPAIN02" "sub-SPAIN04" "sub-SPAIN06" "sub-SPAIN07" "sub-SPAIN08" "sub-SPAIN11" "sub-SPAIN13" "sub-SPAIN15" "sub-SPAIN16" "sub-SPAIN19" "sub-SPAIN20" "sub-SPAIN21" "sub-SPAIN24" "sub-SPAIN25" "sub-SPAIN26" "sub-SPAIN27" "sub-SPAIN28" "sub-SPAIN30" "sub-SPAIN31" "sub-SPAIN32" "sub-SPAIN36" "sub-SPAIN38" "sub-SPAIN39" "sub-SPAIN40" "sub-SPAIN41" "sub-SPAIN44" "sub-SPAIN49" "sub-SPAIN52" "sub-SPAIN55")


# Loop over all subjects 
for i in "${sub[@]}"; do
	for j in "ses-A" "ses-B"; do
        for l in "run-1" "run-2"; do
			
			cd ${dir}/derivatives/preprocessing/${i}/${j}/${l}/
			
			func=chop_MCnofilt
            anat=${i}_${j}_T2w

			echo "Processing... " $i $j $l 

            echo "Generating a mask of the cord using the T2w image"
			sct_deepseg_sc -i ${anat}.nii.gz -c t2
			
			echo "Registering T2w data to EPI with disc labels..."
			sct_register_multimodal \
			-i ${anat}.nii.gz \
			-iseg ${anat}_seg.nii.gz \
			-ilabel ${anat}_labels_disc_3_8.nii.gz \
			-d ${func}_tmean.nii.gz \
			-dseg ${func}_tmean_bold_seg.nii.gz \
			-dlabel ${func}_tmean_labels_disc_3_8.nii.gz \
			-param step=0,type=label,dof=Tz:step=1,type=seg,algo=centermass:step=2,type=im,algo=syn,metric=MI,slicewise=1,smooth=0,iter=3

			echo "Transforming T2w cord mask to EPI space"
			sct_apply_transfo \
			-i ${anat}_seg.nii.gz \
			-d ${func}_tmean.nii.gz \
			-w warp_${anat}2${func}_tmean.nii.gz \
			-x nn
			
			echo "Registering T2w image to PAM50 T2w template"
			sct_register_to_template -i ${anat}.nii.gz -s ${anat}_seg.nii.gz -ldisc ${anat}_labels_disc_1_9.nii.gz -c t2

			echo "Creating new warp files"
			sct_concat_transfo \
			-d ${sct_dir}/data/PAM50/template/PAM50_t2s.nii.gz \
			-w warp_${func}_tmean2${anat}.nii.gz warp_anat2template.nii.gz \
			-o warp_${func}_tmean2PAM50.nii.gz

			sct_concat_transfo \
			-d ${func}_tmean.nii.gz \
			-w warp_template2anat.nii.gz warp_${anat}2${func}_tmean.nii.gz \
			-o warp_PAM502${func}_tmean.nii.gz
			
			echo "Registering EPI data to PAM50 cord template via T2w registration warps"
			
			# old version
			#sct_register_multimodal \
			#-i ${sct_dir}/data/PAM50/template/PAM50_t2s.nii.gz \
			#-iseg ${sct_dir}/data/PAM50/template/PAM50_cord.nii.gz \
			#-d ${func}_tmean.nii.gz \
			#-dseg ${anat}_seg_reg.nii.gz \
			#-param step=1,type=seg,algo=centermassrot:step=2,type=seg,algo=bsplinesyn,slicewise=1,iter=3:step=3,type=im,algo=syn,slicewise=1,iter=1,metric=CC \
			#-initwarp warp_PAM502${func}_tmean.nii.gz \
			#-initwarpinv warp_${func}_tmean2PAM50.nii.gz
			
			# new version following latest SCT documentation
			sct_register_multimodal -i ${sct_dir}/data/PAM50/template/PAM50_t2s.nii.gz \
                        -d ${func}_tmean.nii.gz \
                        -dseg ${anat}_seg_reg.nii.gz \
                        -param step=1,type=im,algo=syn,metric=CC,iter=5,slicewise=0 \
                        -initwarp warp_PAM502${func}_tmean.nii.gz \
                        -initwarpinv warp_${func}_tmean2PAM50.nii.gz \
                        -owarp warp_template2fmri.nii.gz \
                        -owarpinv warp_fmri2template.nii.gz 
        done
    done
done
