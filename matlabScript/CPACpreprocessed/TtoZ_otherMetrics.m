% this script converts the TFR score to Z score

clear
clc
preprocessDate='1_1_14';
covType='GSR' % 'GSR', 'noGSR', 'compCor', 'meanRegress', 'gCor'
%measureList={'ReHo','fALFF', 'VMHC','skewness', 'DualRegression0', 'DualRegression1', 'DualRegression2', 'DualRegression3', 'DualRegression4', 'DualRegression5'};
measureList={'DegreeCentrality'};
numMeasure=length(measureList)
modeList={'Full', 'DB', 'DF', 'Tot'};

% full model(df1=68-8-1=59); others (df1=68-6-1=61)

for i=1:numMeasure
    measure=char(measureList{i})
    
    for j=1:length(modeList)
        model=char(modeList{j});
        
        if strcmp(model, 'Full')
            effectList={'T1', 'T2', 'T3', 'T4', 'T5'};
            if strcmp(covType, 'gCor')
                Df1=58;
            else
                Df1=59;
            end
        else
            effectList={'T1', 'T2', 'T3'};
            if strcmp(covType, 'gCor')
                Df1=60;
            else
                Df1=61;
            end
        end
        
        for k=1:length(effectList)
            effect=char(effectList{k})
            
            resultDir=['/home/data/Projects/workingMemory/results/CPAC_', preprocessDate, '/groupAnalysis/', covType, '/', measure, '/'];
            ImgFile=[resultDir, measure, '_', model, '_', effect, '.nii'];
            OutputName=[resultDir, measure, '_', model, '_', effect, '_Z.nii'];
            Flag='T';
            [Z P] = y_TFRtoZ(ImgFile,OutputName,Flag,Df1);
        end
    end
end

