
clear
clc
close all

ROImaskGroup='adoles_BT'
groupList={'adoles_BT'};
numSub=23;
dataDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/'];
figDir='/home2/data/Projects/workingMemory/figs/CWAS/46sub/CWAS_followup/scatterplot/';

for j=1:length(groupList)
    group=char(groupList{j})

    fullBrainFC=load([dataDir, '/DS_standFullBrainFC/standFullBrainFC_', ROImaskGroup, 'Mask_', group, '_subgroup.txt']);
    npFile=load(['/home2/data/Projects/workingMemory/data/CWAS23', group, 'NP.mat'])
        npData=npFile.([group, 'NP']);
            DS_BT=npData(:, 3);
        covariates=npData(:, 4:6); 
        regressors=[ones(size(fullBrainFC)),DS_BT, covariates];
        [R p]=corrcoef(fullBrainFC, DS_BT)
        [b,bint,r,rint,stats]=regress(fullBrainFC, regressors)
    figure(1)
        scatter(fullBrainFC, DS_BT) 
    lsline
    axis([-0.2 1.2 4 20])
    saveas(figure(1), [figDir, ROImaskGroup, 'Mask_,', group, 'Subgroup.png'])
    figure(2)
     [R1 p1]=corrcoef(fullBrainFC(1:end-1), DS_BT(1:end-1))     
     scatter(fullBrainFC(1:end-1), DS_BT(1:end-1)) 
    lsline
    axis([-0.1 0.4 4 20])
    saveas(figure(2), [figDir, ROImaskGroup, 'Mask_,', group, 'Subgroup_wo.png'])
end

figure
boxplot(fullBrainFC, 'whisker', 3)
figure
     boxplot(DS_BT, 'whisker', 3)