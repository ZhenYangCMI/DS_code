clear
clc
close all

ROImaskGroup='adoles_BT'

groupList={'adoles_BT', 'child_BT'}; % 'child_BT', 'adoles_BT'


DSGroup='bottom' % 'top' and 'bottom'

dataDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/ROIFC/CWAS', ROImaskGroup, '/'];
outputDir='/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/ttestPerformGroup/meanFCHighAndLow/';

maskFile=['/home2/data/Projects/workingMemory/mask/CWAS_newMask/stdMask_46sub_100percent.nii']
[OutdataMask,VoxDimMask,HeaderMask]=rest_readfile(maskFile);
[nDim1Mask nDim2Mask nDim3Mask]=size(OutdataMask);
maskImg1D=reshape(OutdataMask, [], 1);

for j=1:length(groupList)
    group=char(groupList{j})

subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_', group, '.txt']);
numSub=length(subList);
numSubPerDSGroup=8;


numVox=length(find(maskImg1D==1));
% mean img of the top tercile
tercile=zeros(numVox, numSubPerDSGroup);

if strcmp(DSGroup, 'top')
    subIDStart=16;
    subIDEnd=23;
else
    subIDStart=1;
    subIDEnd=8;
end

for i=subIDStart:subIDEnd
    sub=num2str(subList(i));
    inputFile = [dataDir, 'z', ROImaskGroup, '_', sub, '.nii']
    [Outdata,VoxDim,Header]=rest_readfile(inputFile);
    [nDim1 nDim2 nDim3]=size(Outdata);
    img1D=reshape(Outdata, [], 1);
    finalImg1D=img1D(find(maskImg1D==1));
    if strcmp(DSGroup, 'top')
        tercile(:, (i-15))=finalImg1D;
    else
        tercile(:, i)=finalImg1D;
    end
end
tercile=tercile';
meanImgTercile=mean(tercile);
[h, p, ci, stats]=ttest(tercile);
    tScore=stats.tstat;
    df=unique(stats.df);

    Img1D=maskImg1D;
    Img1D(find(Img1D~=0))=tScore;
    Img1D=reshape(Img1D, nDim1Mask, nDim2Mask, nDim3Mask);
    HeaderMask.pinfo = [1;0;0];
    HeaderMask.dt  =[16,0];
    rest_WriteNiftiImage(Img1D,HeaderMask, [outputDir,ROImaskGroup, 'Mask', group,'SubgroupMean', DSGroup, '.nii'])

% FDR correction for the spatial map
% [pID,pN] = FDR(p,0.05);
% 
% p=p';
% negLog10=zeros(numVox, 1);
% for k=1:numVox
%     if p(k)>pID
%         negLog10(k, 1)=0;
%     elseif p(k, 1)<=pID
%         if meanImgTercile(k)>0
%             negLog10(k, 1)=(-1)*log10(p(k));
%         else
%             negLog10(k, 1)=log10(p(k));
%         end
%     end
% end
% 
% correctedImg1D=maskImg1D;
% correctedImg1D(find(correctedImg1D~=0))=negLog10;
% correctedMap=reshape(correctedImg1D, nDim1Mask, nDim2Mask, nDim3Mask);
% HeaderMask.pinfo = [1;0;0];
% HeaderMask.dt  =[16,0];
% rest_WriteNiftiImage(correctedMap,HeaderMask, [figDir,ROImaskGroup, 'Mask_', group,'Subgroup_',DSGroup,'Tercile.nii'])
end


