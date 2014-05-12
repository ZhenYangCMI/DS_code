% plot gRAICAR results
clear all
close all
clc

numSub=68
type='Ants'
resultDir=['/home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/gRAICAR_PR_autoDim_ANTs/']
results=load([resultDir, 'wave1_result.mat'])
numComp=results.obj.result.trialTab;


a=[results.obj.result.sig_subjLoad(:,1:5), results.obj.result.sig_subjLoad(:,7)]
percentSigSub=zeros(size(a,2),1);
for i=1:size(a,2)
    tmp=a(:,i);
    percentSigSub(i,1)=length(find(tmp>=0.5))/numSub*100;
end

% plot the percent sub have sig load
figure(1)
bar(percentSigSub)
ylim([0 100])
saveas(figure(1), ['/home/data/Projects/workingMemory/figs/percentSigSub', type, '.png'])

% plot the sig_subjLoad
figure(2)
imagesc(results.obj.result.sig_subjLoad')
colorbar
caxis([0 1])
saveas(figure(2), ['/home/data/Projects/workingMemory/figs/sig_subjLoad', type, '.png'])

% plot the beta_rank
figure(3)
imagesc(results.obj.result.beta_rank_subjLoad)
colorbar
caxis([0 1])
saveas(figure(3), ['/home/data/Projects/workingMemory/figs/betaRank', type, '.png'])

% plot the num of comp for each sub
figure(5)
plot(results.obj.result.trialTab(:,2), results.obj.result.trialTab(:,3))
ylim([0 40])
saveas(figure(5), ['/home/data/Projects/workingMemory/figs/numCompPerSub', type, '.png'])


% the 5, 6, 7 rows are orders for age, FT, and BT separately
newOrder=load('/home/data/Projects/workingMemory/data/rank.txt')
ageOrder=newOrder(:, 4);
FTOrder=newOrder(:, 5);
BTOrder=newOrder(:, 6);

compList=[1, 2, 3, 4, 5, 7]
dataPlot1=zeros(numSub, numSub);
dataPlot2=zeros(numSub, numSub);

close all
for i=1:length(compList)
    tmp=(results.obj.result.foundRepro{i}+results.obj.result.foundRepro{i}');
    for j=1:numSub
        j
        k=FTOrder(j)
        m=BTOrder(j)
        dataPlot1(k, :)=tmp(j, :);
        dataPlot2(m, :)=tmp(j, :);
    end
    
%     figure(1)
%     subplot(3,2,i)
%     imagesc(dataPlot1)
%     colorbar
%     axis square
%     caxis([0 18])
%     
%     figure(2)
%     subplot(3,2,i)
%     imagesc(dataPlot2)
%     colorbar
%     axis square
%     caxis([0 18])
%     
%     figure(3)
%     subplot(3,2,i)
%     imagesc(tmp)
%     colorbar
%     axis square
%     caxis([0 18])
    
    figNum=3+i
    figure(figNum)
    imagesc(tmp)
    colorbar
    axis square
    caxis([0 18])
    saveas(figure(figNum), ['/home/data/Projects/workingMemory/figs/ReprMatrix', type, 'AC', num2str(compList(i)), '.png'])
    
end

% saveas(figure(1), ['/home/data/Projects/workingMemory/figs/FTAgeRankedReprMatrix', type, 'ANTs.png'])
% saveas(figure(2), ['/home/data/Projects/workingMemory/figs/BTAgeRankedReprMatrix', type, 'ANTs.png'])
% saveas(figure(3), ['/home/data/Projects/workingMemory/figs/AgeRankedReprMatrix', type, 'ANTs.png'])

