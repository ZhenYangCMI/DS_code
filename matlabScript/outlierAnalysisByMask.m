
close all
clear
clc
configPath='/home2/data/Projects/workingMemory/mask/'
subList=load([configPath, 'subjectList_Num_46sub.txt']);
numSub=length(subList);
mask='/home2/data/Projects/workingMemory/mask/meanFunMask0.9_46sub.nii';
CPACDir='/home2/data/Projects/workingMemory/results/CPAC_analysis/output/sym_links/pipeline_HackettCity/linear1.wm1.global1.motion1.quadratic1.csf1_CSF_0.98_GM_0.7_WM_0.96/';

% mask='/home2/data/Projects/workingMemory/mask/meanFunMask_DPARSF_46sub_RPI_90pct.nii';
% DPARSFDir='/home2/data/Projects/workingMemory/data/DPARSF_analysis/Masks/reoriented/';


[Outdata,VoxDim,Header]=rest_readfile(mask);

pctAllSub=zeros(numSub, 1);
for i=1:numSub
    sub=subList(i)
    %subFunMask=[DPARSFDir, filesep, num2str(sub),'_BrainMask_05_91x109x91_RPI.nii'];
    subFunMask=[CPACDir,'/sub', num2str(sub), '/scan_rest_1_rest/func/functional_brain_mask_to_standard.nii.gz'];
    [Outdata1,VoxDim1,Header1]=rest_readfile(subFunMask);
    mask1D=reshape(Outdata, [],1);
    subFunMask1D=reshape(Outdata1,[],1);
    a=mask1D.*subFunMask1D;
    overlap=size(find(a~=0), 1);
    pct=overlap/size(find(Outdata~=0),1);
    pctAllSub(i,1)=pct;
end

pctAllSub
boxplot(pctAllSub, 'whisker', 3)
