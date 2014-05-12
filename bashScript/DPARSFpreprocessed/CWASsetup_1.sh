# generate subfilePath and mask the data with the CWAS mask
# covType can be 'GSR', 'noGSR', and 'compCor'

maskGroup='68sub'
smooth=8
covType='compCor'

subList="/home2/data/Projects/workingMemory/mask/subjectList_Num_${maskGroup}.txt" 
sublistFile="/home2/data/Projects/workingMemory/code/RScript/${maskGroup}_CWASdataPath_${covType}.txt"
#rm -rf $sublistFile /home2/data/Projects/workingMemory/mask/meanFunMask_$maskGroup.nii
for i in `cat $subList`; do
mkdir /home2/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/FunImgARCWF${maskGroup}_fwhm${smooth}/${i}
#rm /home2/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/FunImgARCWF${maskGroup}_fwhm${smooth}/${i}/Filtered_4DVolume_4mm_fwhm${smooth}_masked.nii
3dresample -dxyz 4.0 4.0 4.0 -prefix /home2/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/FunImgARCWF${maskGroup}_fwhm${smooth}/${i}/Filtered_4DVolume_4mm.nii -inset /home2/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/FunImgARCWF/$i/Filtered_4DVolume.nii
3dmerge -1blur_fwhm 8.0 -doall -prefix /home2/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/FunImgARCWF${maskGroup}_fwhm${smooth}/${i}/Filtered_4DVolume_4mm_fwhm${smooth}.nii /home2/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/FunImgARCWF${maskGroup}_fwhm${smooth}/${i}/Filtered_4DVolume_4mm.nii
3dcalc -a /home2/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/FunImgARCWF${maskGroup}_fwhm${smooth}/${i}/Filtered_4DVolume_4mm_fwhm${smooth}.nii -b /home2/data/Projects/workingMemory/mask/MNI152_T1_GREY_4mm_25pc_mask.nii.gz -expr 'a*b' -prefix /home2/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/FunImgARCWF${maskGroup}_fwhm${smooth}/${i}/Filtered_4DVolume_4mm_fwhm${smooth}_masked.nii
done

for i in `cat $subList`; do
echo "/home2/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/FunImgARCWF${maskGroup}_fwhm${smooth}/${i}/Filtered_4DVolume_4mm_fwhm${smooth}_masked.nii" >> $sublistFile
done



