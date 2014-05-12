% compute the distance matrix

clear
clc

ROImaskGroup='child_FT'
corrType='spearman';

if strcmp(ROImaskGroup, 'child_BT')
    numSeed=2;
    groupList={'adoles_BT', 'child_BT'};
else
    numSeed=4;
    groupList={'adoles_FT', 'child_FT'};
end

outputDir= ['/home/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followUp/correlDSAndFullBrainFC/distanceMatrix/'];
figDir=['/home/data/Projects/workingMemory/figs//CWAS/46sub/distanceMatrix/', corrType,'/' ];

maskFile=['/home2/data/Projects/workingMemory/mask/CWAS_newMask/stdMask_46sub_100percent.nii']
[OutdataMask,VoxDimMask,HeaderMask]=rest_readfile(maskFile);
[nDim1Mask nDim2Mask nDim3Mask]=size(OutdataMask);
maskImg1D=reshape(OutdataMask, [], 1);

for j=1:length(groupList)
    subGroup=char(groupList{j});
    
    subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_', subGroup,'.txt']);
    %subList=[3134 4711]
    numSub=length(subList);
    
    for k=1:numSeed
        seed=num2str(k)
        
        ROHAllSub=zeros(numSub, numSub);
        for i=1:numSub
            sub=num2str(subList(i))
            FileName=['/home/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/ROIFC/CWAS', ROImaskGroup, '/ROI',seed, ROImaskGroup, '_', sub, '.nii']
            
            [Outdata,VoxDim,Header]=rest_readfile(FileName);
            [nDim1 nDim2 nDim3]=size(Outdata);
            img1D=reshape(Outdata, [], 1);
            img1D=img1D(find(maskImg1D==1));
            imgAllSub(:, i)=img1D;
        end
        [r, p]=corr(imgAllSub, 'type', corrType);
        dist=1-r;
        
        figure(1)
        imagesc(dist)
        colorbar
        caxis([0.5 1])
        cmap=flipdim(jet(36),1);
        cmap=cmap(1:14, :);
        colormap(cmap)
        title([ROImaskGroup,'Mask ',subGroup,'subGroup'])
        xlabel('sub sorted by DS scores: low to high')
        ylabel('sub sorted by DS scores: low to high')
        saveas(figure(1), [figDir, 'meanDistClust_ROI',seed, ROImaskGroup, 'Mask_', subGroup, 'subGroup_', corrType,'.png'])
    end
end