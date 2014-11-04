% This script is for compte the overlap across dif strategeis for CWAS results

clear
clc
close all

% define path and variables
subList=load(['/home/data/Projects/Zhen/workingMemory/mask/subjectList_Num_68sub.txt'])
numSub=length(subList)
figDir='/home/data/Projects/Zhen/workingMemory/figs/paper_figs/compStrategies/pie/'
metric='CWAS'  
strategyList={'compCor', 'GSR', 'gCor', 'noGSR'}

% read in the mask file and reshape to 1D
maskFile=['/home/data/Projects/Zhen/workingMemory/mask/CPAC_12_16_13/compCor/stdMask_68sub_3mm_preSmooth_100percent.nii']
[OutdataMask,VoxDimMask,HeaderMask]=rest_readfile(maskFile);
[nDim1Mask nDim2Mask nDim3Mask]=size(OutdataMask);
maskImg1D=reshape(OutdataMask, [], 1);
maskIndx=find(maskImg1D);

% read in the ageByFT effect file and binarize into a mask
for i=1:length(strategyList)
    strategy=num2str(strategyList{i});
    
        fileName=['/home/data/Projects/Zhen/workingMemory/figs/paper_figs/compStrategies/', strategy, '/CWAS/thresh_ageByFTdemean.nii.gz'] 
    
    [Outdata,VoxDim,Header]=rest_readfile(fileName);
    [nDim1 nDim2 nDim3]=size(Outdata);
        img1D=reshape(Outdata, [], 1);
    img1D=img1D(maskIndx);
    img1D=logical(img1D);
    imgAllStrategies(:, i)=img1D;
end

% find the voxels commonly significant for all strategies
imgAllStrategies=imgAllStrategies';
commonSigVox=sum(imgAllStrategies)';
numVoxCommon=length(find(commonSigVox));

% compute the percentage of significant voxels
prctCommon=zeros(length(strategyList),1);

for i=1:length(strategyList)
    prctCommon(i,1)=length(find(commonSigVox==i))/numVoxCommon;
   end

%colorMap=[106, 196, 255; 106, 90, 205; 230, 123, 184; 228, 108, 10; 225, 227, 0]; %; 102, 60, 123
colorMap=[0, 0, 255; 0, 128, 0; 128, 0, 128; 255, 0, 0; 225, 255, 0];
colorMap=colorMap/255;
% pie plot the percentage
%labels={'1', '2', '3', '4', '5'}
figure(1)
%h=pie(prctCommon, labels)
h=pie(prctCommon)
hp = findobj(h, 'Type', 'patch');
set(hp(1), 'FaceColor', colorMap(1,:));
if length(hp)==2;
set(hp(2), 'FaceColor', colorMap(2,:));
elseif length(hp)==3;
set(hp(3), 'FaceColor', colorMap(3,:));
elseif length(hp)==4;
set(hp(4), 'FaceColor', colorMap(4,:));
end
set(h, 'LineWidth', 0.1)
saveas(figure(1),[figDir, metric, '_prctSigCommon.png'])

%write common regions to img
% final=zeros(size(maskImg1D));
% final(maskIndx, 1)=commonSigVox;
% final=reshape(final,nDim1Mask, nDim2Mask, nDim3Mask);
% 
% Header.pinfo = [1;0;0];
% Header.dt    =[16,0];
% 
% outName=[figDir, metric, '_sigVoxCommon.nii'];
% rest_Write4DNIfTI(final,Header,outName)







