% This script extract ROI mean values for each measure and concate ROImean across all measures
clear
clc
close all


measureList={'TotTSep_DS_TotT_demean_ROI1', 'fullModel_DS_FT_demean_ROI1', 'fullModel_DS_BT_demean_ROI1'};
subList=load('/home/data/Projects/Zhen/workingMemory/mask/subjectList_Num_68sub.txt');
numSub=length(subList);
numClusters=zeros(length(measureList), 2);
% load subList

outputDir=['/home/data/Projects/Zhen/workingMemory/results/CPAC_12_16_13/groupAnalysis/noGSR/ROImeans/'];
clustMeanConcate=[];

for i=1:length(measureList)
    measure=measureList{i}
    
    if strcmp(measure(1:4), 'TotT') || strcmp(measure(14:15), 'FT')
        T='T2';
    else
        T='T3';
    end
    
        mask=['/home/data/Projects/Zhen/workingMemory/mask/CPAC_12_16_13/noGSR/stdMask_68sub_3mm_100percent.nii'];
   
    
    % load the full brain mask
    
    [MaskData,VoxDimMask,HeaderMask]=rest_readfile(mask);
    % MaskData=rest_loadmask(nDim1, nDim2, nDim3, [maskDir,'stdMask_fullBrain_68sub_90percent.nii']);
    MaskData =logical(MaskData);%Revise the mask to ensure that it contain only 0 and 1
    MaskDataOneDim=reshape(MaskData,[],1)';
    MaskIndex = find(MaskDataOneDim);
    
    
    file=['/home/data/Projects/Zhen/workingMemory/results/CPAC_12_16_13/groupAnalysis/noGSR/CWAS3mmSmallMask/followUpFC_meanRegress/', measure, '_AllVolume_meanRegress.nii'];
       
    
    [AllVolume,VoxelSize,theImgFileList, Header] =rest_to4d(file);
    
    % reshape the data read in and mask out the regions outside of the brain
    [nDim1,nDim2,nDim3,nSub]=size(AllVolume);
    AllVolume=reshape(AllVolume,[],nSub)';
    AllVolume=AllVolume(:, MaskIndex);
    
    % exatract the ROI mean for neg clusters
    
        maskFileNeg=['/home/data/Projects/Zhen/workingMemory/results/CPAC_12_16_13/groupAnalysis/noGSR/CWAS3mmSmallMask/followUpFC_meanRegress/easythresh/cluster_mask_', measure, '_', T, '_Z_neg.nii.gz'];
    
    
    [OutdataNegROI,VoxDimNegROI,HeaderNegROI]=rest_readfile(maskFileNeg);
    [nDim1NegROI nDim2NegROI nDim3NegROI]=size(OutdataNegROI);
    NegROI1D=reshape(OutdataNegROI, [], 1)';
    NegROI1D=NegROI1D(1, MaskIndex);
    numNegClust=length(unique(NegROI1D(find(NegROI1D~=0))))
    numClusters(i, 1)=numNegClust;
    
    clustMeanNeg=zeros(numSub, numNegClust);
    for j=1:numNegClust
        ROI=AllVolume(:, find(NegROI1D==j));
        avg=mean(ROI, 2);
        clustMeanNeg(:, j)=avg;
    end
    
    % extract the ROI mean for pos clusters
    
        maskFilePos=['/home/data/Projects/Zhen/workingMemory/results/CPAC_12_16_13/groupAnalysis/noGSR/CWAS3mmSmallMask/followUpFC_meanRegress/easythresh/cluster_mask_', measure, '_', T, '_Z_pos.nii.gz']
    
    
    [OutdataPosROI,VoxDimPosROI,HeaderPosROI]=rest_readfile(maskFilePos);
    [nDim1PosROI nDim2PosROI nDim3PosROI]=size(OutdataPosROI);
    PosROI1D=reshape(OutdataPosROI, [], 1)';
    PosROI1D=PosROI1D(1, MaskIndex);
    numPosClust=length(unique(PosROI1D(find(PosROI1D~=0))))
    numClusters(i,2)=numPosClust;
    
    clustMeanPos=zeros(numSub, numPosClust);
    for k=1:numPosClust
        ROI=AllVolume(:, find(PosROI1D==k));
        avg=mean(ROI, 2);
        clustMeanPos(:, k)=avg;
    end
    
    clustMean=[clustMeanNeg, clustMeanPos];
    clustMeanConcate=[clustMeanConcate, clustMean];
end

totNumClusters=sum(numClusters(:,1))+sum(numClusters(:, 2))
save([outputDir, 'ROImeanMDMR_total', num2str(totNumClusters), 'clusters_', num2str(numSub), 'sub.txt'],'-ascii','-double','-tabs', 'clustMeanConcate')

%save([outputDir, 'numClustersEachMeasure.txt'],'-ascii', '-tabs', 'numClusters')


