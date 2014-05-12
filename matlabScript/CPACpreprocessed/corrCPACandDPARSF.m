% this script scatter plot the given deriviative value renerated using two
% CPAC and DPARSF for all voxels

clear
clc
close all
covType='noGSR'
numSub=68;
measureList={'ReHo', 'DegreeCentrality','VMHC', 'fALFF', 'skewness'};
figDir='/home/data/Projects/workingMemory/figs/CPACpreprocessedNew/compCPACandDPARSF/';

subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt']);
numSub=length(subList);

mask=['/home/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/autoMask_68sub_100percent.nii'];
% read in mask
[MaskData,VoxDim,Header]=rest_readfile(mask);
MaskDataOneDim=reshape(MaskData,[],1);
MaskIndex = find(MaskDataOneDim);

rAllMeasure=zeros(length(measureList), numSub);

color=['r','b','k','g','m'];

figure(1)
for j=1:length(measureList)
    measure=char(measureList{j})
    
    for i=1:numSub
        sub=num2str(subList(i))
        
        if strcmp(measure, 'VMHC')
            FileName1 = {sprintf('/home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/%s/%s/Snorm%s_%s.nii.gz', covType, measure, measure, sub)};
        else
            FileName1 = {sprintf('/home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/%s/%s/%s_%s_MNI_fwhm6.nii', covType, measure, measure, sub)};
        end
        
        if strcmp(measure, 'DegreeCentrality')
            FileName2={sprintf('/home/data/Projects/workingMemory/data/DPARSFanalysis/%s/ResultsWS/%s/sw%s_PositiveBinarizedSumBrainMap_%s.nii', covType, measure, measure,sub)};
        elseif strcmp(measure, 'VMHC')
            FileName2={sprintf('/home/data/Projects/workingMemory/data/DPARSFanalysis/%s/ResultsS/%s/s%sMap_%s.nii', covType, measure, measure,sub)};
        elseif strcmp(measure, 'fALFF')
            FileName2={sprintf('/home/data/Projects/workingMemory/data/DPARSFanalysis/%s_fALFF/ResultsWS/%s/sw%sMap_%s.nii', covType, measure, measure,sub)};
        elseif strcmp(measure, 'skewness')
            FileName2={sprintf('/home/data/Projects/workingMemory/data/DPARSFanalysis/%s/Results/%s/s%sMap_%s.nii', covType, measure, measure,sub)};
        else
            FileName2={sprintf('/home/data/Projects/workingMemory/data/DPARSFanalysis/%s/ResultsWS/%s/sw%sMap_%s.nii', covType, measure, measure,sub)};
        end
        
        
        % read in groupAnalysis results
        
        [AllVolume1,VoxelSize1,theImgFileList1, Header1] =rest_to4d(FileName1);
        [nDim1,nDim2,nDim3,numVol]=size(AllVolume1);
        AllVolume1=reshape(AllVolume1,[],numVol);
        
        % mask out the nonbrain regions
        
        AllVolume1=AllVolume1(MaskIndex, :);
        AllVolume1(find(AllVolume1==nan))=0;
        
        
        [AllVolume2,VoxelSize2,theImgFileList2, Header2] =rest_to4d(FileName2);
        AllVolume2=reshape(AllVolume2,[],numVol);
        
        AllVolume2=AllVolume2(MaskIndex, :);
        AllVolume2(find(AllVolume2==nan))=0;
        
        % compute the correlations
        
        [r, p]=corr(AllVolume1, AllVolume2);
        rAllMeasure(j,i)=r;
    end
    plot(rAllMeasure(j,:), color(j))
    hold on
end

saveas(figure(1), [figDir, 'cmpCPACandDPARSF_compMNIspace.png'])

