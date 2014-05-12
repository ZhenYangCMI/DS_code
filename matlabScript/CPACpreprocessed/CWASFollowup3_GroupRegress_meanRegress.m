% This script perform the group analysis for full model
% check whether the standardized or non-standardized data were used

clear all;
clc
project='workingMemory'
preprocessDate='12_16_13';
% Initiate the settings.
% 1. define Dir
% for numerical ID
subList=load('/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt');
% for text ID
% subListFile=['/home/data/Projects/', project, '/data/final110sub.txt'];
% subList1=fopen(subListFile);
% subList=textscan(subList1, '%s', 'delimiter', '\n')
% subList=cell2mat(subList{1})

numSub=length(subList)

model='TotTSep' % fullModel or TotTSep
if strcmp(model, 'TotTSep')
    effectList={'ageByTotTdemean', 'DS_TotT_demean'};
else
    effectList={'DS_FT_demean', 'DS_BT_demean', 'ageByFTdemean', 'ageByBTdemean'};
    %effectList={'ageByFTdemean'}
end


mask=['/home/data/Projects/workingMemory/mask/CPAC_12_16_13/compCor/stdMask_68sub_3mm_100percent.nii'];

GroupAnalysis=['/home/data/Projects/workingMemory/results/CPAC_12_16_13/groupAnalysis/compCor/CWAS3mm/followUpFC_meanRegress/groupAnalysis/'];
outDir=GroupAnalysis;
% 2. set path
addpath /home/data/HeadMotion_YCG/YAN_Program/mdmp
addpath /home/data/HeadMotion_YCG/YAN_Program
addpath /home/data/HeadMotion_YCG/YAN_Program/TRT
addpath /home/data/HeadMotion_YCG/YAN_Program/DPARSF_V2.2_130309
addpath /home/data/HeadMotion_YCG/YAN_Program/spm8
[ProgramPath, fileN, extn] = fileparts(which('DPARSFA_run.m'));
Error=[];
addpath([ProgramPath,filesep,'Subfunctions']);
[SPMversion,c]=spm('Ver');
SPMversion=str2double(SPMversion(end));

% 3. load covariates
[NUM,TXT,RAW]=xlsread(['/home/data/Projects/workingMemory/data/regressionModelCPACNewAnalysisAgeDemeanByDSDemean.xls']);

for j=1:length(effectList)
    effect=char(effectList{j})
    
    ROIDef=['/home/data/Projects/workingMemory/results/CPAC_12_16_13/groupAnalysis/compCor/CWAS3mm/', model, 'FWHM8.mdmr/cluster_mask_', effect, '.nii.gz']
    [Outdata,VoxDim,Header]=rest_readfile(ROIDef);
    [nDim1 nDim2 nDim3]=size(Outdata);
    ROI1D=reshape(Outdata, [], 1)';
    %ROI1D=ROI1D(1, MaskIndex);
    numClust=length(unique(ROI1D(find(ROI1D~=0))))
    
    for k=1:numClust
        
        
        % 4. group analysis
        
        FileName = {['/home/data/Projects/workingMemory/results/CPAC_12_16_13/groupAnalysis/compCor/CWAS3mm/followUpFC_meanRegress/', model, '_', effect, '_ROI', num2str(k), '_AllVolume_meanRegress.nii']};
        % perform group analysis
        
        if strcmp(model, 'fullModel')
            % full model
            labels=[TXT(1,14:16), TXT(1,18:19), TXT(1,21:23)]; %{'age_demean', 'DS_FT_demean', 'DS_BT_demean', 'ageByFTdemean', 'ageByBTdemean' 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
            labels{1,(length(labels)+1)}='constant';
            display(labels)
            regressionModel=[NUM(:,14:16) NUM(:,18:19) NUM(:,21:23) ones(numSub, 1)];
            
        elseif strcmp(model, 'TotTSep')
            % TotT model
            labels=[TXT(1,14), TXT(1,17), TXT(1,20:23)];
            labels{1,(length(labels)+1)}='constant';
            display(labels)
            %{'age_demean', 'DS_totT_demean', 'ageBytotTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
            regressionModel=[NUM(:,14) NUM(:,17) NUM(:,20:23) ones(numSub, 1)];
        end
        OutputName=[outDir,filesep, model, '_', effect, '_ROI', num2str(k)]
        y_GroupAnalysis_Image(FileName,regressionModel,OutputName,mask);
        
        % 6. convert t to Z
        if strcmp(effect, 'ageByTotTdemean')
            TList={'T3'};
        elseif strcmp(effect, 'DS_TotT_demean')
            TList={'T2'};
        elseif strcmp(effect,'ageByFTdemean')
            TList={'T4'};
        elseif strcmp(effect,'ageByBTdemean')
            TList={'T5'};
        elseif strcmp(effect,'DS_FT_demean')
            TList={'T2'};
        elseif strcmp(effect,'DS_BT_demean')
            TList={'T3'};
        end
        
        Df1=numSub-size(regressionModel,2) % N-k-1: N:number of subjects; k=num of covariates (constant excluded)
        
        for m=1:length(TList)
            TNum=char(TList{m})
            
            ImgFile=[outDir, filesep, model, '_', effect, '_ROI', num2str(k), '_', TNum, '.nii'];
            OutputName=[outDir, filesep,  model, '_', effect, '_ROI', num2str(k), '_', TNum, '_Z.nii'];
            Flag='T';
            [Z P] = y_TFRtoZ(ImgFile,OutputName,Flag,Df1);
        end
        
    end
end
