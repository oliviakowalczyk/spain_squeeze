# Paths
dir="/data/project/SPAIN/derivatives/squeeze/derivatives/phys"

# List of subjects
declare -a sub=("sub-SPAIN01" "sub-SPAIN02" "sub-SPAIN04" "sub-SPAIN06" "sub-SPAIN07" "sub-SPAIN08" "sub-SPAIN11" "sub-SPAIN13" "sub-SPAIN15" "sub-SPAIN16" "sub-SPAIN19" "sub-SPAIN20" "sub-SPAIN21" "sub-SPAIN24" "sub-SPAIN25" "sub-SPAIN26" "sub-SPAIN27" "sub-SPAIN28" "sub-SPAIN30" "sub-SPAIN31" "sub-SPAIN32" "sub-SPAIN36" "sub-SPAIN38" "sub-SPAIN39" "sub-SPAIN40" "sub-SPAIN41" "sub-SPAIN44" "sub-SPAIN49" "sub-SPAIN52" "sub-SPAIN55")

# Loop over all subjects 
for i in "${sub[@]}"; do
	for j in "ses-A" "ses-B"; do
        for l in "run-1" "run-2"; do

        cd $dir/$i/$j/$l

        echo "Processing..." $i $j $l 

        raw_phys=$(ls *_Raw*.txt | head -n 1)
        triggers=$(ls triggers_*.txt | head -n 1)

        echo $raw_phys
        echo $triggers

        matlab -nodesktop -nodisplay -nosplash -r "addpath('/data/project/SPAIN/derivatives/squeeze/code');phys_merge('$raw_phys','$triggers','phys.txt');exit;" # add path to a folder containing phys_merge function, execute phys_merge, and quit matlab

        done
    done
done

