

clear
clc

configPath='/home2/data/Projects/workingMemory/code/C-PAC-Config/'
subList=load([configPath, 'subject_list_Num.txt']);
numSub=length(subList);
dataDir='/home2/data/Projects/workingMemory/data/DPARSF_analysis/RealignParameter/';

numScrub=zeros(numSub, 1);
for i=1:numSub
    sub=subList(i)
    FD=load([dataDir, num2str(sub), '/FD_Power_', num2str(sub),'.txt']);
    scrub=length(find(FD>0.2))
    numScrub(i, 1)=scrub;
end
pctNumScrub=numScrub/175*100;
close all
boxplot(pctNumScrub, 'whisker', 3)

a=load([dataDir, 'meanFD.mat']);
tmp=a.data;
meanPowerFD=tmp(:,2);

[correl, p]=corrcoef(pctNumScrub, meanPowerFD)

figure()
scatter(pctNumScrub, meanPowerFD)
lsline
xlim([0 100])



