#!/bin/bash 

for i in `cat /home2/data/Projects/workingMemory/mask/subject_list_Num_46sub.txt`; do

3dresample -orient RPI -dxyz 4.0 4.0 4.0 -prefix /home2/data/Projects/workingMemory/data/DPARSF_analysis/Masks/reoriented/${i}_BrainMask_05_91x109x91_RPI.nii -inset /home2/data/Projects/workingMemory/data/DPARSF_analysis/Masks/${i}_BrainMask_05_91x109x91.nii

done


maskGroup='46sub'
subList="/home2/data/Projects/workingMemory/mask/subject_list_Num_${maskGroup}.txt" 
sublistFile="/home2/data/Projects/workingMemory/mask/${maskGroup}_subList_DPARSF.txt"
rm -rf $sublistFile /home2/data/Projects/workingMemory/mask/mean_fun_mask_$maskGroup.nii
for i in `cat $subList`; do
echo "/home2/data/Projects/workingMemory/data/DPARSF_analysis/Masks/reoriented/${i}_BrainMask_05_91x109x91_RPI.nii" >> $sublistFile
done
a=$(cat $sublistFile)
cmd="3dMean -prefix /home2/data/Projects/workingMemory/mask/meanFunMask_DPARSF_${maskGroup}_RPI.nii $a"

echo $cmd
eval $cmd

#fslview /home2/data/Projects/workingMemory/mask/mean_fun_mask_$maskGroup.nii &
