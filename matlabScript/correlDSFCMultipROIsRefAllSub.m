% this script is for child_FT and child_BT seed which have more than one ROIs

clear
clc
close all

ROImaskGroup='child_FT'
numSub=23;
numRef=numSub;
if strcmp(ROImaskGroup, 'child_BT')
    numSeed=2
    groupList={'child_BT', 'adoles_BT'};
elseif strcmp(ROImaskGroup, 'child_FT')
    numSeed=4
    groupList={'child_FT', 'adoles_FT'};
end
dataDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/'];
figDir='/home2/data/Projects/workingMemory/figs/CWAS/46sub/correlDSFullBrainFC/scatterplot/';
numGroup=length(groupList);

RAllRef=zeros(numRef, numSeed, numGroup);
PAllRef=zeros(numRef, numSeed, numGroup);
RHOAllRef=zeros(numRef, numSeed, numGroup);
PVALAllRef=zeros(numRef, numSeed, numGroup);

for j=1:length(groupList)
    group=char(groupList{j})
    
    for i=1:numSeed
        seed=num2str(i)
        
        for k=1:numRef
            % asign FC and covariate value
            FC=load([dataDir, 'correlDSAndFullBrainFC/standFullBrainFC_', ROImaskGroup, 'Mask_', group, '_subgroup.mat']);
            FC=FC.correl;
            npFile=load(['/home2/data/Projects/workingMemory/data/CWAS23', group, 'NP.mat'])
            npData=npFile.([group, 'NP']);
            DS=npData(:, 3); % DS can be FT or BT depends on which NP file was loaded
            covariates=npData(:, 4:6);
            FCRef=squeeze(FC(:,i, k));
            
            % remove the ref sub
            rowRmv=find(FCRef==1)
            FCRef(rowRmv)=[];
            DS(rowRmv)=[];
            covariates(rowRmv, :)=[]
            [R p]=corrcoef(FCRef, DS);
            [RHO,PVAL] = partialcorr(FCRef, DS, covariates)
            RAllRef(k,i, j)=R(1,2);
            pAllRef(k, i, j)=p(1,2);
            RHOAllRef(k, i, j)=RHO;
            PVAlAllRef(k, i, j)=PVAL
            
            %  figure(1)
            %         scatter(fullBrainFC(:,i), DS)
            %         lsline
            %         axis([-0.2 1.2 4 20])
            %saveas(figure(1), [figDir, ROImaskGroup, 'Mask_', group, 'Subgroup_ROI', seed, '.png'])
            
            %             figure
            %             boxplot(fullBrainFC, 'whisker', 3)
            %             figure
            %             boxplot(DS, 'whisker', 3)
        end
    end
end


subID=1:numRef;
t=0;
for p=1:numGroup
    for q=1:numSeed
        t=t+1
        figure(t)
        plot(subID, RHOAllRef(:,q,p))
        ylim([-0.8 0.8])
    end
end

