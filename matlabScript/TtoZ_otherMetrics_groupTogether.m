% this script converts the TFR score to Z score

clear
clc


measureList={'DegreeCentrality_PositiveBinarizedSumBrain_FullBrain', ...
'DegreeCentrality_PositiveBinarizedSumBrain_GreyMatter', 'DegreeCentrality_PositiveWeightedSumBrain_FullBrain',...
    'DegreeCentrality_PositiveWeightedSumBrain_GreyMatter'};
%measureList={'ReHo', 'ALFF', 'fALFF', 'VMHC',};
numMeasure=length(measureList);
taskList={'FT', 'BT'};
effectList={'T1', 'T2', 'T3'};

Df1=39;

for i=1:numMeasure
        measure=char(measureList{i});
        
    for j=1:length(taskList)
        task=char(taskList{j})
        for k=1:length(effectList)
            effect=char(effectList{k})
            
            resultDir=['/home2/data/Projects/workingMemory/groupAnalysis/groupTogether/', measure, '/'];
            
            if strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain_GreyMatter') || strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain_FullBrain')
            ImgFile=[resultDir, 'DegreeCentrality_PositiveWeightedSumBrain_', task, '_', effect, '.nii'];
            OutputName=[resultDir, 'DegreeCentrality_PositiveWeightedSumBrain_', task, '_', effect, '_Z.nii']
            
            elseif strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain_GreyMatter') || strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain_FullBrain')
            ImgFile=[resultDir, 'DegreeCentrality_PositiveBinarizedSumBrain_', task, '_', effect, '.nii'];
            OutputName=[resultDir, 'DegreeCentrality_PositiveBinarizedSumBrain_', task, '_', effect, '_Z.nii']
            else
                ImgFile=[resultDir, measure, '_', task, '_', effect, '.nii'];
            OutputName=[resultDir, measure, '_', task, '_', effect, '_Z.nii'];
            end
            Flag='T';
            [Z P] = y_TFRtoZ(ImgFile,OutputName,Flag,Df1);
        end
    end
end