% this script check the correlation between global mean and the variable of
% interests, including Age, DSF, DSB, and DST.

clear
clc

measureList={'DegreeCentrality','ReHo', 'fALFF', 'VMHC'}
model=load('/home/data/Projects/Zhen/workingMemory/data/regressionModelCPACNewAnalysisAgeDemeanByDSDemean.txt');
variable=model(:,3:6);
allR=[];
allp=[];
for i=1:length(measureList)
measure=char(measureList(i))
glob=load(['/home/data/Projects/Zhen/workingMemory/results/CPAC_1_1_14/reorgnized/meanRegress/', measure, '/', measure, '_MeanSTD.mat'])
globMean=glob.Mean_AllSub;
globStd=glob.Std_AllSub;

[R, p]=corr(globMean, variable);
allR(i,:)=R;
allp(i,:)=p;
end
allR
allp
