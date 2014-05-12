#!/bin/bash 

maskGroup='child'
subList="/home2/data/Projects/workingMemory/mask/subjectList_Num_${maskGroup}.txt" 
sublistFile="/home2/data/Projects/workingMemory/mask/${maskGroup}_maskPath.txt"
rm -rf $sublistFile /home2/data/Projects/workingMemory/mask/meanFunMask_$maskGroup.nii
for i in `cat $subList`; do
echo "/home2/data/Projects/workingMemory/results/CPAC_analysis/output/sym_links/pipeline_HackettCity/linear1.wm1.global1.motion1.quadratic1.csf1_CSF_0.98_GM_0.7_WM_0.96/sub$i/scan_rest_1_rest/func/functional_brain_mask_to_standard.nii.gz" >> $sublistFile
done
a=$(cat $sublistFile)
cmd="3dMean -prefix /home2/data/Projects/workingMemory/mask/meanFunMask_$maskGroup.nii $a"

echo $cmd
eval $cmd

maskGroup='adoles'
subList="/home2/data/Projects/workingMemory/mask/subjectList_Num_${maskGroup}.txt" 
sublistFile="/home2/data/Projects/workingMemory/mask/${maskGroup}_maskPath.txt"
rm -rf $sublistFile /home2/data/Projects/workingMemory/mask/meanFunMask_$maskGroup.nii
for i in `cat $subList`; do
echo "/home/data/Projects/workingMemory/mask/otherMetrics_mask_68sub_noGSR/stdMask_fullBrain_${i}.nii.gz" >> $sublistFile
done
a=$(cat $sublistFile)
cmd="3dMean -prefix /home2/data/Projects/workingMemory/mask/otherMetrics_mask_68sub_noGSR/meanFunMask_$maskGroup.nii $a"

echo $cmd
eval $cmd


# threshold the mean func mask at 0.9 and get the overlap with MNI brain mask
3dcalc -a /home2/data/Projects/workingMemory/mask/otherMetrics_mask_68sub_noGSR/meanFunMask_$maskGroup.nii -b /home2/data/Projects/workingMemory/mask/MNI152_T1_3mm_brain_mask_dil.nii.gz -expr 'b*step(a-0.89999)' -prefix /home2/data/Projects/workingMemory/mask/otherMetrics_mask_68sub_noGSR/meanFunMask0.9_$maskGroup.nii

# resample the mask to 4mm resolution
3dresample -dxyz 4.0 4.0 4.0 -prefix /home2/data/Projects/workingMemory/mask/meanFunMask0.9_46sub_4mm.nii -inset /home2/data/Projects/workingMemory/mask/meanFunMask0.9_46sub.nii

# compute the overlap with the MNI GreyMatter mask thresholded at 0.25
3dcalc -a /home2/data/Projects/workingMemory/mask/meanFunMask0.9_46sub_4mm.nii -b /home2/data/Projects/workingMemory/mask/MNI152_T1_GREY_4mm_25pc_mask.nii.gz -expr 'step(a)*b' -prefix /home2/data/Projects/workingMemory/mask/meanFunMask0.9_46sub_4mm_MNIGrey0.25.nii


#3dcalc -a /home2/data/Projects/workingMemory/mask/mean_fun_mask_72sub.nii -b /home2/data/Projects/workingMemory/mask/DPARSF_AllResampled_BrainMask_05_91x109x91.nii -expr 'b*equals(a,1)' -prefix /home2/data/Projects/workingMemory/mask/commonCPAC100pctAndDparsf

#fslview /home2/data/Projects/workingMemory/mask/mean_fun_mask_$maskGroup.nii &
