% this script scatter plot the given deriviative value renerated using two
% CPAC and DPARSF for all voxels

clear
clc


numSub=68;
measureList={'ReHo', 'DegreeCentrality','fALFF', 'VMHC', 'skewness', };

figDir='/home/data/Projects/workingMemory/figs/CPACpreprocessedNew/compCPACandDPARSF/';
mask=['/home/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/autoMask_68sub_90percent.nii'];

rAllMeasure=zeros(length(measureList), numSub);

color=['r','b','k','g','m'];

figure(1)
for j=1:length(measureList)
    measure=char(measureList{j})
    
    FileNameSet1=[];
    FileNameSet2=[];
    
    FileName1 = {['/home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/meanRegress/', measure, '/', measure, '_AllVolume_meanRegress.nii']};
    
    if strcmp(measure, 'DegreeCentrality')
        FileName2={['/home/data/Projects/workingMemory/data/DPARSFanalysis/meanRegress/DegreeCentrality_PositiveBinarizedSumBrain_AllVolume_meanRegress.nii']};
    else
        FileName2={['/home/data/Projects/workingMemory/data/DPARSFanalysis/meanRegress/', measure, '_AllVolume_meanRegress.nii']};
    end
    % read in mask file
    [MaskData,VoxDim,Header]=rest_readfile(mask);
    MaskDataOneDim=reshape(MaskData,[],1);
    MaskIndex = find(MaskDataOneDim);
    
    % read in groupAnalysis results
    
    [AllVolume1,VoxelSize1,theImgFileList1, Header1] =rest_to4d(FileName1);
    [nDim1,nDim2,nDim3,numSub]=size(AllVolume1);
    AllVolume1=reshape(AllVolume1,[],numSub);
    
    % mask out the nonbrain regions
    
    AllVolume1=AllVolume1(MaskIndex, :);
    AllVolume1(find(AllVolume1==nan))=0;
    
    
    [AllVolume2,VoxelSize2,theImgFileList2, Header2] =rest_to4d(FileName2);
    AllVolume2=reshape(AllVolume2,[],numSub);
    
    AllVolume2=AllVolume2(MaskIndex, :);
    AllVolume2(find(AllVolume2==nan))=0;
    
    % compute the correlations
    for i=1:numSub
        [r, p]=corr(AllVolume1(:,i), AllVolume2(:,i));
        rAllMeasure(j,i)=r;
    end
    plot(rAllMeasure(j,:), color(j))
    hold on
end

saveas(figure(1), [figDir, 'cmpCPACandDPARSF.png'])

