
covType=GSR
modelType=fullModel 
group=child
maskFile=/home/data/Projects/workingMemory/groupAnalysis/CWAS_${covType}/68sub/followup/${modelType}/CWASDSregressFC/easythresh/cluster_mask_child_ROI1_T1_Z_neg.nii.gz
resultDir=/home/data/Projects/workingMemory/groupAnalysis/CWAS_${covType}/68sub/followup/${modelType}/avgFC
clustList="1 2"

for j in $clustList; do
		3dcalc -a $maskFile -expr 'equals(a,j)' -prefix $resultDir/maskROI${j}.nii

for i in `ls /home2/data/Projects/workingMemory/data/DPARSF_analysis/${covType}/FunImgARCWF68sub_fwhm8`; do 

	echo "---------------";
	echo "Working on sub $i...";
	echo "$i >> $resultDir/tmp.sub";
	inputFile=/home/data/Projects/workingMemory/groupAnalysis/CWAS_GSR/68sub/followup/fullModel/ROI1FC_ROIageByFT${i}.nii
		
    		3dmaskave -quiet -mask $resultDir/maskROI${j}.nii $inputFile >> $resultDir/${model}${group}CWASROI1avgFCclust${j}.txt;
	# 3dROIstats -mask <mask> /path/to/z-map/$i/fstat_map.nii.gz >> file.csv;
done
done
rm $resultDir/maskROI*.nii


# 3dMean -prefix /home/data/Projects/workingMemory/mask/CWAS_newMask_68sub_${covType}/stdMask_68sub.nii /home/data/Projects/workingMemory/mask/CWAS_newMask_68sub_${covType}/stdMask_*.nii.gz 

# 3dcalc -a /home/data/Projects/workingMemory/mask/CWAS_newMask_68sub_${covType}/stdMask_68sub.nii -expr 'equals(a,1)' -prefix /home/data/Projects/workingMemory/mask/CWAS_newMask_68sub_${covType}/stdMask_68sub_100percent.nii

# 3dcalc -a /home/data/Projects/workingMemory/mask/CWAS_newMask_68sub/stdMask_68sub.nii -expr 'step(a-0.899)' -prefix /home/data/Projects/workingMemory/mask/CWAS_newMask_68sub/stdMask_68sub_90percent.nii
