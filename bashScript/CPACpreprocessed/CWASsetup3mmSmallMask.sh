# generate subfilePath and mask the data with the CWAS mask
# covType can be 'GSR', 'noGSR', and 'compCor'
preprocessDate=12_16_13


## 1. resample and smooth the functional data 
subList="/home2/data/Projects/Zhen/workingMemory/mask/subjectList_Num_68sub.txt" 

for covType in noGSR; do

for sub in `cat $subList`; do

3dcalc -a /home/data/Projects/Zhen/workingMemory/results/CPAC_${preprocessDate}/reorgnized/${covType}/FunImg/normFunImg_${sub}.nii.gz -b /home2/data/Projects/Zhen/workingMemory/mask/MNI152_T1_GREY_3mm_25pc_mask.nii.gz -expr 'a*b' -prefix /home/data/Projects/Zhen/workingMemory/results/CPAC_${preprocessDate}/reorgnized/${covType}/FunImg/normFunImg_${sub}_grey.nii.gz

cmd="fslmaths /home/data/Projects/Zhen/workingMemory/results/CPAC_${preprocessDate}/reorgnized/${covType}/FunImg/normFunImg_${sub}_grey.nii.gz -Tstd -bin /home/data/Projects/Zhen/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_${sub}_3mm_preSmooth.nii.gz"
echo $cmd
eval $cmd

done


cmd="3dMean -prefix /home/data/Projects/Zhen/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_68sub_3mm_preSmooth.nii.gz /home/data/Projects/Zhen/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_*_3mm_preSmooth.nii.gz"
echo $cmd
eval $cmd

3dcalc -a /home/data/Projects/Zhen/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_68sub_3mm_preSmooth.nii.gz -expr 'step(a-1)' -prefix /home/data/Projects/Zhen/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_68sub_3mm_preSmooth_100percent.nii.gz

done
