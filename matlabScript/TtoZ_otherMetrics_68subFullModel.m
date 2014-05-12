% this script converts the TFR score to Z score

clear
clc

covType='meanRegress'

%measureList={'skewness', 'ReHo', 'fALFF', 'VMHC','DegreeCentrality_PositiveBinarizedSumBrain_FullBrain', ...
% 'DegreeCentrality_PositiveBinarizedSumBrain_GreyMatter', 'DegreeCentrality_PositiveBinarizedSumBrain_FullBrain0.5', 'DegreeCentrality_PositiveWeightedSumBrain_FullBrain',...
%     'DegreeCentrality_PositiveWeightedSumBrain_GreyMatter', 'DegreeCentrality_PositiveWeightedSumBrain_FullBrain0.5' };

measureList={'skewness', 'ReHo', 'fALFF', 'VMHC','DegreeCentrality_PositiveBinarizedSumBrain'};
%measureList={'ReHo', 'ALFF', 'fALFF', 'VMHC',};
numMeasure=length(measureList);
model='Full'
modelOrder='linear'

% full model: linear (df1=68-8-1=59); quadratic(df1=68-11-1=56)
if strcmp(modelOrder, 'linear')
    effectList={'T1', 'T2', 'T3', 'T4', 'T5'};
    if strcmp(covType, 'gCor')
        Df1=58;
    else    
        Df1=59;
    end
elseif strcmp(modelOrder, 'quadratic')
    effectList={'T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8'};
    if strcmp(covType, 'gCor')
        Df1=55;
    else
        Df1=56;
    end
end


for i=1:numMeasure
    measure=char(measureList{i})
    
    for k=1:length(effectList)
        effect=char(effectList{k})
        
        resultDir=['/home2/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_', covType, '/fullModel/', modelOrder, '/', measure, '/'];
        
        if strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain_GreyMatter') || strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain_FullBrain') || strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain_FullBrain0.5')
            ImgFile=[resultDir, 'DegreeCentrality_PositiveWeightedSumBrain_', model, '_', effect, '.nii'];
            OutputName=[resultDir, 'DegreeCentrality_PositiveWeightedSumBrain_', model, '_', effect, '_Z.nii']
            
        elseif strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain_GreyMatter') || strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain_FullBrain') || strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain_FullBrain0.5')
            ImgFile=[resultDir, 'DegreeCentrality_PositiveBinarizedSumBrain_', model, '_', effect, '.nii'];
            OutputName=[resultDir, 'DegreeCentrality_PositiveBinarizedSumBrain_', model, '_', effect, '_Z.nii']
        else
            ImgFile=[resultDir, measure, '_', model, '_', effect, '.nii'];
            OutputName=[resultDir, measure, '_', model, '_', effect, '_Z.nii'];
        end
        Flag='T';
        [Z P] = y_TFRtoZ(ImgFile,OutputName,Flag,Df1);
    end
end
