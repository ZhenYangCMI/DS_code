% This script is for compte the overlap across dif strategeis for CWAS results

clear
clc
close all

% define path and variables
subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt'])
numSub=length(subList)
figDir='/home/data/Projects/workingMemory/figs/cmpStrategies/'
metric='CWAS'
strategyList={'noGSR', 'compCor', 'GSR', 'gCor'}

% read in the mask file and reshape to 1D
maskFile=['/home/data/Projects/workingMemory/mask/CWAS_68sub_compCor/stdMask_68sub_100percent.nii']
[OutdataMask,VoxDimMask,HeaderMask]=rest_readfile(maskFile);
[nDim1Mask nDim2Mask nDim3Mask]=size(OutdataMask);
maskImg1D=reshape(OutdataMask, [], 1);
maskIndx=find(maskImg1D);

% read in the ageByFT effect file and binarize into a mask
for i=1:length(strategyList)
    covType=num2str(strategyList{i});
    fileName=['/home/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/CWAS68sub/fullModelLinearFWHM8.mdmr/thresh_ageByFTdemean.nii.gz']
    
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
compCorSigVox=commonSigVox.*imgAllStrategies(2,:)';
numVoxCommon=length(find(commonSigVox));
numVoxCompCor=length(find(compCorSigVox));

% compute the percentage of significant voxels
prctCommon=zeros(length(strategyList),1);
prctCompCor=zeros(length(strategyList),1);
for i=1:length(strategyList)
    prctCommon(i,1)=length(find(commonSigVox==i))/numVoxCommon;
    prctCompCor(i,1)=length(find(compCorSigVox==i))/numVoxCompCor;
end

% pie plot the percentage
labels={'1', '2', '3', '4'}
figure(1)
pie(prctCommon, labels)
saveas(figure(1),[figDir, metric, '_prctSigCommon.png'])
figure(2)
pie(prctCompCor, labels)
saveas(figure(2),[figDir, metric, '_prctSigCompCor.png'])

% write common regions to img
final=zeros(size(maskImg1D));
final(maskIndx, 1)=commonSigVox;
final=reshape(final,nDim1Mask, nDim2Mask, nDim3Mask);

Header.pinfo = [1;0;0];
Header.dt    =[16,0];

outName=[figDir, metric, '_sigVoxCommon.nii'];
rest_Write4DNIfTI(final,Header,outName)

% write compCor unique regions to img
compCor=zeros(size(maskImg1D));
compCor(maskIndx, 1)=compCorSigVox;
compCor=reshape(compCor,nDim1Mask, nDim2Mask, nDim3Mask);

Header.pinfo = [1;0;0];
Header.dt    =[16,0];

outName=[figDir, metric, '_sigVoxCompCor.nii'];
rest_Write4DNIfTI(compCor,Header,outName)





