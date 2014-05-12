% this script standardize the measures using the group mask
% all measures were calculated in native space except for VMHC
% All measures were smoothed at fwhm=6

clear
clc

preprocessDate='1_1_14';
covType='compCor' % 'compCor', 'GSR', 'noGSR'
subList=load('/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt');
numSub=length(subList);

mkdir (['/home/data/Projects/workingMemory/results/CPAC_', preprocessDate, '/reorgnized/', covType, '/skewness/'])
outputDir=['/home/data/Projects/workingMemory/results/CPAC_', preprocessDate, '/reorgnized/', covType, '/skewness/']

for j=1:numSub
    sub=num2str(subList(j))
    disp (['Working on sub ', num2str(sub),' ......'])
    mask=['/home/data/Projects/workingMemory/mask/CPAC_', preprocessDate, '/', covType, '/autoMaskNative_', sub, '.nii'];
    dataDir=['/home/data/Projects/workingMemory/results/CPAC_', preprocessDate, '/reorgnized/', covType, '/FunImg/'];
    data=[dataDir, 'FunImg_', sub, '.nii.gz']
    
    [AllVolume, VoxelSize, ImgFileList, Header, nVolumn] =rest_to4d(data);
    [nDim1 nDim2 nDim3 nDimTimePoints]=size(AllVolume);
    brainSize = [nDim1 nDim2 nDim3];
    
    % remove the regions outside of the brain and convert data into 2D
    MaskData=rest_loadmask(nDim1, nDim2, nDim3, mask);
    MaskData =logical(MaskData);%Revise the mask to ensure that it contain only 0 and 1
    AllVolume=reshape(AllVolume,[],nDimTimePoints)';
    MaskDataOneDim=reshape(MaskData,1,[]);
    MaskIndex = find(MaskDataOneDim);
    AllVolume=AllVolume(:,MaskIndex);
    
    % compute the skewness of the time series for each voxel
    skew=skewness(AllVolume);
    %     meanTS=mean(AllVolume);
    %     stdTS=std(AllVolume);
    %     skew=sum(((AllVolume-repmat(meanTS, size(AllVolume, 1),1)).^3)./repmat(stdTS.^3, size(AllVolume, 1),1));
    skew(isnan(skew))=0;
    
    % Convert 2D file back into 3D
    AllVolumeBrain = zeros(1, nDim1*nDim2*nDim3);
    AllVolumeBrain(1,MaskIndex) = skew;
    AllVolumeBrain=reshape(AllVolumeBrain,nDim1, nDim2, nDim3);
    
    % write 3D file as a nift file
    outFile=[outputDir, 'skewness_', sub, '.nii']
    rest_WriteNiftiImage(AllVolumeBrain,Header,outFile)
    
    %Z-norm the skewness map
    %zskew=(skew-repmat(mean(skew), 1, size(skew, 2)))./repmat(std(skew), 1, size(skew,2));
    %disp('skew score is normalized')
    
    % Convert 2D file back into 3D
    %     zAllVolumeBrain = zeros(1, nDim1*nDim2*nDim3);
    %     zAllVolumeBrain(1,MaskIndex) = zskew;
    %     zAllVolumeBrain=reshape(zAllVolumeBrain,nDim1, nDim2, nDim3);
    
    %     outFile1=[outputDir, 'zskewnessMap_', sub, '.nii']
    %     rest_WriteNiftiImage(zAllVolumeBrain,Header,outFile1)
    
    disp (['Skewness for sub', sub, ' computed.'])
end

