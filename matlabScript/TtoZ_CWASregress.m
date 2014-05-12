% this script converts the TFR score to Z score

clear
clc

GroupAnalysisOutDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/regressDSAndFullBrainFC/'];

ROImaskGroup='adoles_BT'

groupList={'adoles', 'child'};

Df1=18; % N-k-1=23-4-1=18

for j=1:length(groupList)
    group=char(groupList{j})
    ImgFile=[GroupAnalysisOutDir,ROImaskGroup, filesep, ROImaskGroup,'Mask_',group, 'Subgroup_T1.nii'];
    OutputName=[GroupAnalysisOutDir,ROImaskGroup, filesep, ROImaskGroup,'Mask_',group, 'Subgroup_T1_Z.nii']
    Flag='T';
    
    [Z P] = y_TFRtoZ(ImgFile,OutputName,Flag,Df1);
end


% the code below run TtoZ for the mask with multiple ROIs

clear
clc

GroupAnalysisOutDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/regressDSAndFullBrainFC/'];

ROImaskGroup='child_FT'

groupList={'adoles', 'child'};

Df1=18; % N-k-1=23-4-1=18

if strcmp(ROImaskGroup, 'child_BT')
    numSeed=2
elseif strcmp(ROImaskGroup, 'child_FT')
    numSeed=4
end

for j=1:length(groupList)
    group=char(groupList{j})
    
    for j=1:numSeed
        seed=num2str(j)
        ImgFile=[GroupAnalysisOutDir,ROImaskGroup, filesep, ROImaskGroup,'Mask_',group, 'Subgroup_ROI', seed, '_T1.nii'];
        OutputName=[GroupAnalysisOutDir,ROImaskGroup, filesep, ROImaskGroup,'Mask_',group, 'Subgroup_ROI', seed, '_T1_Z.nii']
        Flag='T';
        [Z P] = y_TFRtoZ(ImgFile,OutputName,Flag,Df1);
    end
end