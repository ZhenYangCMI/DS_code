% this script converts the TFR score to Z score

clear
clc

DSGroup='top' % can be 'top' or 'bottom'

GroupAnalysisOutDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/ttestPerformGroup/meanFCHighAndLow/'];

ROImaskGroup='adoles_BT'

groupList={'adoles_BT', 'child_BT'};

Df1=7; % N-1=8-1=7

for j=1:length(groupList)
    group=char(groupList{j})
    ImgFile=[GroupAnalysisOutDir,ROImaskGroup, 'Mask', group,'SubgroupMean', DSGroup, '.nii'];
    OutputName=[GroupAnalysisOutDir,ROImaskGroup, 'Mask', group,'SubgroupMean', DSGroup, '_Z.nii']
    Flag='T';
    
    [Z P] = y_TFRtoZ(ImgFile,OutputName,Flag,Df1);
end


% the code below run TtoZ for the mask with multiple ROIs

% clear
% clc
% DSGroup='bottom' % can be 'top' or 'bottom'
% GroupAnalysisOutDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/ttestPerformGroup/meanFCHighAndLow/'];
%Df1=7; % N-1=8-1=7


ROImaskGroup='child_FT'

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
        ImgFile=[GroupAnalysisOutDir,ROImaskGroup, 'MaskROI',seed, group,'SubgroupMean', DSGroup, '.nii'];
        OutputName=[GroupAnalysisOutDir,ROImaskGroup, 'MaskROI',seed, group,'SubgroupMean', DSGroup, '_Z.nii']
        Flag='T';
        [Z P] = y_TFRtoZ(ImgFile,OutputName,Flag,Df1);
    end
end