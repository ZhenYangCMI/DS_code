

clear
clc
close all

% define path and variables
covType='compCor'
effect='ageByFT'
task='FT'

subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt'])
numSub=length(subList)

if strcmp(effect, 'ageByFT')
    T='T3'
    numBeta=3
    sign='pos'
else
    T='T1'
    numBeta=1
    sign='neg'
end

numClust=2

figDir=['/home/data/Projects/workingMemory/figs/CWAS_compCor']
NP=load(['/home/data/Projects/workingMemory/data/modelOtherMetrics68sub.txt']);

age=NP(:, 6);
FT=NP(:, 8);
BT=NP(:, 9);
ageRaw=NP(:,2);
FTRaw=NP(:, 3);
BTRaw=NP(:, 4);
IQ=NP(:, 14);
FD=NP(:, 15);
hand=NP(:, 16);


x1 = linspace(min(age)-1, max(age)+1,100);
x2 = linspace(min(FT)-1, max(FT)+1, 100);
x3 = linspace(min(BT)-1, max(BT)+1, 100);
x4 = linspace(min(ageRaw)-1, max(ageRaw)+1,100);
x5 = linspace(min(FTRaw)-1, max(FTRaw)+1,100);
x6 = linspace(min(BTRaw)-1, max(BTRaw)+1,100);

x7 = linspace(min(IQ)-1, max(IQ)+1,100);
x8 = linspace(min(FD)-1, max(FD)+1, 100);
x9 = linspace(min(hand)-1, max(hand)+1, 100);

x11=repmat(x1, 100,1);
x22=repmat(x2', 1,100);
x33=repmat(x3', 1,100);
x44=repmat(x4, 100,1);
x55=repmat(x5', 1,100);
x66=repmat(x6', 1,100);

clustBeta=zeros(numBeta, numClust);
yfit=zeros(100, 100, numClust);
betaMatrix=zeros(100, 100, numBeta, numClust);
for i=1:numClust
    clust=num2str(i)
    % read in the mask file and reshape to 1D
    maskFile=['/home/data/Projects/workingMemory/groupAnalysis/CWAS_', covType,'/CWAS68sub/fullModelLinearFWHM8.mdmr/followup/CWASregress/easythresh/cluster_mask_', effect, '_ROI1_', T, '_Z_', sign, '.nii.gz']
    
    [OutdataMask,VoxDimMask,HeaderMask]=rest_readfile(maskFile);
    [nDim1Mask nDim2Mask nDim3Mask]=size(OutdataMask);
    maskImg1D=reshape(OutdataMask, [], 1);
    numClust=length(unique(maskImg1D(find(maskImg1D~=0))))
    
    
    % exatract the ROI mean beta
    for j=1:numBeta
        beta=num2str(j)
        
        FileName=['/home/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/CWAS68sub/fullModelLinearFWHM8.mdmr/followup/CWASregress/', effect, 'ROI1_b', beta, '.nii' ]
        
        [Outdata,VoxDim,Header]=rest_readfile(FileName);
        [nDim1 nDim2 nDim3]=size(Outdata);
        img1D=reshape(Outdata, [], 1);
        img1DROI=img1D(find(maskImg1D==i));
        avg=mean(img1DROI);
        clustBeta(j, i)=avg;
    end
end
% linespace the beta values
for i=1:numClust
    clust=num2str(i)
    for j=1:numBeta
        betaMatrix(:, :, j, i)=repmat(clustBeta(j,i), 100, 100);
    end
    
    % compute the interation term
    
    for m=1:100
        for n=1:100
            ageByFT(n,m)=x44(n,m)*x55(n,m);
            ageByBT(n,m)=x44(n,m)*x66(n,m);
        end
    end
    
    ageByFTdemean=ageByFT-mean(mean(ageByFT));
    
    figure(i)
    yfit=betaMatrix(:,:,1,i).*x11+betaMatrix(:,:,2,i).*x22+betaMatrix(:,:,3,i).*ageByFTdemean;

    pcolor(x1, x2, yfit); shading flat, shading interp;
    hold on
    scatter(age, FT)
    xlabel('Age demean')
    ylabel('DS FT')
    title(['CWAS ', effect ' ROI', clust])
    colorbar
    caxis([-500 500])
    saveas(figure(i), [figDir, 'CWAS_', effect '_ROI', clust, '.png'])
end





