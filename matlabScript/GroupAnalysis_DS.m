% This script perform the group analysis for full model

clear all;
% group analysis for DS project

% Initiate the settings.
% 1. define Dir
group='46sub'; 

ProjectDir = '/home/data/Projects/workingMemory/';
GroupAnalysisOutDir=[ProjectDir, 'groupAnalysis'];

subList=load('/home/data/Projects/workingMemory/mask/subjectList_Num_', group, '.txt');
numSub=length(subList)
mask='/home2/data/Projects/workingMemory/mask/meanFunMask1.0_46sub.nii';
%measureList={'ReHo', 'ALFF', 'fALFF', 'VMHC', 'DegreeCentrality_PositiveBinarizedSumBrain', 'DegreeCentrality_PositiveWeightedSumBrain'};
measureList={'DegreeCentrality_PositiveBinarizedSumBrain', 'DegreeCentrality_PositiveWeightedSumBrain'};
numMeasure=length(measureList)
DCmask='GreyMatter'; % 'FullBrain' or "GreyMatter'

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
            FileName = ['/home/data/Projects/workingMemory/data/DPARSF_analysis/MNICal/ResultsS_MNICal/', measure, '/', 'Zsw', measure, 'Map_', num2str(sub), '.nii'];
        elseif strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain') || strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain')
            FileName = ['/home/data/Projects/workingMemory/data/DPARSF_analysis/nativeCal/ResultsWS/DegreeCentrality', DCmask,'/', 'Zsw', measure, 'Map_', num2str(sub), '.nii'];
        else
            FileName = ['/home/data/Projects/workingMemory/data/DPARSF_analysis/nativeCal/ResultsWS/', measure, '/', 'Zsw', measure, 'Map_', num2str(sub), '.nii'];
        end
        FileNameSet{i,1}=FileName;
        
    end
    
    % define AllCov
    
    modelType= ['modelOtherMetrics', group]  %'modelOtherMetrics'
    
    model=load(['/home/data/Projects/workingMemory/data/', modelType, '.txt'])
    
    % FT
    
    labelsFT={'AgeGroup', 'AgeByDS_FT_demean', 'DS_FT_demean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
    modelFT=[model(:, 1) model(:,2) model(:, 4) model(:, 6) model(:, 7) model(:, 8) ones(numSub, 1)];
    AllCov1 = modelFT;
    
    if strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain') || strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain')
        mkdir([GroupAnalysisOutDir,filesep,measure, '_', DCmask]);
        OutputName1=[GroupAnalysisOutDir,filesep,measure,'_', DCmask, filesep, measure, '_FT']
    else
        mkdir([GroupAnalysisOutDir,filesep,measure]);
        OutputName1=[GroupAnalysisOutDir,filesep,measure,filesep, measure, '_FT']
    end
    
    y_GroupAnalysis_Image(FileNameSet,AllCov1,OutputName1,mask);
    
    % BT
    labelsBT={'AgeGroup', 'AgeByDS_BT_demean', 'DS_BT_demean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
    modelBT=[model(:, 1) model(:,3) model(:, 5) model(:, 6) model(:, 7) model(:, 8) ones(numSub, 1)]
    
    AllCov2=modelBT;
    if strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain') || strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain')
        OutputName2=[GroupAnalysisOutDir,filesep,measure,'_', DCmask, filesep, measure, '_BT']
    else
        OutputName2=[GroupAnalysisOutDir,filesep,measure,filesep, measure, '_BT']
    end
    
    y_GroupAnalysis_Image(FileNameSet,AllCov2,OutputName2,mask);
    
end
