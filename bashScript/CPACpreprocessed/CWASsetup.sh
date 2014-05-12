# generate subfilePath and mask the data with the CWAS mask
# covType can be 'GSR', 'noGSR', and 'compCor'

smooth=8
covType='noGSR'

## 1. resample and smooth the functional data 
subList="/home2/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt" 
sublistFile="/home/data/Projects/workingMemory/code/RScript/CPACpreprocessed/CWASdataPath_${covType}_68sub.txt"
#rm -rf $sublistFile /home2/data/Projects/workingMemory/mask/meanFunMask_$maskGroup.nii
for sub in `cat $subList`; do
mkdir /home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/${covType}/FunImg_4mm_fwhm${smooth}
#rm /home2/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/FunImgARCWF${maskGroup}_fwhm${smooth}/${i}/Filtered_4DVolume_4mm_fwhm${smooth}_masked.nii
3dresample -dxyz 4.0 4.0 4.0 -prefix /home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/${covType}/FunImg_4mm_fwhm${smooth}/normFunImg_${sub}_4mm.nii -inset /home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/${covType}/FunImg/normFunImg_${sub}.nii.gz
3dmerge -1blur_fwhm 8.0 -doall -prefix /home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/${covType}/FunImg_4mm_fwhm${smooth}/normFunImg_${sub}_4mm_fwhm${smooth}.nii /home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/${covType}/FunImg_4mm_fwhm${smooth}/normFunImg_${sub}_4mm.nii
3dcalc -a /home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/${covType}/FunImg_4mm_fwhm${smooth}/normFunImg_${sub}_4mm_fwhm${smooth}.nii -b /home2/data/Projects/workingMemory/mask/MNI152_T1_GREY_4mm_25pc_mask.nii.gz -expr 'a*b' -prefix /home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/${covType}/FunImg_4mm_fwhm${smooth}/normFunImg_${sub}_4mm_fwhm${smooth}_masked.nii
done

## 2. create the subject data path file
for sub in `cat $subList`; do
echo "/home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/${covType}/FunImg_4mm_fwhm${smooth}/normFunImg_${sub}_4mm_fwhm${smooth}_masked.nii" >> $sublistFile
done


## 3. create the group mask
for sub in `cat $subList`; do

cmd="fslmaths /home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/${covType}/FunImg_4mm_fwhm${smooth}/normFunImg_${sub}_4mm_fwhm${smooth}_masked.nii -Tstd -bin /home/data/Projects/workingMemory/mask/CPACpreprocessing/CWAS_${covType}/stdMask_${sub}"
#3dAutomask -overwrite -prefix /home/data/Projects/workingMemory/mask/CPACpreprocessing/CWAS_${covType}/autoMask_${sub}.nii.gz  /home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/${covType}/FunImg_4mm_fwhm${smooth}/normFunImg_${sub}_4mm_fwhm${smooth}_masked.nii 
echo $cmd
eval $cmd

done

cmd="3dMean -prefix /home/data/Projects/workingMemory/mask/CPACpreprocessing/CWAS_${covType}/stdMask_68sub.nii /home/data/Projects/workingMemory/mask/CPACpreprocessing/CWAS_${covType}/stdMask_*.nii.gz"
echo $cmd
eval $cmd

3dcalc -a /home/data/Projects/workingMemory/mask/CPACpreprocessing/CWAS_${covType}/stdMask_68sub.nii -expr 'equals(a,1)' -prefix /home/data/Projects/workingMemory/mask/CPACpreprocessing/CWAS_${covType}/stdMask_68sub_100percent.nii

3dcalc -a /home/data/Projects/workingMemory/mask/CPACpreprocessing/CWAS_${covType}/stdMask_68sub.nii -expr 'step(a-0.899)' -prefix /home/data/Projects/workingMemory/mask/CPACpreprocessing/CWAS_${covType}/stdMask_68sub_90percent.nii

