


for covType in compCor noGSR GSR gCor; do
dataDir=/home/data/Projects/Zhen/workingMemory/results/CPAC_1_1_14/groupAnalysis/${covType}/VMHC/unthresh

    for T in T2 T3 T4 T5; do
    3dcalc -a ${dataDir}/VMHC_Full_${T}_Z.nii -b /usr/share/data/fsl-mni152-templates/MNI152_T1_2mm_left_hemisphere_mask.nii.gz -expr 'a*b' -prefix ${dataDir}/VMHC_Full_${T}_Z_L.nii
    done

    for T in T2 T3; do
    3dcalc -a ${dataDir}/VMHC_Tot_${T}_Z.nii -b /usr/share/data/fsl-mni152-templates/MNI152_T1_2mm_left_hemisphere_mask.nii.gz -expr 'a*b' -prefix ${dataDir}/VMHC_Tot_${T}_Z_L.nii
    done

done

dataDir=/home/data/Projects/Zhen/workingMemory/mask/CPAC_1_1_14/compCor
3dcalc -a /home/data/Projects/Zhen/workingMemory/mask/CPAC_1_1_14/compCor/autoMask_68sub_90percent.nii -b /usr/share/data/fsl-mni152-templates/MNI152_T1_2mm_left_hemisphere_mask.nii.gz -expr 'a*b' -prefix ${dataDir}/autoMask_68sub_90percent_L.nii


-a /home/data/Projects/Zhen/workingMemory/figs/paper_figs/compStrategies/strategyOverlap/VMHC_overlap_strategies.nii -b /usr/share/data/fsl-mni152-templates/MNI152_T1_2mm_left_hemisphere_mask.nii.gz -expr 'a*b' -prefix /home/data/Projects/Zhen/workingMemory/figs/paper_figs/compStrategies/strategyOverlap/VMHC_overlap_strategies_L.nii
