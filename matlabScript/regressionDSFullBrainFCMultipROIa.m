
clear
clc
close all

ROImaskGroup='child_BT'
groupList={'child_BT'};
numSub=23;
dataDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/'];
figDir='/home2/data/Projects/workingMemory/figs/CWAS/46sub/CWAS_followup/scatterplot/';
if strcmp(ROImaskGroup, 'child_BT')
    numSeed=2
    groupList={'child_BT', 'adoles_BT'};
elseif strcmp(ROImaskGroup, 'child_FT')
    numSeed=4
    groupList={'child_FT', 'adoles_FT'};
end

for j=1:length(groupList)
    group=char(groupList{j})
    npFile=load(['/home2/data/Projects/workingMemory/data/CWAS23', group, 'NP.mat'])
    npData=npFile.([group, 'NP']);
    DS_BT=npData(:, 3);
    
    
    for i=1:numSeed
        seed=num2str(i);
        
        fullBrainFC=load([dataDir, '/DS_standFullBrainFC/standFullBrainFC_', ROImaskGroup, 'Mask_', group, '_subgroup.txt']);
        
        [R p]=corrcoef(fullBrainFC(:, i), DS_BT)
        
        
        figure(1)
        scatter(fullBrainFC(:,i), DS_BT)
        lsline
        axis([-0.2 1.2 4 20])
%         saveas(figure(1), [figDir, ROImaskGroup, 'Mask_,', group, 'Subgroup_ROI', seed, '.png'])
        
        figure(2)
        [R1 p1]=corrcoef(fullBrainFC(1:end-1, i), DS_BT(1:end-1))
        covariates=npData(1:end-1, 4:6);
        regressors=[ones(size(fullBrainFC,1)-1,1),DS_BT(1:end-1), covariates];
        %         [b,bint,r,rint,stats]=regress(fullBrainFC(:,i), regressors)
        scatter(fullBrainFC(1:end-1, i), DS_BT(1:end-1))
        lsline
        axis([-0.1 0.4 4 20])
%         saveas(figure(2), [figDir, ROImaskGroup, 'Mask_,', group, 'Subgroup_ROI', seed, 'wo.png'])
        
    end
           figure
        boxplot(fullBrainFC, 'whisker', 3)
        figure
        boxplot(DS_BT, 'whisker', 3)
end

