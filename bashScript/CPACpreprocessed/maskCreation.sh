# generate subfilePath and mask the data with the CWAS mask
# covType can be 'GSR', 'noGSR', and 'compCor'

preprocessDate=1_1_14
subList="/home2/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt" 

covType='compCor'

## 1. create the group mask for CWAS
for sub in `cat $subList`; do
#cmd1="fslmaths /home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/${covType}/FunImg/normFunImg_${sub}.nii -Tstd -bin /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_${sub}.nii"
#echo $cmd1
#eval $cmd1

# create MNI space mask
#cmd2="3dAutomask -overwrite -prefix /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/autoMask_${sub}.nii  /home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/${covType}/FunImg/normFunImg_${sub}.nii.gz" 
# echo $cmd2
#eval $cmd2

# create original space mask
3dAutomask -overwrite -prefix /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/autoMaskNative_${sub}.nii  /home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/${covType}/FunImg/FunImg_${sub}.nii.gz

done


cmd3="3dMean -prefix /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_68sub.nii /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_*.nii.gz"
echo $cmd3
eval $cmd3

cmd4="3dMean -prefix /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/autoMask_68sub.nii /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/autoMask_*.nii"
echo $cmd4
eval $cmd4

cmd5="3dMean -prefix /home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/noGSR/T1Img/normT1_mean68Sub.nii /home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/noGSR/T1Img/normT1_*.nii.gz"
echo $cmd5
eval $cmd5


3dcalc -a /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_68sub.nii -expr 'step(a-0.899)' -prefix /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_68sub_90percent.nii

3dcalc -a /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/autoMask_68sub.nii -expr 'step(a-0.899)' -prefix /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/autoMask_68sub_90percent.nii

3dcalc -a /home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/noGSR/T1Img/normT1_mean68Sub.nii -expr 'step(a-0.899)' -prefix /home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/noGSR/T1Img/normT1_mean68Sub_90percent.nii









