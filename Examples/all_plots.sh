#!/bin/bash
#
# Script to run target and Taylor diagram example scripts, moving
# the resulting *.png files to *_example.png
#
# Peter Rochford
# Symplectic, LLC
# January 16, 2018

# List of Matlab scripts to run
list1="target1 target2 target3 target4 target5 target6 target7"
list2="taylor1 taylor2 taylor3 taylor4 taylor5 taylor6 taylor7 taylor8 taylor9 taylor10 taylor11"
list="$list1 $list2"

## Custom list specification
#list="taylor1 taylor2"

# Location of Matlab executable
matlab=/Applications/MATLAB_R2018b.app/bin/matlab

# Generate Matlab command list
files=""
for script in $list
do
  files="$script; $files"
done
files="$files exit;"

# Turn on expansion of variables
set -x

# Run Matlab script
$matlab -nodisplay nosplash -nodesktop -r "$files"

# Move new files to *_example.png
for script in $list
do
  mv $script.png ${script}_example.png
done

# Turn off expansion of variables
set +x
