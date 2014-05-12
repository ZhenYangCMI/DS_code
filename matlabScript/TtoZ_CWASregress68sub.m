% this script converts the TFR score to Z score

clear
clc

covType='compCor'
modelType='fullModelLinearFWHM8.mdmr'
GroupAnalysisOutDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/CWAS68sub/', modelType, '/followup/CWASregress/'];

effectList={'FT', 'BT'}  % can be 'FT', 'ageByBT', or 'ageByFT', when the effect is ageByBT, the fullBrain FC was calculated using the ageByFT ROI mask


for j=1:length(effectList)
    effect=char(effectList{j})
    
    if strcmp(effect, 'FT') | strcmp(effect, 'BT')
    numROI=2
    df=60 % N-k-1=68-7-1=60
else strcmp(effect, 'ageByFT') | strcmp(effect, 'ageByBT')
    numROI=1
    df=62 % 68-5-1=62
end
    for i=1:numROI
        ROI=num2str(i)
        if strcmp(effect, 'FT') | strcmp(effect, 'BT')
            ImgFile=[GroupAnalysisOutDir, effect, 'ROI', ROI,'_T1.nii'];
            OutputName=[GroupAnalysisOutDir,effect, '_ROI', ROI,'_T1_Z.nii']
            Flag='T';
            [Z P] = y_TFRtoZ(ImgFile,OutputName,Flag,df);
        else
            for k=1:3
                ImgFile=[GroupAnalysisOutDir, effect, 'ROI', ROI,'_T', num2str(k), '.nii'];
                OutputName=[GroupAnalysisOutDir,effect, '_ROI', ROI,'_T', num2str(k), '_Z.nii']
                Flag='T';
                [Z P] = y_TFRtoZ(ImgFile,OutputName,Flag,df);
            end
        end
    end
    
end
    
    
    
