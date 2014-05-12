

clear
clc
close all

ROImaskGroup='child_BT'; % can be "child_BT" or "child_FT"

if strcmp(ROImaskGroup, 'child_BT')
    numSeed=2
    groupList={'child_BT', 'adoles_BT'};
elseif strcmp(ROImaskGroup, 'child_FT')
    numSeed=4
    groupList={'child_FT', 'adoles_FT'};
end

dataDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/CWAS', ROImaskGroup, '/'];
maskFile=['/home2/data/Projects/workingMemory/mask/CWAS_newMask/stdMask_46sub_100percent.nii']
[OutdataMask,VoxDimMask,HeaderMask]=rest_readfile(maskFile);
[nDim1Mask nDim2Mask nDim3Mask]=size(OutdataMask);
MaskImg1D=reshape(OutdataMask, [], 1);

for j=1:length(groupList)
    group=char(groupList{j})
    
    if strcmp(group, 'child_BT') && strcmp(ROImaskGroup, 'child_BT')
        ref='4804'
    elseif strcmp(group, 'adoles_BT') && strcmp(ROImaskGroup, 'child_BT')
        ref='4683'
    elseif strcmp(group, 'child_FT') && strcmp(ROImaskGroup, 'child_FT')
        ref='4347'
    elseif strcmp(group, 'adoles_FT') && strcmp(ROImaskGroup, 'child_FT')
        ref='4415'
    end
    
    subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_', group, '.txt']);
    numSub=length(subList);
    correl=zeros(numSub, numSeed);
    
    for k=1:numSeed
        seed=num2str(k)
        reFile=[dataDir, 'zROI', seed, ROImaskGroup, '_', ref, '.nii'];
        [OutdataRef,VoxDimRef,HeaderRef]=rest_readfile(reFile);
        [nDim1Ref nDim2Ref nDim3Ref]=size(OutdataRef);
        refImg1D=reshape(OutdataRef, [], 1);
        finalRefImg1D=refImg1D(find(MaskImg1D==1));
        for i=1:numSub
            sub=num2str(subList(i));
            inputFile = [dataDir, 'zROI',seed ROImaskGroup, '_', sub, '.nii'];
            [Outdata,VoxDim,Header]=rest_readfile(inputFile);
            [nDim1 nDim2 nDim3]=size(Outdata);
            img1D=reshape(Outdata, [], 1);
            finalImg1D=img1D(find(MaskImg1D==1));
            [R, p]=corrcoef(finalRefImg1D, finalImg1D);
            correl(i,k)=R(1,2);
        end
        
        save(['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/DS_standFullBrainFC/standFullBrainFC_', ROImaskGroup, 'Mask_', group, '_subgroup.txt'], '-ascii', '-tabs', 'correl')
    end
end




