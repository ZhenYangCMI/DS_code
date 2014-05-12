% This script perform the group analysis for full model
clear
clc

covType='compCor'
modelType='fullModelLinearFWHM8.mdmr'
effect='BT' % can be 'FT', 'ageByBT', or 'ageByFT', when the effect is ageByBT, the fullBrain FC was calculated using the ageByFT ROI mask

if strcmp(effect, 'FT') | strcmp(effect, 'BT')
    numROI=2
else strcmp(effect, 'ageByFT') | strcmp(effect, 'ageByBT')
    numROI=1
end

dataDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/CWAS68sub/', modelType, '/followup/'];
figDir=['/home2/data/Projects/workingMemory/figs/CWAS_', covType, '/'];

maskFile=['/home2/data/Projects/workingMemory/mask/CWAS_68sub_noGSR/stdMask_68sub_100percent.nii']
GroupAnalysisOutDir=[dataDir, 'CWASregress/'];



subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt']);
numSub=length(subList);
% 2. set path
%addpath /home/data/HeadMotion_YCG/YAN_Program/mdmp
addpath /home/data/HeadMotion_YCG/YAN_Program
addpath /home/data/HeadMotion_YCG/YAN_Program/TRT
addpath /home/data/HeadMotion_YCG/YAN_Program/DPARSF_V2.3_130615
addpath /home/data/HeadMotion_YCG/YAN_Program/spm8
[ProgramPath, fileN, extn] = fileparts(which('DPARSFA_run.m'));
Error=[];
addpath([ProgramPath,filesep,'Subfunctions']);
[SPMversion,c]=spm('Ver');
SPMversion=str2double(SPMversion(end));

% 3. group analysis
NP=load(['/home/data/Projects/workingMemory/data/modelOtherMetrics68sub.txt']);
labels={'age_demean', 'DS_FT_demean', 'ageByFTdemean','WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}

for k=1:numROI
    ROI=num2str(k)
    
    % define FileNameSet
    FileNameSet=[];
    for i=1:length(subList)
        sub=num2str(subList(i))
        if strcmp(effect, 'FT') | strcmp(effect, 'BT')
            FileName=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/CWAS68sub/', modelType, '/followup/zROI', ROI, covType, '_FC_ROIFT', sub, '.nii']
        else strcmp(effect, 'ageByFT') | strcmp(effect, 'ageByBT')
            FileName=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/CWAS68sub/', modelType, '/followup/z', covType, '_FC_ROIageByFT', sub, '.nii']
        end
        FileNameSet{i,1}=FileName;
    end
    
    % define AllCov
    
    
    if strcmp(effect, 'ageByFT')
        model=[NP(:, 6) NP(:, 8) NP(:, 10) NP(:, 14) NP(:, 15) NP(:, 16)  ones(numSub, 1)];
    elseif strcmp(effect, 'ageByBT')
        model=[NP(:, 6) NP(:, 9) NP(:, 11) NP(:, 14) NP(:, 15) NP(:, 16)  ones(numSub, 1)];
    elseif strcmp(effect, 'FT')
        model=[NP(:, 8) NP(:, 14) NP(:, 15) NP(:, 16)  ones(numSub, 1)];
    elseif strcmp(effect, 'BT')
        model=[NP(:, 9) NP(:, 14) NP(:, 15) NP(:, 16)  ones(numSub, 1)];
    end
    
    AllCov = model;
    
    OutputName=[GroupAnalysisOutDir,filesep, effect, 'ROI', ROI ]
    
    y_GroupAnalysis_Image(FileNameSet,AllCov,OutputName,maskFile);
    
end

