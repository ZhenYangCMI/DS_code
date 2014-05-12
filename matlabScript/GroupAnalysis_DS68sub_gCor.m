% This script perform the group analysis for full model

clear all;
% group analysis for DS project

% Initiate the settings.
% 1. define Dir
% the data without GSR was used to run gCor at the group level
covType='noGSR' % 'GSR', 'noGSR', 'compCor'
group='68sub';
 
ProjectDir = '/home/data/Projects/workingMemory/';
GroupAnalysisOutDir=[ProjectDir, 'groupAnalysis/rawscores/otherMetrics68sub_gCor/fullModel/linear'];
GroupAnalysisOutDir1=[ProjectDir, 'groupAnalysis/rawscores/otherMetrics68sub_gCor/FTBTSepModel/linear'];


subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_', group, '.txt']);
numSub=length(subList)
mask=['/home/data/Projects/workingMemory/mask/otherMetrics_mask_68sub_GSR/stdMask_fullBrain_68sub_90percent.nii'];
%measureList={'ReHo','fALFF', 'VMHC', 'skewness', 'DegreeCentrality_PositiveBinarizedSumBrain', 'DegreeCentrality_PositiveWeightedSumBrain'};
measureList={'ReHo'};
numMeasure=length(measureList)
DCmask='FullBrain'; % 'FullBrain' or "GreyMatter' or 'FullBrain0.5'

for j=1:numMeasure
    measure=char(measureList{j});
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
    
    % define FileNameSet
    FileNameSet=[];
    for i=1:numSub
        sub=subList(i)
        if strcmp(measure, 'VMHC')
            FileName = ['/home/data/Projects/workingMemory/data/DPARSFanalysis/', covType, '/ResultsS/', measure, '/', 's', measure, 'Map_', num2str(sub), '.nii'];
        elseif strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain') || strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain')
            FileName = ['/home/data/Projects/workingMemory/data/DPARSFanalysis/', covType, '/ResultsWS/DegreeCentrality', DCmask,'/', 'sw', measure, 'Map_', num2str(sub), '.nii'];
        elseif strcmp(measure, 'skewness')
            FileName = ['/home/data/Projects/workingMemory/data/DPARSFanalysis/', covType, '/Results/', measure, '/', 's', measure, 'Map_', num2str(sub), '.nii'];
        else
            FileName = ['/home/data/Projects/workingMemory/data/DPARSFanalysis/', covType, '/ResultsWS/', measure, '/', 'sw', measure, 'Map_', num2str(sub), '.nii'];
        end
        FileNameSet{i,1}=FileName;
        
    end
    
     % define AllCov
    
    modelType= ['modelOtherMetrics', group]  %'modelOtherMetrics'
    
    model=load(['/home/data/Projects/workingMemory/data/', modelType, '.txt']);
    
    gCor=load('/home/data/Projects/workingMemory/data/gCor.txt')
    gCorDemean=gCor-repmat(mean(gCor), numSub, 1);
    % full model
    labels={'age_demean', 'DS_FT_demean', 'DS_BT_demean', 'ageByFTdemean', 'ageByBTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant', 'gCorDemean'}
    modelFull=[model(:, 6) model(:, 8) model(:, 9) model(:, 10) model(:, 11) model(:, 14) model(:, 15) model(:, 16) ones(numSub, 1) gCorDemean(:,1)];
    AllCov = modelFull;
    
    if strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain') || strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain')
        mkdir([GroupAnalysisOutDir,filesep,measure, '_', DCmask]);
        OutputName=[GroupAnalysisOutDir,filesep,measure,'_', DCmask, filesep, measure, '_Full']
    else
        mkdir([GroupAnalysisOutDir,filesep,measure]);
        OutputName=[GroupAnalysisOutDir,filesep,measure,filesep, measure, '_Full']
    end
    
    y_GroupAnalysis_Image(FileNameSet,AllCov,OutputName,mask);
    
    % FT model
    labelsFT={'age_demean',  'DS_FT_demean', 'ageByFTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant', 'gCorDemean'}
    modelFT=[model(:, 6) model(:, 8) model(:, 10) model(:, 14) model(:, 15) model(:, 16) ones(numSub, 1) gCorDemean(:,1)];
    AllCov1 = modelFT;
    
    if strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain') || strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain')
        mkdir([GroupAnalysisOutDir1,'/FT/', measure, '_', DCmask]);
        OutputName1=[GroupAnalysisOutDir1,'/FT/',measure,'_', DCmask, filesep, measure, '_FT']
    else
        mkdir([GroupAnalysisOutDir1,'/FT/',measure]);
        OutputName1=[GroupAnalysisOutDir1,'/FT/',measure,filesep, measure, '_FT']
    end
    
    y_GroupAnalysis_Image(FileNameSet,AllCov1,OutputName1,mask);
    
    % BT model
    labelsBT={'age_demean', 'DS_BT_demean', 'ageByBTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant', 'gCorDemean'}
    modelBT=[model(:, 6) model(:, 9) model(:, 11) model(:, 14) model(:, 15) model(:, 16) ones(numSub, 1) gCorDemean(:,1)];
    AllCov2 = modelBT;
    
    if strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain') || strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain')
        mkdir([GroupAnalysisOutDir1,'/BT/',measure, '_', DCmask]);
        OutputName2=[GroupAnalysisOutDir1,'/BT/',measure,'_', DCmask, filesep, measure, '_BT']
    else
        mkdir([GroupAnalysisOutDir1,'/BT/',measure]);
        OutputName2=[GroupAnalysisOutDir1,'/BT/',measure,filesep, measure, '_BT']
    end
    
    y_GroupAnalysis_Image(FileNameSet,AllCov2,OutputName2,mask);
    
      
end
