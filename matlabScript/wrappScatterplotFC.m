clear
clc
close all

measure='FC' % This is specially for FC
numSeed=2; % number of seed used for seed-based FC analysis
configPath='/home2/data/Projects/workingMemory/code/C-PAC-Config/'
subList=load([configPath, 'subject_list_Num.txt']);
numSub=length(subList);

for i=1:numSeed
    seed=i
        dataDir='/home2/data/Projects/workingMemory/figs/cmpCpacAndDparsf/';
    tmp=load([dataDir, 'cmpCPACandDP_Pearson_', measure,'_', num2str(seed), '.txt']);
    pearson=squeeze(tmp(:,2));
    if i==1
    subLow=subList(find(pearson<0.6))
    subHigh=subList(find(pearson>0.9))
    else
        subLow=subList(find(pearson<0.3))
    subHigh=subList(find(pearson>0.7))
    end
    
    subMedian=subList(find(pearson==median(pearson)))
    
    if length(subLow)~=0
        [ correl1, numVoxelPlotted1 ] =voxelScatterplot(subLow, measure, seed)
    end
    
    if length(subHigh)~=0
        [ correl2, numVoxelPlotted2 ] =voxelScatterplot(subHigh, measure, seed )
    end
    
    if length(subMedian)~=0
        [ correl3, numVoxelPlotted3 ] =voxelScatterplot(subMedian, measure, seed)
    end
    
end



