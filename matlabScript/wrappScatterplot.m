clear
clc
close all

%measureList={'ReHo', 'ALFF', 'fALFF', 'VMHC', 'DCBinary', 'DCWeighted'};
measureList={'VMHC'};
numMeasure=length(measureList);
configPath='/home2/data/Projects/workingMemory/code/C-PAC-Config/'
subList=load([configPath, 'subject_list_Num.txt']);
numSub=length(subList);

for i=1:numMeasure
    measure=char(measureList{i})
    dataDir='/home2/data/Projects/workingMemory/figs/cmpCpacAndDparsf/';
    tmp=load([dataDir, 'cmpCPACandDP_Pearson_', measure, '.txt']);
    pearson=squeeze(tmp(:,2));
    subLow=subList(find(pearson<0.1))
    subHigh=subList(find(pearson>0.7))
    subMedian=subList(find(pearson==median(pearson)))
    
    if length(subLow)~=0
        [ correl1, numVoxelPlotted1 ] =voxelScatterplot(subLow, measure)
    end
    
    if length(subHigh)~=0
        [ correl2, numVoxelPlotted2 ] =voxelScatterplot(subHigh, measure )
    end
    
    if length(subMedian)~=0
        [ correl3, numVoxelPlotted3 ] =voxelScatterplot(subMedian, measure)
    end
    
end



