% global regression

clear
clc

preprocessDate='1_1_14';
subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt']);
%sub=num2str([3115])
numSub=length(subList)

BrainMaskDir=['/home/data/Projects/workingMemory/mask/CPAC_', preprocessDate, '/noGSR/'];

GlobalCorrelation=zeros(numSub, 1);
% convert the 4D image to 4D matrix
for i=1:numSub
    sub=num2str(subList(i))
    
    ROIMask_Global={[BrainMaskDir,'autoMask_', sub, '.nii']};
    
    DataDir= ['/home/data/Projects/workingMemory/results/CPAC_', preprocessDate, '/reorgnized/noGSR/FunImg/normFunImg_', sub, '.nii.gz'];
    
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
save(['/home/data/Projects/workingMemory/results/CPAC_', preprocessDate, '/reorgnized/gCor/gCor_CPAC', preprocessDate, '.txt'], '-ascii','-double','-tabs', 'GlobalCorrelation')


