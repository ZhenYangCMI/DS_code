
clear
clc
close all

ROImaskGroup='adoles_BT'
groupList={'child_BT', 'adoles_BT'};
numSub=23;
numRef=numSub;
dataDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/'];
figDir='/home2/data/Projects/workingMemory/figs/CWAS/46sub/correlDSFullBrainFC/scatterplot/';
numGroup=length(groupList);

RAllRef=zeros(numRef, numGroup);
PAllRef=zeros(numRef, numGroup);
RHOAllRef=zeros(numRef, numGroup);
PVALAllRef=zeros(numRef, numGroup);

for j=1:numGroup
    group=char(groupList{j})
    
    for i=1:numRef
        % asign FC and covariate value
        FC=load([dataDir, 'correlDSAndFullBrainFC/standFullBrainFC_', ROImaskGroup, 'Mask_', group, '_subgroup.txt']);
        npFile=load(['/home2/data/Projects/workingMemory/data/CWAS23', group, 'NP.mat'])
        npData=npFile.([group, 'NP']);
        DS_BT=npData(:, 3);
        covariates=npData(:, 4:6);
        FCRef=FC(:,i)
        
        % remove the ref sub
        rowRmv=find(FCRef==1)
        FCRef(rowRmv)=[];
        DS_BT(rowRmv)=[];
        covariates(rowRmv, :)=[]
        [R p]=corrcoef(FCRef, DS_BT);
        [RHO,PVAL] = partialcorr(FCRef, DS_BT, covariates)
        RAllRef(i, j)=R(1,2);
        pAllRef(i, j)=p(1,2);
        RHOAllRef(i, j)=RHO;
        PVAlAllRef(i, j)=PVAL
    end
    
    %     figure(1)
    %         scatter(FCRef, DS_BT)
    %     lsline
    %     axis([-0.2 1.2 4 20])
    %saveas(figure(1), [figDir, ROImaskGroup, 'Mask_,', group, 'Subgroup.png'])
    
end

subID=1:numRef;
for k=1:numGroup
    figure(k)
    plot(subID, RHOAllRef(:,k))
     ylim([-0.8 0.8])
end

figure
boxplot(FC, 'whisker', 3)
figure
boxplot(DS_BT, 'whisker', 3)