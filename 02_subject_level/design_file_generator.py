#!/usr/bin/python

# This script will generate each subjects design.fsf
# To run it: python design_file_generator 
# Adapted from Jeanette Mumford's script at https://mumfordbrainstats.tumblr.com/post/137507143321/get-some-data-and-get-ready-to-learn-fsl

import os
import glob

# directory where your study lices
dir = "/root/dir"

# path to where the sub-SPAIN## directories live
study_dir = os.path.join(root_dir, "derivatives/preprocessing/")

# path to where all fsf files will live
fsf_dir = os.path.join(root_dir, "code/02_subject_level/design_files/")

# get paths to your data folders
sub_dirs = glob.glob("%s/sub-SPAIN[0-9][0-9]/ses-[A,B]/run-[1,2]"%(study_dir))

for dir in list(sub_dirs):
  split_dir = dir.split('/') # split path string at each '/'
  sub_no = split_dir[8] # take the string at 7th index
  print(sub_no)
  ses_no = split_dir[9]
  print(ses_no)
  run_no = split_dir[10]
  print(run_no)
  
  # replace the variables in your template design.fsf with the ones generated above
  replacements = {'sub_no':sub_no, 'ses_no':ses_no, 'run_no':run_no, 'dir':dir}
  with open("%s/design_template.fsf"%(fsf_dir)) as infile: 
    with open("%s/design_%s_%s_%s.fsf"%(fsf_dir, sub_no, ses_no, run_no), 'w') as outfile:
        for line in infile:
          for src, target in replacements.items():
            line = line.replace(src, target)
          outfile.write(line)
