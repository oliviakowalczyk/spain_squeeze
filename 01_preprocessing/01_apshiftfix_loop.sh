dir="/root/dir"

declare -a data=("sub-SPAIN01_ses-B_task-squeeze_run-2_bold.nii.gz"
"sub-SPAIN02_ses-A_task-squeeze_run-1_bold.nii.gz"
"sub-SPAIN02_ses-A_task-squeeze_run-2_bold.nii.gz"
"sub-SPAIN02_ses-B_task-squeeze_run-1_bold.nii.gz"
"sub-SPAIN02_ses-B_task-squeeze_run-2_bold.nii.gz"
"sub-SPAIN04_ses-A_task-squeeze_run-1_bold.nii.gz"
"sub-SPAIN04_ses-A_task-squeeze_run-2_bold.nii.gz"
"sub-SPAIN06_ses-B_task-squeeze_run-1_bold.nii.gz"
"sub-SPAIN08_ses-A_task-squeeze_run-1_bold.nii.gz"
"sub-SPAIN08_ses-B_task-squeeze_run-1_bold.nii.gz"
"sub-SPAIN08_ses-B_task-squeeze_run-2_bold.nii.gz"
"sub-SPAIN11_ses-B_task-squeeze_run-1_bold.nii.gz"
"sub-SPAIN13_ses-A_task-squeeze_run-1_bold.nii.gz"
"sub-SPAIN13_ses-A_task-squeeze_run-2_bold.nii.gz"
"sub-SPAIN13_ses-B_task-squeeze_run-1_bold.nii.gz"
"sub-SPAIN20_ses-A_task-squeeze_run-1_bold.nii.gz"
"sub-SPAIN26_ses-B_task-squeeze_run-1_bold.nii.gz"
"sub-SPAIN26_ses-B_task-squeeze_run-2_bold.nii.gz"
"sub-SPAIN30_ses-A_task-squeeze_run-2_bold.nii.gz"
"sub-SPAIN30_ses-B_task-squeeze_run-1_bold.nii.gz")

for i in "${data[@]}"; do

    sub=$(echo "$i" | cut -d'_' -f1)
    ses=$(echo "$i" | cut -d'_' -f2)
    run=$(echo "$i" | cut -d'_' -f4)
    
    echo "Processing " $sub $ses $run

    cd ${dir}/derivatives/preprocessing/${sub}/${ses}/${run}

    matlab -nodesktop -nodisplay -nosplash -r "addpath('/data/project/SPAIN/derivatives/squeeze/code');apshiftfix('"$i"');exit;" # add path to a folder containing apshiftfix function, execute apshiftfix, and quit matlab
done
