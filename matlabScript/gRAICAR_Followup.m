clear all
close all
clc

task='FT'
numSub=68
type='Ants'
resultDir=['/home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/gRAICAR_PR_autoDim_ANTs/']
figDir='/home/data/Projects/workingMemory/figs/'
results=load([resultDir, 'wave1_result.mat'])
numComp=results.obj.result.trialTab;

model=load(['/home/data/Projects/workingMemory/data/modelOtherMetrics68sub.txt']);
ageDemean=model(:,6);
FTDemean=model(:, 8);
BTDemean=model(:, 9);

compList=[1, 2, 3, 4, 5, 7]
colors=['r', 'b', 'g', 'm'];
markers=['o', 'd', 's', '+', 'x'];
x1=zeros(40);
y1=linspace(-8, 8, 40);
x2=linspace(-5, 5, 40);
y2=zeros(40);

modulIndex=zeros(numSub, length(compList));
for i=1:length(compList)

    repMatrix=(results.obj.result.foundRepro{i}+results.obj.result.foundRepro{i}');
    
        [Ci Q] = modularity_louvain_und_sign(repMatrix);

    modulIndex(:,i)=Ci;
    figure(i)
    for j=1:length(unique(Ci))
        age=ageDemean(find(Ci==j));
        if strcmp(task, 'FT')
            DS=FTDemean(find(Ci==j));
        else
            DS=BTDemean(find(Ci==j));
        end
        marker=markers(j)
        color=colors(j);
        scatter(age, DS, 100, color, marker, 'fill')
        axis square
        %grid on
        hold on
        plot(x1, y1, 'k')
        hold on
        plot(x2, y2, 'k')
    end
    %saveas(figure(i), [figDir, task, '_comp', num2str(compList(i)), '.png'])
    
end
