% This script perform the group analysis for full model

clear all;
clc
% group analysis for DS project

% Initiate the settings.
% 1. define Dir
covType='meanRegress' % 'GSR', 'noGSR', 'compCor'
group='68sub';

ProjectDir = '/home/data/Projects/workingMemory/';
GroupAnalysisOutDir=[ProjectDir, 'groupAnalysis/rawscores/otherMetrics68sub_', covType, '/fullModel/linear'];
GroupAnalysisOutDir1=[ProjectDir, 'groupAnalysis/rawscores/otherMetrics68sub_', covType, '/FTBTSepModel/linear'];


subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_', group, '.txt']);
numSub=length(subList)
mask=['/home/data/Projects/workingMemory/mask/otherMetrics_mask_68sub_noGSR/stdMask_fullBrain_68sub_90percent.nii'];


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

% 3. group analysis

%measureList={'ReHo','fALFF', 'VMHC', 'skewness', 'DegreeCentrality_PositiveBinarizedSumBrain', 'DegreeCentrality_PositiveWeightedSumBrain'};
measureList={'skewness'};
numMeasure=length(measureList)

for j=1:numMeasure
    measure=char(measureList{j});
    
    FileName = {['/home/data/Projects/workingMemory/data/DPARSFanalysis/', covType, '/', measure, '_AllVolume_meanRegress.nii']};
    
    glob=load(['/home/data/Projects/workingMemory/data/DPARSFanalysis/', covType, '/', measure, '_MeanSTD.mat'])
    globMean=glob.Mean_AllSub
    globStd=glob.Std_AllSub
    % define AllCov
    
    modelType= ['modelOtherMetrics', group]  %'modelOtherMetrics'
    
    model=load(['/home/data/Projects/workingMemory/data/', modelType, '.txt']);
    
    close all
    figure(1)
    for i=1:6
        if i<4
            subplot(2,3,i)
            scatter(globMean, model(:,i+1))
            [r, p]=corr(globMean, model(:,i+1))
            lsline
                        ylim([0 20])
                        if strcmp(measure, 'ReHo')
                        xlim([0.05 0.15])
                        elseif strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain')
                             xlim([0 4500])
                        end
        else
            subplot(2,3,i)
            scatter(globStd, model(:,i-2))
            [r, p]=corr(globStd, model(:,i-2))
            lsline
            
            ylim([0 20])
            if strcmp(measure, 'ReHo')
                xlim([0.02 0.08])
            elseif strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain')
                             xlim([0 2500])
            end
        end
    end
    saveas(figure(1), ['/home/data/Projects/workingMemory/figs/rawscores/otherMetrics68sub_meanRegress/', measure, 'global_phenotype.png'])
end
    
%     % full model
%     labels={'age_demean', 'DS_FT_demean', 'DS_BT_demean', 'ageByFTdemean', 'ageByBTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
%     modelFull=[model(:, 6) model(:, 8) model(:, 9) model(:, 10) model(:, 11) model(:, 14) model(:, 15) model(:, 16) ones(numSub, 1)];
%     AllCov = modelFull;
%     
%     
%     mkdir([GroupAnalysisOutDir,filesep,measure]);
%     OutputName=[GroupAnalysisOutDir,filesep,measure,filesep, measure, '_Full']
%     
%     
%     y_GroupAnalysis_Image(FileName,AllCov,OutputName,mask);
%     
%     % FT model
%     labelsFT={'age_demean',  'DS_FT_demean', 'ageByFTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
%     modelFT=[model(:, 6) model(:, 8) model(:, 10) model(:, 14) model(:, 15) model(:, 16) ones(numSub, 1)];
%     AllCov1 = modelFT;
%     
%     
%     mkdir([GroupAnalysisOutDir1,'/FT/',measure]);
%     OutputName1=[GroupAnalysisOutDir1,'/FT/',measure,filesep, measure, '_FT']
%     
%     
%     y_GroupAnalysis_Image(FileName,AllCov1,OutputName1,mask);
%     
%     % BT model
%     labelsBT={'age_demean', 'DS_BT_demean', 'ageByBTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
%     modelBT=[model(:, 6) model(:, 9) model(:, 11) model(:, 14) model(:, 15) model(:, 16) ones(numSub, 1)];
%     AllCov2 = modelBT;
%     
%     
%     mkdir([GroupAnalysisOutDir1,'/BT/',measure]);
%     OutputName2=[GroupAnalysisOutDir1,'/BT/',measure,filesep, measure, '_BT']
%     
%     
%     y_GroupAnalysis_Image(FileName,AllCov2,OutputName2,mask);
% end
% 
% 
