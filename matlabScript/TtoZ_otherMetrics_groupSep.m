% this script converts the TFR score to Z score

clear
clc


measureList={'ReHo', 'ALFF', 'fALFF', 'VMHC','DegreeCentrality_PositiveBinarizedSumBrain_FullBrain', ...
    'DegreeCentrality_PositiveBinarizedSumBrain_GreyMatter', 'DegreeCentrality_PositiveWeightedSumBrain_FullBrain',...
    'DegreeCentrality_PositiveWeightedSumBrain_GreyMatter'};
%measureList={'ReHo', 'ALFF', 'fALFF', 'VMHC',};
numMeasure=length(measureList);
taskList={'FT', 'BT'};
groupList={'child', 'adoles'}
effect='T1';

Df1=18; % N-k-1=23-4-1=18

for k=1:length(groupList)
    group=char(groupList{k})
    
    for i=1:numMeasure
        measure=char(measureList{i});
        
        for j=1:length(taskList)
            task=char(taskList{j})
            
            resultDir=['/home2/data/Projects/workingMemory/groupAnalysis/groupSep/', measure, '/'];
            
            if strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain_GreyMatter') || strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain_FullBrain')
                ImgFile=[resultDir, group, '_', 'DegreeCentrality_PositiveWeightedSumBrain_', task, '_', effect, '.nii'];
                OutputName=[resultDir, group, '_', 'DegreeCentrality_PositiveWeightedSumBrain_', task, '_', effect, '_Z.nii']
                
            elseif strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain_GreyMatter') || strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain_FullBrain')
                ImgFile=[resultDir, group, '_', 'DegreeCentrality_PositiveBinarizedSumBrain_', task, '_', effect, '.nii'];
                OutputName=[resultDir, group, '_', 'DegreeCentrality_PositiveBinarizedSumBrain_', task, '_', effect, '_Z.nii']
            else
                ImgFile=[resultDir, group, '_', measure, '_', task, '_', effect, '.nii'];
                OutputName=[resultDir, group, '_', measure, '_', task, '_', effect, '_Z.nii'];
            end
            Flag='T';
            [Z P] = y_TFRtoZ(ImgFile,OutputName,Flag,Df1);
        end
    end
end