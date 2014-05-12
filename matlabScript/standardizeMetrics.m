% this script standardize the measures using the group mask
% all measures were calculated in native space except for VMHC
% All measures were smoothed at fwhm=6

clear
clc

configPath='/home2/data/Projects/workingMemory/mask/'
%subList=[3115, 3119]
subList=load([configPath, 'subjectList_Num_68sub.txt']);
numSub=length(subList);

measureList={'ReHo', 'ALFF', 'fALFF', 'VMHC', 'DegreeCentrality_PositiveBinarizedSumBrain', 'DegreeCentrality_PositiveWeightedSumBrain'};
%measureList={'DegreeCentrality_PositiveBinarizedSumBrain', 'DegreeCentrality_PositiveWeightedSumBrain'};
numMeasure=length(measureList);
DCmask='FullBrain'; % 'FullBrain' or "GreyMatter'

DPARSFPath='/home2/data/Projects/workingMemory/data/DPARSF_analysis/';
mask='/home2/data/Projects/workingMemory/mask/CWAS_newMask_68sub/stdMask_68sub_90percent_3mm.nii';

for i=1:numMeasure
    measure=measureList{i};
    
    if strcmp(measure, 'VMHC')
        measureDir=[DPARSFPath, sprintf('MNICal/ResultsS_MNICal/%s/', measure)];
    elseif strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain') || strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain')
        measureDir=[DPARSFPath, 'nativeCal/ResultsWS/DegreeCentrality', DCmask,'/'];
    else
        measureDir=[DPARSFPath, sprintf('nativeCal/ResultsWS/%s/', measure)];
    end
    
    for j=1:numSub
        sub=subList(j)
        disp (['Working on sub ', num2str(sub),' ......'])
        
        % convert the 3D image of a given metric to 3D matrix
        if strcmp(measure, 'VMHC')
            DPARSFfile=[measureDir, sprintf('s%sMap_%d.nii',measure, sub)];
        else
            DPARSFfile=[measureDir, sprintf('sw%sMap_%d.nii',measure, sub)];
        end
        
        [AllVolume, VoxelSize, ImgFileList, Header1, nVolumn] =rest_to4d(DPARSFfile);
        [nDim1 nDim2 nDim3 nDimTimePoints]=size(AllVolume);
        brainSize = [nDim1 nDim2 nDim3];
        
        % remove the regions outside of the brain and convert data into 2D
        MaskData=rest_loadmask(nDim1, nDim2, nDim3, mask);
        MaskData =logical(MaskData);%Revise the mask to ensure that it contain only 0 and 1
        AllVolume=reshape(AllVolume,[],nDimTimePoints)';
        MaskDataOneDim=reshape(MaskData,1,[]);
        MaskIndex = find(MaskDataOneDim);
        AllVolume=AllVolume(:,MaskIndex);
        
        % Z_norm the time series for each voxel
        AllVolume = (AllVolume-repmat(mean(AllVolume),size(AllVolume,1),1))./repmat(std(AllVolume),size(AllVolume,1),1);
        AllVolume(isnan(AllVolume))=0;
        
        
        % Convert 2D file back into 4D
        AllVolumeBrain = single(zeros(nDimTimePoints, nDim1*nDim2*nDim3));
        AllVolumeBrain(:,MaskIndex) = AllVolume;
        AllVolumeBrain=reshape(AllVolumeBrain',[nDim1, nDim2, nDim3, nDimTimePoints]);
        
        
        % write 4D file as a nift file
        NormAllVolumeBrain=[measureDir, sprintf('Zsw%sMap_%d.nii',measure, sub)];
        rest_Write4DNIfTI(AllVolumeBrain,Header1,NormAllVolumeBrain)
        
        disp ([measure, ' of each voxel was Z-score normalized.'])
    end
end