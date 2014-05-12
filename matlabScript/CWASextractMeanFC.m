

clear
clc
close all

% define path and variables
covType='GSR'
modelType='fullModel'
gourp='child'

subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt'])
numSub=length(subList)
resultDir=['/home/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/68sub/followup/', modelType, '/avgFC'];

% read in the mask file and reshape to 1D
maskFile=['/home/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/68sub/followup/', modelType, '/CWASDSregressFC/easythresh/cluster_mask_child_ROI1_T1_Z_neg.nii.gz']
[OutdataMask,VoxDimMask,HeaderMask]=rest_readfile(maskFile);
[nDim1Mask nDim2Mask nDim3Mask]=size(OutdataMask);
maskImg1D=reshape(OutdataMask, [], 1);
numClust=length(unique(maskImg1D(find(maskImg1D~=0))))

% exatract the ROI mean FC

clustFC=zeros(numSub, numClust);

for i=1:numClust
    clust=num2str(i)
    for j=1:numSub
        sub=num2str(subList(j))
        FileName=['/home/data/Projects/workingMemory/groupAnalysis/CWAS_GSR/68sub/followup/fullModel/ROI1FC_ROIageByFT', sub, '.nii']
        [Outdata,VoxDim,Header]=rest_readfile(FileName);
        [nDim1 nDim2 nDim3]=size(Outdata);
        img1D=reshape(Outdata, [], 1);
        img1DROI=img1D(find(maskImg1D==i));
        FC=mean(img1DROI);
        clustFC(j,i)=FC;
    end
end

% plot scatterplot
figDir='/home/data/Projects/workingMemory/figs/CWAS_GSR/68sub/fullModelLinearFWHM8/'
NP=load(['/home/data/Projects/workingMemory/data/modelOtherMetrics68sub.txt']);
FT=NP(:, 8)

groupList={'child', 'adoles'}

numSubPerGroup=34
t=0;
for k=1:length(groupList)
    group=char(groupList{k})
    for i=1:numClust
       [rho,pval] = partialcorr(clustFC(1+(k-1)*numSubPerGroup:k*numSubPerGroup, i), NP(1+(k-1)*numSubPerGroup:k*numSubPerGroup, 8), NP(1+(k-1)*numSubPerGroup:k*numSubPerGroup, 14:16))
        [r,p] = corrcoef(clustFC(1+(k-1)*numSubPerGroup:k*numSubPerGroup, i), NP(1+(k-1)*numSubPerGroup:k*numSubPerGroup, 8))
       figure(1)
        t=t+1
        subplot(2,2,t)
        scatter(clustFC(1+(k-1)*numSubPerGroup:k*numSubPerGroup, i), FT(1+(k-1)*numSubPerGroup:k*numSubPerGroup, 1))
        lsline
        xlim([-0.4 0.6])
        title([group, 'Clust', num2str(i)])
    end
end
saveas(figure(1), [figDir, 'CWASfullModelageByFTROI1FCregress.png'])



