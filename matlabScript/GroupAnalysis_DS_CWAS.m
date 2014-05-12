% This script perform the group analysis for full model


ROImaskGroup='adoles_BT'

groupList={'adoles', 'child'}; % the sub in the model were sorted by age, so use this subList in stead of the adoles_BT which the su
dataDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/CWAS', ROImaskGroup, '/'];
maskFile=['/home2/data/Projects/workingMemory/mask/CWAS_newMask/stdMask_46sub_100percent.nii']
GroupAnalysisOutDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/regressDSAndFullBrainFC/'];

for j=1:length(groupList)
    group=char(groupList{j})
    subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_', group, '.txt']);
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
    
    % define FileNameSet
    FileNameSet=[];
    for i=1:numSub
        sub=num2str(subList(i))
        FileName=['/home/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/CWAS', ROImaskGroup, '/z', ROImaskGroup, '_', sub, '.nii']
        FileNameSet{i,1}=FileName;
    end
    
    % define AllCov
    
    modelType= ['modelOtherMetrics23', group]  %'modelOtherMetrics'
    model=load(['/home/data/Projects/workingMemory/data/', modelType, '.mat'])
    model=model.([group, '23']);
    % un the model
    
    labels={'DS_BT', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
    model=[model(:, 4) model(:,5) model(:, 6) model(:, 7) ones(numSub, 1)];
    
    AllCov = model;
    mkdir([GroupAnalysisOutDir,ROImaskGroup]);
    OutputName=[GroupAnalysisOutDir,ROImaskGroup, filesep, ROImaskGroup,'Mask_',group, 'Subgroup']
    
    y_GroupAnalysis_Image(FileNameSet,AllCov,OutputName,maskFile);
    
end
