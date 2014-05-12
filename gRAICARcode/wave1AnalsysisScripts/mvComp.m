% organize the ica components for normaliation
clear
clc

subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt']);
%sub=num2str([3115])
numSub=length(subList)

% copy the component to DPARSFA analysis folder
for i=1:numSub
    sub=num2str(subList(i))
    mkdir ([ '/home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/dualRegressPreprocess/', sub])
    destination=['/home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/dualRegressPreprocess/', sub, '/']
    copyfile(['/home/data/Projects/workingMemory/data/DPARSFanalysis/noGSR/FunImgARCF/', sub, 'Filtered_4DVolume.nii'], destination); 
end

% copy the normalized component back to gRAICAR folder
for i=1:numSub
    sub=num2str(subList(i))
    source=['/home/data/Projects/workingMemory/data/DPARSFanalysis/varNormCompW/', sub, '/']
    %mkdir (['/home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub', sub, '/rest_1_FunImgARCFS/ICA/melodic_autoDim/archive'])
    movefile([source, 'wmelodic_IC.nii'], ['/home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub', sub, '/rest_1_FunImgARCFS/ICA_gms/melodic_autoDim/']); 
    %movefile(['/home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub', sub, '/rest_1_FunImgARCF/ICA/melodic_autoDim/melodic_IC.nii.gz'], ['/home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub', sub, '/rest_1_FunImgARCF/ICA/melodic_autoDim/archive/']);
end
