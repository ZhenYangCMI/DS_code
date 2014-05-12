% this script converts the TFR score to Z score

clear
clc

GroupAnalysisOutDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/ttestPerformGroup/HighMinusLow/'];

ROImaskGroup='adoles_BT'

groupList={'adoles_BT', 'child_BT'};

Df1=14; % N1+N2-2=8+8-2=14

for j=1:length(groupList)
    group=char(groupList{j})
    ImgFile=[GroupAnalysisOutDir,ROImaskGroup, 'Mask',group,'SubgroupHighMinusLow.nii'];
    OutputName=[GroupAnalysisOutDir,ROImaskGroup, 'Mask',group,'SubgroupHighMinusLow_Z.nii']
    Flag='T';
    
    [Z P] = y_TFRtoZ(ImgFile,OutputName,Flag,Df1);
end


% the code below run TtoZ for the mask with multiple ROIs

clear
clc

GroupAnalysisOutDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/ttestPerformGroup/HighMinusLow/'];

ROImaskGroup='child_BT'


Df1=14; %N1+N2-2=8+8-2=14

if strcmp(ROImaskGroup, 'child_BT')
    numSeed=2
    groupList={'adoles_BT', 'child_BT'};
elseif strcmp(ROImaskGroup, 'child_FT')
    numSeed=4
    groupList={'adoles_FT', 'child_FT'};
end

for j=1:length(groupList)
    group=char(groupList{j})
    
    for j=1:numSeed
        seed=num2str(j)
        ImgFile=[GroupAnalysisOutDir,ROImaskGroup, 'MaskROI',seed, group,'SubgroupHighMinusLow.nii'];
        OutputName=[GroupAnalysisOutDir,ROImaskGroup, 'MaskROI',seed, group,'SubgroupHighMinusLow_Z.nii']
        Flag='T';
        [Z P] = y_TFRtoZ(ImgFile,OutputName,Flag,Df1);
    end
end