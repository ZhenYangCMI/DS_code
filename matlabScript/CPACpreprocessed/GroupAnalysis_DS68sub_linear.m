% This script perform the group analysis for full model
% check whether the standardized or non-standardized data were used

clear all;
% group analysis for DS project

preprocessDate='1_1_14'
% Initiate the settings.
% 1. define Dir
covTypeList={'noGSR', 'GSR', 'compCor'}; % 'GSR', 'noGSR', 'compCor'

subID=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt']);
numSub=length(subID);

%measureList={'ReHo','fALFF', 'VMHC', 'skewness', 'DualRegression0', 'DualRegression1', 'DualRegression2', 'DualRegression3', 'DualRegression4', 'DualRegression5'};
measureList={'DegreeCentrality'};
numMeasure=length(measureList)


for m=1:length(covTypeList)
    covType=char(covTypeList{m});
    
    mkdir (['/home/data/Projects/workingMemory/results/CPAC_', preprocessDate, '/groupAnalysis/', covType])
    GroupAnalysis=['/home/data/Projects/workingMemory/results/CPAC_', preprocessDate, '/groupAnalysis/', covType];
    mask=['/home/data/Projects/workingMemory/mask/CPAC_', preprocessDate, '/', covType, '/autoMask_68sub_90percent.nii']
    
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
        
        for i=1:length(subID)
            
            sub=num2str(subID(i))
            if strcmp(measure, 'VMHC')
                FileName = sprintf('/home/data/Projects/workingMemory/results/CPAC_%s/reorgnized/%s/%s/Snorm%s_%s.nii.gz', preprocessDate, covType, measure,measure,sub);
            else
                FileName = sprintf('/home/data/Projects/workingMemory/results/CPAC_%s/reorgnized/%s/%s/%s_%s_MNI_fwhm6.nii', preprocessDate, covType, measure,measure,sub);
            end
            
            if ~exist(FileName,'file')
                
                disp(SubID{i})
                
            else
                
                FileNameSet{i,1}=FileName;
                
            end
            
        end
        
        % define AllCov
        
        model=load(['/home/data/Projects/workingMemory/data/regressionModelCPACNewAnalysisAgeDemeanByDSDemean.txt']);
        mkdir([GroupAnalysis,filesep,measure]);
        outDir=[GroupAnalysis,filesep,measure];
        
        % full model
        labels={'age_demean', 'DS_FT_demean', 'DS_BT_demean', 'ageByFTdemean', 'ageByBTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
        modelFull=[model(:, 14) model(:, 15) model(:, 16) model(:, 18) model(:, 19) model(:, 21) model(:, 22) model(:, 23) ones(numSub, 1)];
        OutputName=[outDir,filesep, measure, '_Full']
        y_GroupAnalysis_Image(FileNameSet,modelFull,OutputName,mask);
        
        % DF model
        labelsDF={'age_demean',  'DS_FT_demean', 'ageByFTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
        modelDF=[model(:, 14) model(:, 15) model(:, 18) model(:, 21) model(:, 22) model(:, 23) ones(numSub, 1)];
        OutputName=[outDir,filesep,measure, '_DF']
        y_GroupAnalysis_Image(FileNameSet,modelDF,OutputName,mask);
        
        % BT model
        labelsDB={'age_demean', 'DS_BT_demean', 'ageByBTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
        modelDB=[model(:, 14) model(:, 16) model(:, 19) model(:, 21) model(:, 22) model(:, 23) ones(numSub, 1)];
        OutputName=[outDir,filesep, measure, '_DB']
        y_GroupAnalysis_Image(FileNameSet,modelDB,OutputName,mask);
        
        % TotT model
        labelsTot={'age_demean', 'DS_totT_demean', 'ageBytotTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
        modelTot=[model(:, 14) model(:, 17) model(:, 20) model(:, 21) model(:, 22) model(:, 23) ones(numSub, 1)];
        OutputName=[outDir,filesep,measure, '_Tot']
        y_GroupAnalysis_Image(FileNameSet,modelTot,OutputName,mask);
        
    end
end
