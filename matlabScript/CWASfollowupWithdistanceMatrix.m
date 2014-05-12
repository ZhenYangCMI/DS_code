% % This script applies for a mask with multiple clsuters.Compute the distance matrix for each cluster

clear
clc
close all
numSub=68;
covType='compCor'
corrType='spearman';

effect='FT'  % can be 'ageByFT' or 'FT'
if strcmp(effect, 'ageByFT')
    numSeed=1;
else
    numSeed=2;
end

outputDir= ['/home/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/CWAS68sub/fullModelLinearFWHM8.mdmr/followup/distanceMatrix/'];
figDir=['/home/data/Projects/workingMemory/figs/CWAS_', covType, '/' ];

maskFile=['/home2/data/Projects/workingMemory/mask/CWAS_68sub_noGSR/stdMask_68sub_100percent.nii']
[OutdataMask,VoxDimMask,HeaderMask]=rest_readfile(maskFile);
[nDim1Mask nDim2Mask nDim3Mask]=size(OutdataMask);
maskImg1D=reshape(OutdataMask, [], 1);

%if strcmp(effect, 'ageByFT')
    subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt']);
% else
%     subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_sortedByFT.txt']);
% end
%subList=[3134 4711]
numSub=length(subList);

for k=1:numSeed
    seed=num2str(k)
    
    ROHAllSub=zeros(numSub, numSub);
    for i=1:numSub
        sub=num2str(subList(i))
        if numSeed==1 % the agexFT effect only has one cluster significant, the main effect of FT has two cluster sig
            FileName=['/home/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/CWAS68sub/fullModelLinearFWHM8.mdmr/followup/z', covType, '_FC_ROIageByFT', sub, '.nii']
        else
            FileName=['/home/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/CWAS68sub/fullModelLinearFWHM8.mdmr/followup/zROI',seed, covType, '_FC_ROIFT', sub, '.nii']
        end
        
        [Outdata,VoxDim,Header]=rest_readfile(FileName);
        [nDim1 nDim2 nDim3]=size(Outdata);
        img1D=reshape(Outdata, [], 1);
        img1D=img1D(find(maskImg1D==1));
        imgAllSub(:, i)=img1D;
    end
    meanImg=mean(imgAllSub, 2);
    [r, p]=corr(imgAllSub, 'type', corrType);
    dist=1-r;
    
    [r2,p2]=corr(meanImg, imgAllSub, 'type', corrType);
    r2=r2';
    dist2=1-r2;
    %     figure(1)
    %     h=plot(dist2)
    % set(h, 'LineWidth', 2)
    %    saveas(figure(1), [figDir, 'distWithMeanFullBrainConnection',seed, '_', corrType, '_', effect, '.png'])
    
%     centrality=sum(dist)/(numSub-1)
%     figure(2)
%     
%     h=plot(centrality)
%     set(h, 'LineWidth', 2)
%     saveas(figure(2), [figDir, 'centrality',seed, '_', corrType, '_', effect, '.png'])
    
    NP=load(['/home/data/Projects/workingMemory/data/modelOtherMetrics68sub.txt']);
    FT=NP(:,8);
    BT=NP(:,9);
    
%     figure(k)
%     scatter(dist2(1:34, 1), FT(1:34, 1), 100, 'b', 'fill')
%     h1=lsline
%     set(h1, 'color','b','LineWidth', 2)
%     axis([0.1 0.9 -10 10])
%     hold on
%     scatter(dist2(35:68, 1), FT(35:68, 1), 100, 'r', 'fill')
%     h2=lsline
%     set(h2, 'color', 'r', 'LineWidth', 2)
%     axis([0.1 0.9 -10 10])
%     saveas(figure(k), [figDir, 'scatterDSdist',seed, '_', corrType, '_', effect, '.png'])
    
    figure(k)
        scatter(dist2(1:68, 1), FT(1:68, 1), 100, 'b', 'fill')
        h1=lsline
        set(h1, 'color','b', 'LineWidth', 2)
        axis([0.1 0.9 -10 10])
    saveas(figure(k), [figDir, 'scatterDSdistclust',seed, '_', corrType, '_', effect, 'AllSub.png'])
    
    % reorder the rows and columns in the correlation matrix
    % the 5, 6, 7 rows are orders for age, FT, and BT separately
%     newOrder=load('/home/data/Projects/workingMemory/data/rank.txt');
%     ageOrder=newOrder(:, 4);
%     FTOrder=newOrder(:, 5);
%     BTOrder=newOrder(:, 6);
%     
%     dataPlot=zeros(numSub, numSub);
%     % reorder rows
%     for j=1:numSub
%         m=FTOrder(j)
%         dataPlot(m, :)=dist(j, :);
%     end
    %
    %         %     if numSeed==2
    %         for j=1:numSub
    %             n=FTOrder(j)
    %             dataPlot(:,n )=dist(:, j);
    %         end
    %     end
    %
    %         figure(k+1)
    %         imagesc(dist)
    %         colorbar
    %         caxis([0.3 1])
    %         cmap=flipdim(jet(36),1);
    %         cmap=cmap(1:14, :);
    %         colormap(cmap)
    %         title([covType, 'clust', seed])
    %                     xlabel('sub sorted by age: low to high')
    %
    %         ylabel('sub sorted by age: low to high')
    %         saveas(figure(k+1), [figDir, 'distMatrixClust',seed, '_', corrType, '_', effect, 'ageSorted.png'])
end

