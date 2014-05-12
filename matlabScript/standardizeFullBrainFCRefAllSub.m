

clear
clc
close all

ROImaskGroup='adoles_BT'

groupList={'child_BT'}; % 'child_BT', 'adoles_BT'
dataDir=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/ROIFC/CWAS', ROImaskGroup, '/'];
maskFile=['/home2/data/Projects/workingMemory/mask/CWAS_newMask/stdMask_46sub_100percent.nii']
[OutdataMask,VoxDimMask,HeaderMask]=rest_readfile(maskFile);
[nDim1Mask nDim2Mask nDim3Mask]=size(OutdataMask);
MaskImg1D=reshape(OutdataMask, [], 1);

for j=1:length(groupList)
    group=char(groupList{j})
    
    subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_', group, '.txt']);
    %subList=[4415]
    numSub=length(subList);
    numRef=numSub;
    correl=zeros(numSub, numRef);
    
    for k=1:numRef
        ref=num2str(subList(k))
        reFile=[dataDir, 'z', ROImaskGroup, '_', ref, '.nii'];
        [OutdataRef,VoxDimRef,HeaderRef]=rest_readfile(reFile);
        [nDim1Ref nDim2Ref nDim3Ref]=size(OutdataRef);
        refImg1D=reshape(OutdataRef, [], 1);
        finalRefImg1D=refImg1D(find(MaskImg1D==1));
        
        for i=1:numSub
            sub=num2str(subList(i));
            inputFile = [dataDir, 'z', ROImaskGroup, '_', sub, '.nii'];
            [Outdata,VoxDim,Header]=rest_readfile(inputFile);
            [nDim1 nDim2 nDim3]=size(Outdata);
            img1D=reshape(Outdata, [], 1);
            finalImg1D=img1D(find(MaskImg1D==1));
            [R, p]=corrcoef(finalRefImg1D, finalImg1D);
            correl(i,k)=R(1,2);
        end
    end
    save(['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/correlDSAndFullBrainFC/standFullBrainFC_', ROImaskGroup, 'Mask_', group, '_subgroup.txt'], '-ascii', '-tabs', 'correl')
    
end




