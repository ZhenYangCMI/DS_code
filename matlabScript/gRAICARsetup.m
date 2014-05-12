% organize file for gRAICAR
clear
clc

%covType='noGSR'

subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt']);
%sub=num2str([3115])
numSub=length(subList)


% move and organize file to the gRAICA directory
for i=1:numSub
    sub=num2str(subList(i))
    mkdir (['/home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1_oldPipeline/', sub, '/FunImgARCFS'])
    mkdir (['/home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1oldPipeline/', sub, '/T1Img'])
    
    copyfile (['/home/data/Projects/workingMemory/data/DPARSFanalysis/FunImgARCFS/', sub, '/rest.nii'],...
        ['/home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1_oldPipeline/', sub, '/FunImgARCFS/'])
    copyfile (['/home/data/Projects/workingMemory/data/DPARSFanalysis/T1Img/', sub, '/mprage.nii'],...
        ['/home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1_oldPipeline/', sub, '/T1Img/'])
end


% convert the 4D image to 4D matrix
for i=1:numSub
    sub=num2str(subList(i))
%mkdir (['/home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub', sub, '/rest_1_FunImgARCF'])
subDir=['/home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub', sub, '/rest_1_FunImgARCFS']
dataFile=[subDir, '/AllVolume_masked_fwhm4.5.nii'];

[AllVolume, VoxelSize, ImgFileList, Header1, nVolumn] =rest_to4d(dataFile);
[nDim1 nDim2 nDim3 nDimTimePoints]=size(AllVolume);
brainSize = [nDim1 nDim2 nDim3];

% remove the regions outside of the brain and convert data into 2D
maskFile=['/home/data/Projects/workingMemory/data/DPARSFanalysis/FunImgARmask/', sub, '/rarest_mask.nii'];
[MaskData,VoxDimMask,HeaderMask]=rest_readfile(maskFile);

% MaskData=rest_loadmask(nDim1, nDim2, nDim3, [maskDir,'stdMask_fullBrain_68sub_90percent.nii']);
MaskData =logical(MaskData);%Revise the mask to ensure that it contain only 0 and 1
AllVolume=reshape(AllVolume,[],nDimTimePoints);
MaskDataOneDim=reshape(MaskData,[],1);
MaskIndex = find(MaskDataOneDim);
AllVolume=AllVolume(MaskIndex, :);

% % Convert 2D file back into 4D
% AllVolumeBrain = single(zeros(nDim1*nDim2*nDim3, nDimTimePoints));
% AllVolumeBrain(MaskIndex, :) = AllVolume;
% AllVolumeBrain=reshape(AllVolumeBrain,[nDim1, nDim2, nDim3, nDimTimePoints]);
% 
% %write 4D file as a nift file
% outName=[subDir,'/','AllVolume_masked.nii'];
% rest_Write4DNIfTI(AllVolumeBrain,Header1,outName)

% scale the time series for each voxel
AllVolume=AllVolume';
% AllVolumeDemean=AllVolume-repmat(mean(AllVolume), size(AllVolume, 1), 1);
% AllVolumeVarNorm=AllVolumeDemean./repmat(std(AllVolumeDemean), size(AllVolumeDemean,1),1);
AllVolumeDetrend=detrend(AllVolume);
zAllVolumeDetrend=zscore(AllvolumeDetrend);
AllVolumeVarNorm=zAllVolumeDetrend';

AllVolumeBrain = single(zeros(nDim1*nDim2*nDim3, nDimTimePoints));
AllVolumeBrain(MaskIndex, :) = AllVolumeVarNorm;
AllVolumeBrain=reshape(AllVolumeBrain,[nDim1, nDim2, nDim3, nDimTimePoints]);
% AllVolumeGms = AllVolumeVarNorm./repmat(mean(AllVolumeVarNorm, 2),1, size(AllVolumeVarNorm,2));
% AllVolumeGms(isnan(AllVolumeGms))=0;
% AllVolumeGms=AllVolumeGms';

% Convert 2D file back into 4D
% AllVolumeBrainGms = single(zeros(nDim1*nDim2*nDim3, nDimTimePoints));
% AllVolumeBrainGms(MaskIndex, :) = AllVolumeGms;
% AllVolumeBrainGms=reshape(AllVolumeBrainGms,[nDim1, nDim2, nDim3, nDimTimePoints]);


%write 4D file as a nift file
outNameGms=[subDir,'/', 'varNorm_AllVolume_masked_fwhm4.5.nii'];
rest_Write4DNIfTI(AllVolumeBrain,Header1,outNameGms)

disp ('Time series of each voxel was global mean scaled.')
end
