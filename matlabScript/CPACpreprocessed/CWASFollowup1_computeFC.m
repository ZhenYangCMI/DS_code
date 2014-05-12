clear
clc


dataDir=['/home/data/Projects/workingMemory/results/CPAC_12_16_13/reorgnized/compCor/FunImg/'];
MaskData='/home/data/Projects/workingMemory/mask/CPAC_12_16_13/compCor/stdMask_68sub_3mm_100percent.nii'
subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt']);
numSub=length(subList)
model='TotTSep' % fullModel or TotTSep
if strcmp(model, 'TotTSep')
    effectList={'ageByTotTdemean', 'DS_TotT_demean'};
else
    effectList={'DS_FT_demean', 'DS_BT_demean', 'ageByFTdemean', 'ageByBTdemean'};
end

for j=1:length(effectList)
    effect=char(effectList{j})    
    mkdir (['/home/data/Projects/workingMemory/results/CPAC_12_16_13/groupAnalysis/compCor/CWAS3mm/', model, 'FWHM8.mdmr/', effect, '_followUp'])
    outputDir= ['/home/data/Projects/workingMemory/results/CPAC_12_16_13/groupAnalysis/compCor/CWAS3mm/', model, 'FWHM8.mdmr/', effect, '_followUp/'];
    for i=1:numSub
        sub=num2str(subList(i))
        AllVolume=[dataDir, 'normFunImg_', sub, '_fwhm6_grey.nii'];
        
        ROIDef={['/home/data/Projects/workingMemory/results/CPAC_12_16_13/groupAnalysis/compCor/CWAS3mm/', model, 'FWHM8.mdmr/cluster_mask_', effect, '.nii.gz']}
        OutputName=[outputDir, 'FC_', effect, '_', sub];
        IsMultipleLabel=1;
        [FCBrain, Header] = y_SCA(AllVolume, ROIDef, OutputName, MaskData, IsMultipleLabel);
    end
end