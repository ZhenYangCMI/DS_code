% This script perform the group analysis for full model
clear
clc

covType='GSR'
modelType='fullModel'

numSub=34;
dataDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/68sub/followup/', modelType, '/'];
figDir=['/home2/data/Projects/workingMemory/figs/CWAS_', covType, '/68sub/CWAS_followup/scatterplot/'];

groupList={'child', 'adoles'} % 'child', or adoles

maskFile=['/home/data/Projects/workingMemory/mask/CWAS_newMask46sub/stdMask_46sub_100percent.nii']
GroupAnalysisOutDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/68sub/followup/', modelType, '/CWASDSregressFC/'];

numROI=2

for j=1:length(groupList)
    group=char(groupList{j})
    subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt']);
    
    if strcmp(group, 'child')
        subList=subList(1:34)
    else
        subList=subList(35:68)
    end
    numSub=length(subList)
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
    model=load(['/home/data/Projects/workingMemory/data/modelOtherMetrics68sub.txt']);
        labels={'DS_FT_demean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
    
    for k=1:numROI
        ROI=num2str(k)
        
        % define FileNameSet
        FileNameSet=[];
        for i=1:numSub
            sub=num2str(subList(i))
            FileName=['/home/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/68sub/followup/', modelType,'/zROI', ROI, 'FC_ROIageByFT', sub, '.nii']
            FileNameSet{i,1}=FileName;
        end
        
        % define AllCov
                
             
        if strcmp(group, 'child')
                modelFT=[model(1:34, 8) model(1:34,14) model(1:34, 15) model(1:34, 16) ones(numSub, 1)];
        else
            
        modelFT=[model(35:68, 8) model(35:68,14) model(35:68, 15) model(35:68, 16) ones(numSub, 1)];
        end
        
        AllCov = modelFT;
        
        
        OutputName=[GroupAnalysisOutDir,filesep, group, '_ROI', ROI ]
        
        y_GroupAnalysis_Image(FileNameSet,AllCov,OutputName,maskFile);
        
    end
end
