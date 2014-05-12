#!/bin/bash 

maskGroup='child'
subList="/home2/data/Projects/workingMemory/mask/subjectList_Num_${maskGroup}.txt" 
sublistFile="/home2/data/Projects/workingMemory/mask/${maskGroup}_maskPath.txt"
rm -rf $sublistFile /home2/data/Projects/workingMemory/mask/meanFunMask_$maskGroup.nii
for i in `cat $subList`; do
echo "/home/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/autoMask_${i}.nii" >> $sublistFile
done
a=$(cat $sublistFile)
cmd="3dMean -prefix /home2/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/meanFunMask_$maskGroup.nii $a"

echo $cmd
eval $cmd

maskGroup='adoles'
subList="/home2/data/Projects/workingMemory/mask/subjectList_Num_${maskGroup}.txt" 
sublistFile="/home2/data/Projects/workingMemory/mask/${maskGroup}_maskPath.txt"
rm -rf $sublistFile /home2/data/Projects/workingMemory/mask/meanFunMask_$maskGroup.nii
for i in `cat $subList`; do
echo "/home/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/autoMask_${i}.nii" >> $sublistFile
done
a=$(cat $sublistFile)
cmd="3dMean -prefix /home2/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/meanFunMask_$maskGroup.nii $a"

echo $cmd
eval $cmd


# threshold the mean func mask at 0.9 and get the overlap with MNI brain mask
3dcalc -a /home2/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/meanFunMask_child.nii -b /home2/data/Projects/workingMemory/mask/MNI152_T1_3mm_brain_mask_dil.nii.gz -expr 'b*step(a-0.89999)' -prefix /home2/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/meanFunMask0.9_child.nii

3dcalc -a /home2/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/meanFunMask_adoles.nii -b /home2/data/Projects/workingMemory/mask/MNI152_T1_3mm_brain_mask_dil.nii.gz -expr 'b*step(a-0.89999)' -prefix /home2/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/meanFunMask0.9_adoles.nii

3dcalc -a /home2/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/meanFunMask0.9_adoles.nii -b /home2/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/meanFunMask0.9_child.nii -expr 'a-b' -prefix /home2/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/meanFunMask0.9_adolesMinusChild.nii

3dcalc -a /home2/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/meanFunMask0.9_adoles.nii -b /home2/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/autoMask_68sub_90percent.nii -expr 'a-b' -prefix /home2/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/meanFunMask0.9_adolesMinus68sub.nii

3dcalc -a /home2/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/meanFunMask0.9_child.nii -b /home2/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/autoMask_68sub_90percent.nii -expr 'a-b' -prefix /home2/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/meanFunMask0.9_childMinus68sub.nii
#fslview /home2/data/Projects/workingMemory/mask/mean_fun_mask_$maskGroup.nii &


maskGroup='68sub'
subList="/home2/data/Projects/workingMemory/mask/subjectList_Num_${maskGroup}.txt" 
sublistFile="/home2/data/Projects/workingMemory/mask/${maskGroup}_filePath.txt"

for i in `cat $subList`; do
echo "/home/data/Projects/workingMemory/data/DPARSFanalysis/noGSR/ResultsWS/fALFF/swfALFFMap_${i}.nii" >> $sublistFile
done
a=$(cat $sublistFile)
cmd="3dMean -prefix /home/data/Projects/workingMemory/data/DPARSFanalysis/noGSR/ResultsWS/fALFF/swfALFFMap_mean.nii $a"

echo $cmd
eval $cmd
rm -rf $sublistFile 



subList="/home2/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt" 
covType=compCor
mkdir /home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/${covType}/DualRegressionMean

for AC in DualRegression0 DualRegression1 DualRegression2 DualRegression3 DualRegression4 DualRegression5; do
sublistFile="/home2/data/Projects/workingMemory/data/${AC}filePath.txt"

for i in `cat $subList`; do
echo "/home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/${covType}/${AC}/${AC}_${i}_MNI_fwhm6.nii" >> $sublistFile
done
a=$(cat $sublistFile)
cmd="3dMean -prefix /home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/${covType}/DualRegressionMean/${AC}_68subMean_MNI_fwhm6.nii $a"

echo $cmd
eval $cmd
rm -rf $sublistFile 
done
