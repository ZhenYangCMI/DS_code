

clear
clc
close all

% define path and variables
covType='GSR'
standType='zscores'
modelType='fullModel'
metric='skewness'  % canbe 'DegreeCentrality_PositiveBinarizedSumBrain' or 'ReHo'
%if task=BT, T=T5 B=b5; if task=FT T=T4 B=b4
task='FT'
T='T4'
numBeta=5

sign='neg' % sign 'pos' or 'neg'


subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt'])
numSub=length(subList)
resultDir=['/home/data/Projects/workingMemory/groupAnalysis/', standType, '/otherMetrics68sub_', covType, '/', modelType, '/linear/', metric, '/'];

% read in the mask file and reshape to 1D
if strcmp(metric, 'DegreeCentrality_PositiveBinarizedSumBrain')
    maskFile=['/home/data/Projects/workingMemory/groupAnalysis/', standType, '/otherMetrics68sub_', covType, '/', modelType, '/linear/', metric, '_FullBrain/easythresh/cluster_mask/cluster_mask/cluster_mask_', metric, '_Full_', T, '_Z_', sign, '.nii.gz']
else
    maskFile=['/home/data/Projects/workingMemory/groupAnalysis/', standType, '/otherMetrics68sub_', covType, '/', modelType, '/linear/', metric, '/easythresh/cluster_mask/cluster_mask_', metric, '_Full_', T, '_Z_', sign, '.nii.gz']
end
[OutdataMask,VoxDimMask,HeaderMask]=rest_readfile(maskFile);
[nDim1Mask nDim2Mask nDim3Mask]=size(OutdataMask);
maskImg1D=reshape(OutdataMask, [], 1);
numClust=length(unique(maskImg1D(find(maskImg1D~=0))))


figDir=['/home/data/Projects/workingMemory/figs/', standType, '/otherMetrics68sub_GSR/fullModel/linear/']
NP=load(['/home/data/Projects/workingMemory/data/modelOtherMetrics68sub.txt']);

age=NP(:, 6);
FT=NP(:, 8);
BT=NP(:, 9);
IQ=NP(:, 14);
FD=NP(:, 15);
hand=NP(:, 16);


x1 = linspace(min(age)-1, max(age)+1,100);
x2 = linspace(min(FT)-1, max(FT)+1, 100);
x3 = linspace(min(BT)-1, max(BT)+1, 100);

x4 = linspace(min(IQ)-1, max(IQ)+1,100);
x5 = linspace(min(FD)-1, max(FD)+1, 100);
x6 = linspace(min(hand)-1, max(hand)+1, 100);

x11=repmat(x1, 100,1);
x22=repmat(x2', 1,100);
x33=repmat(x3', 1,100);
x44=repmat(x4, 100,1);
x55=repmat(x5, 100,1);
x66=repmat(x6,100,1);

% exatract the ROI mean beta

clustBeta=zeros(numBeta, numClust);
yfit=zeros(100, 100, numClust);

for i=1:numClust
    clust=num2str(i)
    for j=1:numBeta
        beta=num2str(j)
        if strcmp(metric, 'DegreeCentrality_PositiveBinarizedSumBrain')
            FileName=['/home/data/Projects/workingMemory/groupAnalysis/', standType, '/otherMetrics68sub_GSR/fullModel/linear/', metric, '_FullBrain', '/', metric, '_Full_b', beta, '.nii' ]
        else
            FileName=['/home/data/Projects/workingMemory/groupAnalysis/', standType, '/otherMetrics68sub_GSR/fullModel/linear/', metric, '/', metric, '_Full_b', beta, '.nii' ]
        end
        [Outdata,VoxDim,Header]=rest_readfile(FileName);
        [nDim1 nDim2 nDim3]=size(Outdata);
        img1D=reshape(Outdata, [], 1);
        img1DROI=img1D(find(maskImg1D==i));
        avg=mean(img1DROI);
        clustBeta(j, i)=avg;
    end
    
    % linespace the beta values
    
    for j=1:numBeta
        betaMatrix(:, :, j, i)=repmat(clustBeta(j,i), 100, 100);
    end
    
    % compute the interation term
    
    for m=1:100
        for n=1:100
            ageByFT(n,m, i)=x1(m)*x2(n);
            ageByBT(n,m, i)=x1(m)*x3(n);
            
        end
    end
    
    %yfit=betaMatrix(:,:,1,i).*x11+betaMatrix(:,:,2,i).*x22+betaMatrix(:,:,3,i).*x33+betaMatrix(:,:,4,i).*ageByFT(:,:,i)+betaMatrix(:,:,5,i).*ageByBT(:,:,i);
    
    figure(i)
    if strcmp(task, 'FT')
        yfit=betaMatrix(:,:,1,i).*x11+betaMatrix(:,:,2,i).*x22+betaMatrix(:,:,4,i).*ageByFT(:,:,i);
        pcolor(x1, x2, yfit); shading flat, shading interp;
        hold on
        scatter(age, FT)
    elseif strcmp(task, 'BT')
        yfit=betaMatrix(:,:,1,i).*x11+betaMatrix(:,:,3,i).*x33+betaMatrix(:,:,5,i).*ageByBT(:,:,i);
        pcolor(x1, x3, yfit); shading flat, shading interp;
        hold on
        scatter(age, BT)
    end
    xlabel('Age demean')
    ylabel([task 'demean'])
    title([metric, task, sign, 'cluster', num2str(i)])
    colorbar
    caxis([-0.8 0.8])
%     if strcmp(metric, 'skewness')
%          caxis([-0.25 0.25])
%     end
    saveas(figure(i), [figDir, metric, '_INTageBy', task,  sign, 'cluster', num2str(i), '_', standType, '.png'])
end




