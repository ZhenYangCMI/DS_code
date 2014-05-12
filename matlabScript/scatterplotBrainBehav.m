

clear
clc
close all

% define path and variables
covType='GSR'
modelType='fullModel'
%if task=BT, T=T; if task=FT T=T4
task='FT'
T='T4'
metric='DegreeCentrality_PositiveBinarizedSumBrain'  %DegreeCentrality_PositiveBinarizedSumBrain
sign='neg'

subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt'])
numSub=length(subList)
resultDir=['/home/data/Projects/workingMemory/groupAnalysis/zscores/otherMetrics68sub_', covType, '/', modelType, '/linear/', metric, '/'];

% read in the mask file and reshape to 1D
if strcmp(metric, 'DegreeCentrality_PositiveBinarizedSumBrain')
    maskFile=['/home/data/Projects/workingMemory/groupAnalysis/zscores/otherMetrics68sub_', covType, '/', modelType, '/linear/', metric, '_FullBrain/easythresh/cluster_mask/cluster_mask_', metric, '_Full_', T, '_Z_', sign, '.nii.gz']
else
    maskFile=['/home/data/Projects/workingMemory/groupAnalysis/zscores/otherMetrics68sub_', covType, '/', modelType, '/linear/', metric, '/easythresh/cluster_mask/cluster_mask_', metric, '_Full_', T, '_Z_', sign, '.nii.gz']
end
[OutdataMask,VoxDimMask,HeaderMask]=rest_readfile(maskFile);
[nDim1Mask nDim2Mask nDim3Mask]=size(OutdataMask);
maskImg1D=reshape(OutdataMask, [], 1);
numClust=length(unique(maskImg1D(find(maskImg1D~=0))))

% exatract the ROI mean

clustFC=zeros(numSub, numClust);

for i=1:numClust
    clust=num2str(i)
    for j=1:numSub
        sub=num2str(subList(j))
        if strcmp(metric, 'DegreeCentrality_PositiveBinarizedSumBrain')
            FileName=['/home/data/Projects/workingMemory/data/DPARSF_analysis/GSR/ResultsWS/DegreeCentralityFullBrain/swz', metric, 'Map_', sub, '.nii' ]
        elseif strcmp(metric, 'skewness')
            FileName=['/home/data/Projects/workingMemory/data/DPARSF_analysis/GSR/Results/', metric, '/sz', metric, 'Map_', sub, '.nii' ]
        else
            FileName=['/home/data/Projects/workingMemory/data/DPARSF_analysis/GSR/ResultsWS/', metric, '/swz', metric, 'Map_', sub, '.nii' ]
        end
        [Outdata,VoxDim,Header]=rest_readfile(FileName);
        [nDim1 nDim2 nDim3]=size(Outdata);
        img1D=reshape(Outdata, [], 1);
        img1DROI=img1D(find(maskImg1D==i));
        avg=mean(img1DROI);
        clustFC(j,i)=avg;
    end
end

% plot scatterplot
figDir='/home/data/Projects/workingMemory/figs/zscores/otherMetrics68sub_GSR/fullModel/'
NP=load(['/home/data/Projects/workingMemory/data/modelOtherMetrics68sub.txt']);

if strcmp(task, 'FT')
    NPcol=3
elseif strcmp(task, 'BT')
    NPcol=4
end
DS=NP(:, NPcol)

groupList={'child', 'adoles'}

numSubPerGroup=34
t=0;

for i=1:numClust
    for k=1:length(groupList)
        group=char(groupList{k})
        [rho,pval] = partialcorr(clustFC(1+(k-1)*numSubPerGroup:k*numSubPerGroup, i), NP(1+(k-1)*numSubPerGroup:k*numSubPerGroup, NPcol), NP(1+(k-1)*numSubPerGroup:k*numSubPerGroup, 14:16))
        [r,p] = corrcoef(clustFC(1+(k-1)*numSubPerGroup:k*numSubPerGroup, i), NP(1+(k-1)*numSubPerGroup:k*numSubPerGroup, NPcol))
        figure(1)
        t=t+1
        subplot(2,2,t)
        scatter(clustFC(1+(k-1)*numSubPerGroup:k*numSubPerGroup, i), DS(1+(k-1)*numSubPerGroup:k*numSubPerGroup, 1))
        lsline
        xlim([-0.5 0.5])
        ylim([0 20])
        title([group, 'Clust', num2str(i)])
        saveas(figure(1), [figDir, metric, 'fullModelageBy', task, sign,num2str(numClust), 'clusters.png'])
    end
end




