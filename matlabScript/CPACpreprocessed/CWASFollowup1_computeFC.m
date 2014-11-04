clear
clc

rmpath /home/milham/matlab/REST_V1.7
rmpath /home/milham/matlab/REST_V1.7/Template
rmpath /home/milham/matlab/REST_V1.7/man
rmpath /home/milham/matlab/REST_V1.7/mask
rmpath /home/milham/matlab/REST_V1.7/rest_spm5_files

restoredefaultpath

addpath(genpath('/home/data/Projects/Zhen/commonCode/spm8'))
addpath /home/data/Projects/Zhen/commonCode/DPARSF_V2.3_130615
addpath /home/data/Projects/Zhen/commonCode/DPARSF_V2.3_130615/Subfunctions/
addpath /home/data/Projects/Zhen/commonCode/REST_V1.8_130615

covType='noGSR'

dataDir=['/home/data/Projects/Zhen/workingMemory/results/CPAC_12_16_13/reorgnized/', covType, '/FunImg/'];
MaskData=['/home/data/Projects/Zhen/workingMemory/mask/CPAC_12_16_13/', covType, '/stdMask_68sub_3mm_preSmooth_100percent.nii'];
subList=load(['/home/data/Projects/Zhen/workingMemory/mask/subjectList_Num_68sub.txt']);
numSub=length(subList)
model='TotTSep' % fullModel or TotTSep
if strcmp(model, 'TotTSep')
    effectList={'ageByTotTdemean', 'DS_TotT_demean'};
else
    %effectList={'DS_FT_demean', 'DS_BT_demean', 'ageByFTdemean', 'ageByBTdemean'};
    effectList={'DS_FT_demean', 'DS_BT_demean'};
end

for j=1:length(effectList)
    effect=char(effectList{j})    
    mkdir (['/home/data/Projects/Zhen/workingMemory/results/CPAC_12_16_13/groupAnalysis/', covType, '/CWAS3mmSmallMask/', model, 'FWHM8.mdmr/', effect, '_followUp'])
    outputDir= ['/home/data/Projects/Zhen/workingMemory/results/CPAC_12_16_13/groupAnalysis/', covType, '/CWAS3mmSmallMask/', model, 'FWHM8.mdmr/', effect, '_followUp/'];
    for i=1:numSub
        sub=num2str(subList(i))
        AllVolume=[dataDir, 'normFunImg_', sub, '_fwhm6_grey.nii'];
        
        ROIDef={['/home/data/Projects/Zhen/workingMemory/results/CPAC_12_16_13/groupAnalysis/', covType, '/CWAS3mmSmallMask/', model, 'FWHM8.mdmr/cluster_mask_', effect, '.nii']}
        OutputName=[outputDir, 'FC_', effect, '_', sub];
        IsMultipleLabel=1;
        [FCBrain, Header] = y_SCA(AllVolume, ROIDef, OutputName, MaskData, IsMultipleLabel);
    end
end
