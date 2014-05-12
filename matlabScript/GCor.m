% global regression

clear
clc


subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt']);
%sub=num2str([3115])
numSub=length(subList)

BrainMaskDir=['/home/data/Projects/workingMemory/mask/CPACpreprocessing/noGSR/'];

GlobalCorrelation=zeros(numSub, 1);
% convert the 4D image to 4D matrix
for i=1:numSub
    sub=num2str(subList(i))
    
    % old results, mask dimension is wrong
    %BrainMaskDir=['/home/data/Projects/workingMemory/data/DPARSFanalysis/Masks'];
    %ROIMask_Global={[BrainMaskDir,filesep,sub,'_BrainMask_05_91x109x91.nii']};
    ROIMask_Global={[BrainMaskDir,'autoMask_', sub, '.nii']};
    
    DataDir= ['/home/data/Projects/workingMemory/data/DPARSFanalysis/noGSR/FunImgARCWF/', sub, '/Filtered_4DVolume.nii'];
    
    [AllVolume,VoxelSize,theImgFileList, Header] =rest_to4d(DataDir);
    
    [nDim1 nDim2 nDim3 nDimTimePoints]=size(AllVolume);
    
    [MaskData,MaskVox,MaskHead]=rest_readfile(ROIMask_Global{1}); %Global Mask
    
    % Convert into 2D. NOTE: here the first dimension is voxels,
    % and the second dimension is subjects. This is different from
    % the way used in y_bandpass.
    %AllVolume=reshape(AllVolume,[],nDimTimePoints)';
    AllVolume=reshape(AllVolume,[],nDimTimePoints);
    
    MaskDataOneDim=reshape(MaskData,[],1);
    MaskIndex = find(MaskDataOneDim);
    nVoxels = length(MaskIndex);
    %AllVolume=AllVolume(:,MaskIndex);
    AllVolume=AllVolume(MaskIndex,:);
    
    
    % Zero mean and unit variance for each time series
    AllVolume = (AllVolume - repmat(mean(AllVolume,2),[1,nDimTimePoints])) ./ repmat(std(AllVolume,0,2),[1,nDimTimePoints]);
    
    % Remove the NaN values, those could be caused by dividing by 0 standard deviation.
    AllVolume(find(isnan(AllVolume))) = 0;
    
    % Calculate the global signal
    GlobalMean = mean(AllVolume)';
    
    % Zero mean and unit variance for the global signal
    GlobalMean = (GlobalMean - mean(GlobalMean)) / std(GlobalMean);
    
    %FC Calculation
    FC=AllVolume*GlobalMean/(nDimTimePoints-1);
    
    GlobalCorrelation(i,1) = mean(FC);
    
end
save('/home/data/Projects/workingMemory/data/gCorTest.txt', '-ascii','-double','-tabs', 'GlobalCorrelation')


% below is based on Zarrar's code

% gCorAllSub=zeros(numSub, 1);
% % convert the 4D image to 4D matrix
% for i=1:numSub
%     sub=num2str(subList(i))
%
% dataFile=['/home/data/Projects/workingMemory/data/DPARSF_analysis/noGSR/FunImgARCWF/', sub, '/Filtered_4DVolume_3mm_masked.nii']
%
% [AllVolume, VoxelSize, ImgFileList, Header1, nVolumn] =rest_to4d(dataFile);
% [nDim1 nDim2 nDim3 nDimTimePoints]=size(AllVolume);
% brainSize = [nDim1 nDim2 nDim3];
%
% % remove the regions outside of the brain and convert data into 2D
% MaskData=rest_loadmask(nDim1, nDim2, nDim3, [maskDir,'stdMask_fullBrain_68sub_90percent.nii']);
% MaskData =logical(MaskData);%Revise the mask to ensure that it contain only 0 and 1
% AllVolume=reshape(AllVolume,nDimTimePoints, []);
% MaskDataOneDim=reshape(MaskData,1,[]);
% MaskIndex = find(MaskDataOneDim);
% AllVolume=AllVolume(:,MaskIndex);
% AllVolume(isnan(AllVolume))=0;
%
% % demean the time series
% demean=AllVolume-repmat(mean(AllVolume), size(AllVolume, 1), 1);
%
% % compute the square root of the sum squares
% sumSquare=(sum(demean.^2)).^(1/2);
%
% % transformed TS
% TS=demean./repmat(sumSquare, size(AllVolume, 1), 1);
% TS(isnan(TS))=0;
%
% % mean singal for every time point acorss all voxels
% avg=mean(TS')';
%
% % compute the gCor
% gCor=mean(avg'*TS)
% gCorz=0.5*log((1+gCor)./(1-gCor))
% gCorAllSub(i, 1)=gCor;
%
% disp ('gCor computed.')
% end


% Cov=
% %%Regress Out Cov
%             if ~isempty(Cov)
%                 for iVoxel = 1:size(AllVolume,2)
%                     [b,r] = rest_regress_ss(AllVolume(:,iVoxel),Cov);
%                     AllVolume(:,iVoxel) = r;
%
%                     [b,r] = rest_regress_ss(SeedVolume(:,iVoxel),Cov);
%                     SeedVolume(:,iVoxel) = r;
%                 end
%             end
