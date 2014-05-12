clear
clc
close all

ROImaskGroup='adoles_BT'

groupList={'adoles_BT', 'child_BT'}; % 'child_BT', 'adoles_BT'


dataDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/ROIFC/CWAS', ROImaskGroup, '/'];
outputDir='/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/ttestPerformGroup/HighMinusLow/';

maskFile=['/home2/data/Projects/workingMemory/mask/CWAS_newMask/stdMask_46sub_100percent.nii']
[OutdataMask,VoxDimMask,HeaderMask]=rest_readfile(maskFile);
[nDim1Mask nDim2Mask nDim3Mask]=size(OutdataMask);
maskImg1D=reshape(OutdataMask, [], 1);

for j=1:length(groupList)
    group=char(groupList{j})
    
    subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_', group, '.txt']);
    numSub=length(subList);
    numSubPerDSGroup=8;
    
    highStart=16;
    highEnd=23;
    lowStart=1;
    lowEnd=8;
    
    numVox=length(find(maskImg1D==1));
    % mean img of the high tercile
    highTercile=zeros(numVox, numSubPerDSGroup);
    for i=highStart:highEnd
        sub=num2str(subList(i));
        inputFile = [dataDir, 'z', ROImaskGroup, '_', sub, '.nii']
        [Outdata,VoxDim,Header]=rest_readfile(inputFile);
        [nDim1 nDim2 nDim3]=size(Outdata);
        img1D=reshape(Outdata, [], 1);
        finalImg1D=img1D(find(maskImg1D==1));
        highTercile(:, (i-15))=finalImg1D;
    end
    highTercile=highTercile';
    
    lowTercile=zeros(numVox, numSubPerDSGroup);
    for i=lowStart:lowEnd
        sub=num2str(subList(i));
        inputFile = [dataDir, 'z', ROImaskGroup, '_', sub, '.nii']
        [Outdata,VoxDim,Header]=rest_readfile(inputFile);
        [nDim1 nDim2 nDim3]=size(Outdata);
        img1D=reshape(Outdata, [], 1);
        finalImg1D=img1D(find(maskImg1D==1));
        lowTercile(:, i)=finalImg1D;
    end
    lowTercile=lowTercile';
    
    [h, p, ci, stats]=ttest2(highTercile,lowTercile);
    tScore=stats.tstat;
    df=unique(stats.df);
    
    Img1D=maskImg1D;
    Img1D(find(Img1D~=0))=tScore;
    Img1D=reshape(Img1D, nDim1Mask, nDim2Mask, nDim3Mask);
    HeaderMask.pinfo = [1;0;0];
    HeaderMask.dt  =[16,0];
    rest_WriteNiftiImage(Img1D,HeaderMask, [outputDir,ROImaskGroup, 'Mask', group,'SubgroupHighMinusLow.nii'])
end


