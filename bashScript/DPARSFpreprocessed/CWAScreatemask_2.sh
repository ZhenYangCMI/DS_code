# create a mask for CWAS computation
# covType can be 'GSR', 'noGSR', and 'compCor'

covType='compCor'
mkdir /home/data/Projects/workingMemory/mask/CWAS_68sub_${covType}
for i in `ls /home2/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/FunImgARCWF68sub_fwhm8`; do 
cmd="fslmaths /home/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/FunImgARCWF68sub_fwhm8/${i}/Filtered_4DVolume_4mm_fwhm8_masked.nii -Tstd -bin /home/data/Projects/workingMemory/mask/CWAS_68sub_${covType}/stdMask_${i}"

echo $cmd
eval $cmd

done

covType='compCor'
cmd="3dMean -prefix /home/data/Projects/workingMemory/mask/CWAS_68sub_${covType}/stdMask_68sub.nii /home/data/Projects/workingMemory/mask/CWAS_68sub_${covType}/stdMask_*.nii.gz"
 echo $cmd
eval $cmd

3dcalc -a /home/data/Projects/workingMemory/mask/CWAS_68sub_${covType}/stdMask_68sub.nii -expr 'equals(a,1)' -prefix /home/data/Projects/workingMemory/mask/CWAS_68sub_${covType}/stdMask_68sub_100percent.nii

3dcalc -a /home/data/Projects/workingMemory/mask/CWAS_68sub_${covType}/stdMask_68sub.nii -expr 'step(a-0.899)' -prefix /home/data/Projects/workingMemory/mask/CWAS_68sub_${covType}/stdMask_68sub_90percent.nii
