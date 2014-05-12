# generate subfilePath and mask the data with the CWAS mask
# covType can be 'GSR', 'noGSR', and 'compCor'
preprocessDate=12_16_13
smooth=6
covType='compCor'

## 1. resample and smooth the functional data 
subList="/home2/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt" 
sublistFile="/home/data/Projects/workingMemory/code/RScript/CPACpreprocessed/CWASdataPath_${covType}_68sub_3mm.txt"
#rm -rf $sublistFile /home2/data/Projects/workingMemory/mask/meanFunMask_$maskGroup.nii
for sub in `cat $subList`; do

3dmerge -1blur_fwhm ${smooth} -doall -prefix /home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/${covType}/FunImg/normFunImg_${sub}_fwhm${smooth}.nii /home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/${covType}/FunImg/normFunImg_${sub}.nii.gz
3dcalc -a /home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/${covType}/FunImg/normFunImg_${sub}_fwhm${smooth}.nii -b /home2/data/Projects/workingMemory/mask/MNI152_T1_GREY_3mm_25pc_mask.nii.gz -expr 'a*b' -prefix /home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/${covType}/FunImg/normFunImg_${sub}_fwhm${smooth}_grey.nii
done

## 2. create the subject data path file
for sub in `cat $subList`; do
echo "/home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/${covType}/FunImg/normFunImg_${sub}_fwhm${smooth}_grey.nii" >> $sublistFile
done

preprocessDate=12_16_13
smooth=6
covType='noGSR'

## 1. resample and smooth the functional data 
subList="/home2/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt" 
## 3. create the group mask
for sub in `cat $subList`; do

cmd="fslmaths /home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/${covType}/FunImg/normFunImg_${sub}_fwhm${smooth}_grey.nii -Tstd -bin /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_${sub}_3mm.nii"
#3dAutomask -overwrite -prefix /home/data/Projects/workingMemory/mask/CPACpreprocessing/CWAS_${covType}/autoMask_${sub}.nii.gz  /home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/${covType}/FunImg_4mm_fwhm${smooth}/normFunImg_${sub}_4mm_fwhm${smooth}_masked.nii 
echo $cmd
eval $cmd

done

cmd="3dMean -prefix /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_68sub_3mm.nii /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_*_3mm.nii.gz"
echo $cmd
eval $cmd

3dcalc -a /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_68sub_3mm.nii -expr 'equals(a,1)' -prefix /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_68sub_3mm_100percent.nii

3dcalc -a /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_68sub_3mm.nii -expr 'step(a-0.899)' -prefix /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_68sub_3mm_90percent.nii

