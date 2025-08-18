#!/bin/bash

if [ $# != 2 ] ; then
	echo "Usage :" $(basename $0)" <smooth x(mm)> <smooth y(mm)>"
	echo "Hardcoded to work with SPAIN resting state data"
	echo "Needs FSL and AFNI modules loaded"
	exit 1
fi

# Paths
dir="/root/dir"
code_dir="/${dir}/code"

echo "Starting..."


declare -a sub=("sub-SPAIN01" "sub-SPAIN02" "sub-SPAIN04" "sub-SPAIN06" "sub-SPAIN07" "sub-SPAIN08" "sub-SPAIN11" "sub-SPAIN13" "sub-SPAIN15" "sub-SPAIN16" "sub-SPAIN19" "sub-SPAIN20" "sub-SPAIN21" "sub-SPAIN24" "sub-SPAIN25" "sub-SPAIN26" "sub-SPAIN27" "sub-SPAIN28" "sub-SPAIN30" "sub-SPAIN31" "sub-SPAIN32" "sub-SPAIN36" "sub-SPAIN38" "sub-SPAIN39" "sub-SPAIN40" "sub-SPAIN41" "sub-SPAIN44" "sub-SPAIN49" "sub-SPAIN52" "sub-SPAIN55")

for i in "${sub[@]}" ; do
	for j in "ses-A" "ses-B"; do
        for l in "run-1" "run-2"; do

			echo "Processing ${i} ${j} ${l}"
	
			cd ${dir}/derivatives/preprocessing/${i}/${j}/${l}

			data="chop_MCnofilt.nii.gz"
	
			echo "Current file: ${data}"
			
			if [ -d mkgauss2Dtmp ] ; then
				echo "Deleting existing mkgauss2dtmp directory"
				\rm -rf mkgauss2Dtmp
			fi
			echo "Creating mkgauss2dtmp directory"
			mkdir mkgauss2Dtmp
			
			fname=$(basename $data .nii.gz)
			echo "Running fslsplit on ${data}"
			$FSLDIR/bin/fslsplit $data mkgauss2Dtmp/vol -t
			
			( cd mkgauss2Dtmp
			for vol in $(pwd)/vol????.nii.gz ; do
				echo "Running mkgauss2d.sh on ${vol}"
				${code_dir}/mkgauss2D.sh $vol $1 $2
			done
			)

			echo "Running fslmerge on ${fname}"
			${FSLDIR}/bin/fslmerge -t ${fname}_smooth22 mkgauss2Dtmp/vol????_smoothed22.nii.gz
		
			echo "Deleting mkgauss2dtmp directory on clean up"
			\rm -rf mkgauss2Dtmp
		done
	done
done
