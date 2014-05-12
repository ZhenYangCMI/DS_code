%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script test the analysis on the Rockland sample

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc
% load subList

subList=load('/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/reorder_subjects_gRAICAR126.list');

t=0;
for i=1:length(subList)
    sub=num2str(subList(i));
    sourceDir1=['/home/data/Originals/Rockland/raw/', sub, '/session_1'];
    sourceDir2=['/home/data/Originals/Rockland/raw/', sub, '/session_2'];
    if exist(sourceDir2, 'dir')
        disp(['sub', sub, ' has two resting sessions. session_2 data will be copied.'])
        t=t+1;
        
        mkdir (['/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/', sub, '/FunImg'])
        mkdir (['/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/', sub, '/T1Img'])
        funDir=['/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/', sub, '/FunImg'];
        T1Dir=['/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/', sub, '/T1Img'];
        
        if strcmp(sub, '9006154')
            copyfile ([sourceDir1, '/BOLDrestingCAP_1/BOLDrestingCAP.nii.gz'], funDir)
            copyfile ([sourceDir2, '/MPRAGE_1/defaced_MPRAGE.nii.gz'], T1Dir)
        else
            copyfile ([sourceDir2, '/BOLDrestingCAP_1/BOLDrestingCAP.nii.gz'], funDir)
            if ~exist([sourceDir2, '/MPRAGEshorter_1/defaced_MPRAGEshorter.nii.gz'])
                copyfile ([sourceDir1, '/MPRAGE_1/defaced_MPRAGE.nii.gz'], T1Dir)
            else
                copyfile ([sourceDir2, '/MPRAGEshorter_1/defaced_MPRAGEshorter.nii.gz'], [T1Dir, '/defaced_MPRAGE.nii.gz'])
            end
        end
    else
        
        mkdir (['/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/', sub, '/FunImg'])
        mkdir (['/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/', sub, '/T1Img'])
        funDir=['/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/', sub, '/FunImg'];
        T1Dir=['/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/', sub, '/T1Img'];
        copyfile ([sourceDir1, '/BOLDrestingCAP_1/BOLDrestingCAP.nii.gz'], funDir)
        
        if exist ([sourceDir1, '/MPRAGE_1/defaced_MPRAGE.nii.gz'])
            copyfile ([sourceDir1, '/MPRAGE_1/defaced_MPRAGE.nii.gz'], T1Dir)
        elseif exist ([sourceDir1, '/MPRAGEshorter_1/defaced_MPRAGEshorter.nii.gz'])
            disp(['sub', sub, ' dosen"t have MPRAGE_1 folder. MPRAGEshorter_1 folder file will be copied.'])
            copyfile ([sourceDir1, '/MPRAGEshorter_1/defaced_MPRAGEshorter.nii.gz'], [T1Dir, '/defaced_MPRAGE.nii.gz'])
        end
    end
end


clear
clc
% load subList

subList=load('/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/reorder_subjects_gRAICAR126.list');
%subList=1013090
for i=1:length(subList)
    sub=num2str(subList(i));
    sourceDir=['/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/', sub, '/FunImg'];
    mkdir (['/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/FunImg/', sub])
    destinationDir=['/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/FunImg/', sub];
    copyfile([sourceDir, '/BOLDrestingCAP.nii.gz'], destinationDir)
end