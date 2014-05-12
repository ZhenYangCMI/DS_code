% compute the distance matrix for each voxel then average all voxels within a cluster

clear
clc

ROImaskGroup='adoles' 
task='BT'
subGroup='adoles'% can be 'child' or 'adoles'
corrType='pearson';

dataDir='/home/data/Projects/workingMemory/data/DPARSF_analysis/';
outputDir= ['/home/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followUp/correlDSAndFullBrainFC/distanceMatrix/'];
figDir=['/home/data/Projects/workingMemory/figs/CWAS/46sub/distanceMatrix/', corrType, '/'];

maskFile=['/home2/data/Projects/workingMemory/mask/CWAS_newMask/stdMask_46sub_100percent.nii']
[OutdataMask,VoxDimMask,HeaderMask]=rest_readfile(maskFile);
[nDim1Mask nDim2Mask nDim3Mask]=size(OutdataMask);
maskImg1D=reshape(OutdataMask, [], 1);
numVoxMask=length(find(maskImg1D));

ROI=['/home/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/CWAS', ROImaskGroup, '/', task, '.mdmr/cluster_mask_', task, '.nii.gz']
[OutdataROI,VoxDimROI,HeaderROI]=rest_readfile(ROI);
[nDim1ROI nDim2ROI nDim3ROI]=size(OutdataROI);
ROImg1D=reshape(OutdataROI, [], 1);
ROImg1D=ROImg1D(find(maskImg1D==1))';
numVoxROI=length(find(ROImg1D==1));

subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_', subGroup,'_', task '.txt']);

%subList=[3134 4711]
numSub=length(subList);

% compute the FC
RHOAllSub=zeros(numVoxROI, numVoxMask, numSub);
for i=1:numSub
    sub=num2str(subList(i))
    dataFile=[dataDir, 'FunImgARCWFresample/', sub, '/Filtered_4DVolume_4mm_fwhm6_masked.nii']
    
    [AllVolume, VoxelSize, ImgFileList, Header, nVolumn] =rest_to4d(dataFile);
    [nDim1 nDim2 nDim3 nDimTimePoints]=size(AllVolume);
    brainSize = [nDim1 nDim2 nDim3];
    AllVolume=reshape(AllVolume,[],nDimTimePoints);
    AllVolume=AllVolume(find(maskImg1D==1), :)';
    ROITS=AllVolume(:, find(ROImg1D==1));
    [RHO,PVAL] = corr(ROITS,AllVolume);
    RHOAllSub(:, :, i)=RHO;
end

% compute the distance matrix
distAllvox=zeros(numSub, numSub, numVoxROI);
for j=1:numVoxROI
    [r, p]=corr(squeeze(RHOAllSub(j, :, :)), 'type', corrType);
    dist=1-r;
    distAllvox(:, :, j)=dist;
end
distAllvox2D=reshape(distAllvox, [], numVoxROI)';
meanDistROI=mean(distAllvox2D);
meanDistROI2D=reshape(meanDistROI, numSub, numSub);

figure(1)
imagesc(meanDistROI2D)
colorbar
caxis([0.5 1])
cmap=flipdim(jet(36),1)
cmap=cmap(1:14, :)
colormap(cmap)
title([ROImaskGroup,task,'Mask ',subGroup,'subGroup'])
xlabel('sub sorted by DS scores: low to high')
ylabel('sub sorted by DS scores: low to high')
saveas(figure(1), [figDir, 'meanDist_', ROImaskGroup, task,'Mask_', subGroup, 'subGroup_', corrType,'.png'])