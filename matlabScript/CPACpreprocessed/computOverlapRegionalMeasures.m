% This script is for compte the overlap across dif strategeis for CWAS results

clear
clc
close all

% define path and variables
subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt'])
numSub=length(subList)
figDir='/home/data/Projects/workingMemory/figs/CPAC_1_1_14/'
metric='fALFF'  %DegreeCentrality ReHo fALFF
strategyList={'meanRegress', 'gCor', 'compCor', 'GSR','noGSR'}

% read in the mask file and reshape to 1D
maskFile=['/home/data/Projects/workingMemory/mask/CPAC_1_1_14/noGSR/autoMask_68sub_90percent.nii']
[OutdataMask,VoxDimMask,HeaderMask]=rest_readfile(maskFile);
[nDim1Mask nDim2Mask nDim3Mask]=size(OutdataMask);
maskImg1D=reshape(OutdataMask, [], 1);
maskIndx=find(maskImg1D);

% read in the ageByFT effect file and binarize into a mask
for i=1:length(strategyList)
    covType=num2str(strategyList{i});
    fileName=['/home/data/Projects/workingMemory/results/CPAC_1_1_14/groupAnalysis/', covType, '/', metric, '/easythresh/cmb/thresh_', metric, '_Full_T4_Z_cmb.nii'] 
    
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
meanRegressSigVox=commonSigVox.*imgAllStrategies(2,:)';
numVoxCommon=length(find(commonSigVox));
numVoxMeanRegress=length(find(meanRegressSigVox));

% compute the percentage of significant voxels
prctCommon=zeros(length(strategyList),1);
prctMeanRegress=zeros(length(strategyList),1);
for i=1:length(strategyList)
    prctCommon(i,1)=length(find(commonSigVox==i))/numVoxCommon;
    prctMeanRegress(i,1)=length(find(meanRegressSigVox==i))/numVoxMeanRegress;
end

colorMap=[64, 224, 208; 106, 90, 205; 30, 144, 255; 255, 255, 0; 220, 20, 60];
colorMap=colorMap/255;
% pie plot the percentage
labels={'1', '2', '3', '4', '5'}
figure(1)
h=pie(prctCommon, labels)
hp = findobj(h, 'Type', 'patch');
set(hp(1), 'FaceColor', colorMap(1,:));
set(hp(2), 'FaceColor', colorMap(2,:));
set(hp(3), 'FaceColor', colorMap(3,:));
set(hp(4), 'FaceColor', colorMap(4,:));
if length(hp)==5;
set(hp(5), 'FaceColor', colorMap(5,:));
end
saveas(figure(1),[figDir, metric, '_prctSigCommon.png'])
figure(2)
h1=pie(prctMeanRegress, labels)
hp1 = findobj(h1, 'Type', 'patch');
set(hp1(1), 'FaceColor', colorMap(1,:));
set(hp1(2), 'FaceColor', colorMap(2,:));
set(hp1(3), 'FaceColor', colorMap(3,:));
set(hp1(4), 'FaceColor', colorMap(4,:));
if length(hp)==5;
set(hp1(5), 'FaceColor', colorMap(5,:));
end
saveas(figure(2),[figDir, metric, '_prctSigMeanRegress.png'])

%write common regions to img
final=zeros(size(maskImg1D));
final(maskIndx, 1)=commonSigVox;
final=reshape(final,nDim1Mask, nDim2Mask, nDim3Mask);

Header.pinfo = [1;0;0];
Header.dt    =[16,0];

outName=[figDir, metric, '_sigVoxCommon.nii'];
rest_Write4DNIfTI(final,Header,outName)

% write compCor unique regions to img
meanRegress=zeros(size(maskImg1D));
meanRegress(maskIndx, 1)=meanRegressSigVox;
meanRegress=reshape(meanRegress,nDim1Mask, nDim2Mask, nDim3Mask);

Header.pinfo = [1;0;0];
Header.dt    =[16,0];

outName=[figDir, metric, '_sigVoxMeanRegress.nii'];
rest_Write4DNIfTI(meanRegress,Header,outName)





