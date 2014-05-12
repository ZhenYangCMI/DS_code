clear
clc

covType='compCor'
model='fullModel' 
dataDir='/home/data/Projects/workingMemory/data/DPARSFanalysis/';
subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt']);
numSub=length(subList);

MaskData='/home2/data/Projects/workingMemory/mask/CWAS_68sub_noGSR/stdMask_68sub_100percent.nii'

    %mkdir(['/home/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/CWAS68sub/', model, 'LinearFWHM8.mdmr/followup'])
    outputDir= ['/home/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/CWAS68sub/', model, 'LinearFWHM8.mdmr/followup/'];
    for i=1:numSub
        sub=num2str(subList(i))
        AllVolume=[dataDir, covType, '/FunImgARCWF68sub_fwhm8/', sub, '/Filtered_4DVolume_4mm_fwhm8_masked.nii'];
        
        ROIDef={['/home/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/CWAS68sub/', model, 'LinearFWHM8.mdmr/cluster_mask_DS_FT_demean.nii.gz']}
        OutputName=[outputDir, covType, '_FC_ROIFT', sub];
        IsMultipleLabel=1;
        [FCBrain, Header] = y_SCA(AllVolume, ROIDef, OutputName, MaskData, IsMultipleLabel);
    end
