clear
clc

subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt']);
%subList=subList.SubID;
numSub=length(subList);

PCNum=5;
IsNeedDetrend=0;
Band=[0.01 0.1];
TR=0.645;

for i=1:numSub
sub=num2str(subList(i))
ADataDir=['/home/data/Projects/workingMemory/data/DPARSF_analysis/FunImgAR/', sub];
Nuisance_MaskFilename=['/home/data/Projects/workingMemory/data/DPARSF_analysis/noGSR/Masks/', sub, '_CsfWhiteMask_91x109x91'];
OutputName=['/home/data/Projects/workingMemory/data/DPARSF_analysis/compCorPC/', sub, '_', num2str(PCNum), 'componets.txt'];
[PCs] = y_Compcor_PC(ADataDir,Nuisance_MaskFilename, OutputName, PCNum, IsNeedDetrend, Band, TR);
end