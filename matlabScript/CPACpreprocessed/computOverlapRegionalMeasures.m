% This script is for compte the overlap across dif strategeis for CWAS results

clear
clc
close all

% define path and variables
subList=load(['/home/data/Projects/Zhen/workingMemory/mask/subjectList_Num_68sub.txt'])
numSub=length(subList)
figDir='/home/data/Projects/Zhen/workingMemory/figs/paper_figs/compStrategies/strategyOverlap/pie/'
metric='VMHC'  %DegreeCentrality ReHo fALFF VMHC(maxOverlapstrategy=2)
strategyList={'meanRegress', 'compCor', 'GSR', 'gCor', 'noGSR'}

% read in the mask file and reshape to 1D
maskFile=['/home/data/Projects/Zhen/workingMemory/mask/CPAC_1_1_14/noGSR/autoMask_68sub_90percent.nii']
[OutdataMask,VoxDimMask,HeaderMask]=rest_readfile(maskFile);
[nDim1Mask nDim2Mask nDim3Mask]=size(OutdataMask);
maskImg1D=reshape(OutdataMask, [], 1);
maskIndx=find(maskImg1D);

% read in the ageByFT effect file and binarize into a mask
for i=1:length(strategyList)
    strategy=num2str(strategyList{i});
    
    %fileName=['/home/data/Projects/Zhen/workingMemory/figs/paper_figs/compStrategies/', strategy, '/thresh_', metric, '_Full_T4_Z_cmb.nii']
fileName=['/home/data/Projects/Zhen/workingMemory/figs/paper_figs/compStrategies/', strategy, '/strategyOverlap/thresh_', metric, '_Full_T4_Z_cmb_L.nii']    

    [Outdata,VoxDim,Header]=rest_readfile(fileName);
    [nDim1 nDim2 nDim3]=size(Outdata);
    img1D=reshape(Outdata, [], 1);
    img1D=img1D(maskIndx);
    img1D=logical(img1D);
    imgAllStrategies(:, i)=img1D;
end

% find the voxels commonly significant for all strategies
imgAllStrategies=imgAllStrategies';
commonSigVox=sum(imgAllStrategies)';
numVoxCommon=length(find(commonSigVox));

% compute the percentage of significant voxels
prctCommon=zeros(length(strategyList),1);

for i=1:length(strategyList)
    prctCommon(i,1)=length(find(commonSigVox==i))/numVoxCommon;
end

colorMap=[106, 196, 255; 106, 90, 205; 230, 123, 184; 228, 108, 10; 225, 227, 0]; %; 102, 60, 123
%colorMap=[0, 0, 255; 0, 128, 0; 128, 0, 128; 255, 0, 0; 225, 255, 0]
colorMap=colorMap/255;
% pie plot the percentage
%labels={'1', '2', '3', '4', '5'}
figure(1)
%h=pie(prctCommon, labels)
h=pie(prctCommon)
hp = findobj(h, 'Type', 'patch');
set(hp(1), 'FaceColor', colorMap(1,:));
set(hp(2), 'FaceColor', colorMap(2,:));
%set(hp(3), 'FaceColor', colorMap(3,:));
%set(hp(4), 'FaceColor', colorMap(4,:));
if length(hp)==5;
    set(hp(5), 'FaceColor', colorMap(5,:));
end
set(h, 'LineWidth', 0.1)
saveas(figure(1),[figDir, metric, '_prctSigCommon.png'])

%write common regions to img
% final=zeros(size(maskImg1D));
% final(maskIndx, 1)=commonSigVox;
% final=reshape(final,nDim1Mask, nDim2Mask, nDim3Mask);
%
% Header.pinfo = [1;0;0];
% Header.dt    =[16,0];
%
% outName=[figDir, metric, '_sigVoxCommon.nii'];
% rest_Write4DNIfTI(final,Header,outName)







