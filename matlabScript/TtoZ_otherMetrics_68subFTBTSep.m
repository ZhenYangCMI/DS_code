% this script converts the TFR score to Z score

clear
clc

covType='meanRegress'

% measureList={'ReHo', 'fALFF', 'VMHC','DegreeCentrality_PositiveBinarizedSumBrain_FullBrain', ...
%     'DegreeCentrality_PositiveBinarizedSumBrain_GreyMatter', 'DegreeCentrality_PositiveWeightedSumBrain_FullBrain',...
%     'DegreeCentrality_PositiveWeightedSumBrain_GreyMatter', 'DegreeCentrality_PositiveBinarizedSumBrain_FullBrain0.5', ...
%     'DegreeCentrality_PositiveWeightedSumBrain_FullBrain0.5'};

%measureList={'ReHo', 'fALFF', 'VMHC','DegreeCentrality_PositiveBinarizedSumBrain_FullBrain', 'DegreeCentrality_PositiveWeightedSumBrain_FullBrain'};
measureList={'fALFF', 'VMHC'};
numMeasure=length(measureList);
modelOrder='linear'
taskList={'BT', 'FT'}

% full model: gCor linear (df1=68-7-1=60); quadratic(df1=68-9-1=58); others linear (df1=68-6-1=61); quadratic(df1=68-8-1=59)
if strcmp(modelOrder, 'linear')
    effectList={'T1', 'T2', 'T3'};
    if strcmp(covType, 'gCor')
        Df1=60;
    else
        Df1=61;
    end
elseif strcmp(modelOrder, 'quadratic')
    effectList={'T1', 'T2', 'T3', 'T4', 'T5'};
    if strcmp(covType, 'gCor')
        Df1=58;
    else
        Df1=59;
    end
end


for i=1:numMeasure
    measure=char(measureList{i})
    
    for k=1:length(taskList)
        task=char(taskList{k})
        
        resultDir=['/home2/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_', covType, '/FTBTSepModel/', modelOrder, '/', task, '/',measure, '/'];
        
        for j=1:length(effectList)
            effect=char(effectList{j});
            
            if strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain_GreyMatter') || strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain_FullBrain') || strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain_FullBrain0.5')
                ImgFile=[resultDir, 'DegreeCentrality_PositiveWeightedSumBrain_', task,'_', effect,  '.nii'];
                OutputName=[resultDir, 'DegreeCentrality_PositiveWeightedSumBrain_', task, '_', effect, '_Z.nii']
                
            elseif strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain_GreyMatter') || strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain_FullBrain') || strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain_FullBrain0.5')
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