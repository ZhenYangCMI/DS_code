% This script is for compte the overlap across dif strategeis

clear
clc
close all

% define path and variables
subList=load(['/home/data/Projects/Zhen/workingMemory/mask/subjectList_Num_68sub.txt'])
numSub=length(subList)
figDir='/home/data/Projects/Zhen/workingMemory/figs/paper_figs/compStrategies/strategyOverlap/pie/'
numStrategies=5;

fileName=['/home/data/Projects/Zhen/workingMemory/figs/paper_figs/compStrategies/strategyOverlap/VMHC_overlap_strategies_L.nii']


[Outdata,VoxDim,Header]=rest_readfile(fileName);
[nDim1 nDim2 nDim3]=size(Outdata);
img1D=reshape(Outdata, [], 1);


% find the voxels commonly significant for all strategies
numVoxCommon=length(find(img1D));

% compute the percentage of significant voxels
prctCommon=zeros(numStrategies,1);

for i=1:numStrategies
    prctCommon(i,1)=length(find(img1D==i))/numVoxCommon;
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

set(h, 'LineWidth', 0.1)
saveas(figure(1),[figDir, metric, '_prctSigCommon.png'])








