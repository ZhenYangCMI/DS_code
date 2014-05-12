% This script perform the group analysis for full model

clear all;
clc
close all
% group analysis for DS project
preprocessDate='1_1_14'
% Initiate the settings.
% 1. define Dir
covType='noGSR'
GroupAnalysis=['/home/data/Projects/workingMemory/results/CPAC_', preprocessDate, '/groupAnalysis/meanRegress'];

subID=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt']);
numSub=length(subID);

%measureList={'ReHo', 'fALFF', 'VMHC', 'skewness', 'DualRegression0', 'DualRegression1', 'DualRegression2', 'DualRegression3', 'DualRegression4', 'DualRegression5'};
measureList={'DegreeCentrality'};
numMeasure=length(measureList)

mask=['/home/data/Projects/workingMemory/mask/CPAC_', preprocessDate, '/', covType, '/autoMask_68sub_90percent.nii']

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
model=load(['/home/data/Projects/workingMemory/data/regressionModelCPACNewAnalysisAgeDemeanByDSDemean.txt']);

% 4. check the relationship between global variable and the variable of
% interests

% for j=1:numMeasure
%     measure=char(measureList{j})
%
%     glob=load(['/home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/meanRegress/', measure, '/', measure, '_MeanSTD.mat'])
%     globMean=glob.Mean_AllSub;
%     globStd=glob.Std_AllSub;
%
%     % check the correlation between the global variables and the age, DF, DB, DTot
%     figure(j)
%     for i=1:8
%
%         % scatter plot the global Mean and variable of interests and
%         % calculate the partial correlation with motion controlled
%         if i<5
%             subplot(2,4,i)
%             scatter(globMean, model(:,i+2))
%             [r, p]=partialcorr(globMean, model(:,i+2), model(:, 11));
%             lsline
%             ylim([0 20])
%             if strcmp(measure, 'ReHo')
%                 xlim([0.05 0.15])
%             elseif strcmp(measure, 'DegreeCentrality')
%                 xlim([2000 8000])
%             elseif strcmp(measure, 'VMHC')
%                 xlim([0.2 0.8])
%             end
%             if i==1;
%                 r
%                 p
%             end
%         else
%             subplot(2,4,i)
%             scatter(globStd, model(:,i-2))
%             [r, p]=partialcorr(globStd, model(:,i-2), model(:, 11));
%             lsline
%             ylim([0 20])
%             if strcmp(measure, 'ReHo')
%                 xlim([0.02 0.08])
%             elseif strcmp(measure, 'DegreeCentrality')
%                 xlim([0 3000])
%             elseif strcmp(measure, 'fALFF')
%                 xlim([0 0.15])
%             elseif strcmp(measure, 'VMHC')
%                 xlim([0.2 0.3])
%             elseif strcmp(measure, 'skewness')
%                 xlim([0.04 0.06])
%             else
%                 xlim([0 20])
%             end
%             if i==5;
%                 r
%                 p
%             end
%         end
%     end
%     saveas(figure(j), ['/home/data/Projects/workingMemory/figs/CPACpreprocessedNew/meanRegress/', measure, '_globalVariable_phenotype.png'])
% end

% 5. group analysis
for j=1:numMeasure
    measure=char(measureList{j})
    
    FileName = {['/home/data/Projects/workingMemory/results/CPAC_', preprocessDate, '/reorgnized/meanRegress/', measure, '/', measure, '_AllVolume_meanRegress.nii']};
    % perform group analysis
    mkdir([GroupAnalysis,filesep,measure]);
    outDir=[GroupAnalysis,filesep,measure];
    
    % full model
    labels={'age_demean', 'DS_FT_demean', 'DS_BT_demean', 'ageByFTdemean', 'ageByBTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
    modelFull=[model(:, 14) model(:, 15) model(:, 16) model(:, 18) model(:, 19) model(:, 21) model(:, 22) model(:, 23) ones(numSub, 1)];
    OutputName=[outDir,filesep, measure, '_Full']
    y_GroupAnalysis_Image(FileName,modelFull,OutputName,mask);
    
    % DF model
    labelsDF={'age_demean',  'DS_FT_demean', 'ageByFTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
    modelDF=[model(:, 14) model(:, 15) model(:, 18) model(:, 21) model(:, 22) model(:, 23) ones(numSub, 1)];
    OutputName=[outDir,filesep,measure, '_DF']
    y_GroupAnalysis_Image(FileName,modelDF,OutputName,mask);
    
    % BT model
    labelsDB={'age_demean', 'DS_BT_demean', 'ageByBTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
    modelDB=[model(:, 14) model(:, 16) model(:, 19) model(:, 21) model(:, 22) model(:, 23) ones(numSub, 1)];
    OutputName=[outDir,filesep, measure, '_DB']
    y_GroupAnalysis_Image(FileName,modelDB,OutputName,mask);
    
    % TotT model
    labelsTot={'age_demean', 'DS_totT_demean', 'ageBytotTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
    modelTot=[model(:, 14) model(:, 17) model(:, 20) model(:, 21) model(:, 22) model(:, 23) ones(numSub, 1)];
    OutputName=[outDir,filesep,measure, '_Tot']
    y_GroupAnalysis_Image(FileName,modelTot,OutputName,mask);
    
end
