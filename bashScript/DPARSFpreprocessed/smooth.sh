# generate subfilePath and mask the data with the CWAS mask
# covType can be 'GSR', 'noGSR', and 'compCor'

maskGroup='68sub'
smooth=6
covType='compCor'

subList="/home2/data/Projects/workingMemory/mask/subjectList_Num_${maskGroup}.txt" 

for i in `cat $subList`; do

3dmerge -1blur_fwhm 6.0 -doall -prefix /home/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/Results/skewness/sskewnessMap_${i}.nii /home/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/Results/skewness/skewnessMap_${i}.nii

#3dmerge -1blur_fwhm 6.0 -doall -prefix /home/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/Results/skewness/#szskewnessMap_${i}.nii /home/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/Results/skewness/zskewnessMap_${i}.nii
done



