#!/bin/bash 

maskGroup='68sub'
subList="/home2/data/Projects/workingMemory/mask/subjectList_Num_${maskGroup}.txt" 
filePath="/home2/data/Projects/workingMemory/mask/${maskGroup}_DualRegressionFilePath.txt"
rm -rf $sublistFile /home2/data/Projects/workingMemory/mask/meanFunMask_$maskGroup.nii
for i in `cat $subList`; do
echo "/home/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/autoMask_${i}.nii" >> $filePath
done
a=$(cat $filePath)
cmd="3dMean -prefix /home2/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/meanFunMask_$maskGroup.nii $a"

echo $cmd
eval $cmd

for i in DualRegression0 DualRegression1 DualRegression2 DualRegression3 DualRegression4 DualRegression5; do
cmd="3dTstat -mean -prefix /home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/meanRegress/meanDualRegression/Mean_${i}.nii /home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/meanRegress/${i}/${i}_AllVolume_meanRegress.nii"

echo $cmd
eval $cmd
done 

