

clear
clc
close all

metric='ReHo'  %DegreeCentrality_PositiveBinarizedSumBrain
%T1: age; T2: FT; T3: BT; T4: agexFT' T5: agexBT
T='T4'

% load subList
subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt'])
numSub=length(subList)

% load NP
NP=load(['/home/data/Projects/workingMemory/data/modelOtherMetrics68sub.txt']);

% define path and variables
resultDir=['/home/data/Projects/workingMemory/groupAnalysis/rawscores/'];
strategyList={'noGSR', 'GSR', 'compCor', 'meanRegress'};
numStrategy=length(strategyList);

% load the full brain mask
mask=['/home/data/Projects/workingMemory/mask/otherMetrics_mask_68sub_GSR/stdMask_fullBrain_68sub_90percent.nii'];
[MaskData,VoxDimMask,HeaderMask]=rest_readfile(mask);
% MaskData=rest_loadmask(nDim1, nDim2, nDim3, [maskDir,'stdMask_fullBrain_68sub_90percent.nii']);
MaskData =logical(MaskData);%Revise the mask to ensure that it contain only 0 and 1
MaskDataOneDim=reshape(MaskData,[],1)';
MaskIndex = find(MaskDataOneDim);

% read in the metric data for all subjects
AllVolumeFinal=zeros(numSub, length(MaskIndex),numStrategy);

for j=1:numStrategy
    strategy=char(strategyList{j})
    
    if strcmp(strategy, 'meanRegress')
        
        file=['/home/data/Projects/workingMemory/data/DPARSFanalysis/', strategy, '/', metric, '_AllVolume_', strategy, '.nii'];
        [AllVolume,VoxelSize,theImgFileList, Header] =rest_to4d(file);
    else
        
        % define FileNameSet
        FileNameSet=[];
        for i=1:numSub
            sub=subList(i)
            
            if strcmp(metric, 'DegreeCentrality_PositiveBinarizedSumBrain')
                FileName = ['/home/data/Projects/workingMemory/data/DPARSFanalysis/', strategy, '/ResultsWS/DegreeCentrality/', 'sw', metric, 'Map_', num2str(sub), '.nii'];
            else
                FileName = ['/home/data/Projects/workingMemory/data/DPARSFanalysis/', strategy, '/ResultsWS/', metric, '/', 'sw', metric, 'Map_', num2str(sub), '.nii'];
            end
            FileNameSet{i,1}=FileName;
            
        end
        
        
        if ~isnumeric(FileNameSet)
            [AllVolume,VoxelSize,theImgFileList, Header] =rest_to4d(FileNameSet);
            fprintf('\n\tImage Files in the Group:\n');
            for itheImgFileList=1:length(theImgFileList)
                fprintf('\t%s%s\n',theImgFileList{itheImgFileList});
            end
        end
        
    end
    % reshape the data read in and mask out the regions outside of the brain
    [nDim1,nDim2,nDim3,nSub]=size(AllVolume);
    AllVolume=reshape(AllVolume,[],nSub)';
    AllVolume=AllVolume(:, MaskIndex);
    AllVolumeFinal(:, :, j)=AllVolume;
end


% exatract the ROI mean for neg clusters
maskFileNeg=['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_meanRegress/fullModel/linear/', metric, '/easythresh/cluster_mask_', metric, '_Full_', T, '_Z_neg.nii.gz']

[OutdataNegROI,VoxDimNegROI,HeaderNegROI]=rest_readfile(maskFileNeg);
[nDim1NegROI nDim2NegROI nDim3NegROI]=size(OutdataNegROI);
NegROI1D=reshape(OutdataNegROI, [], 1)';
NegROI1D=NegROI1D(1, MaskIndex);
numNegClust=length(unique(NegROI1D(find(NegROI1D~=0))))

clustMeanNeg=zeros(numSub, numStrategy, numNegClust);
for i=1:numNegClust
    for j=1:numStrategy
        AllVolume=AllVolumeFinal(:, :, j);
        ROI=AllVolume(:, find(NegROI1D==i));
        avg=mean(ROI, 2);
        clustMeanNeg(:, j, i)=avg;
    end
end

% extract the ROI mean for pos clusters
maskFilePos=['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_meanRegress/fullModel/linear/', metric, '/easythresh/cluster_mask_', metric, '_Full_', T, '_Z_pos.nii.gz']

[OutdataPosROI,VoxDimPosROI,HeaderPosROI]=rest_readfile(maskFilePos);
[nDim1PosROI nDim2PosROI nDim3PosROI]=size(OutdataPosROI);
PosROI1D=reshape(OutdataPosROI, [], 1)';
PosROI1D=PosROI1D(1, MaskIndex);
numPosClust=length(unique(PosROI1D(find(PosROI1D~=0))))

clustMeanPos=zeros(numSub, numStrategy, numPosClust);
for i=1:numPosClust
    for j=1:numStrategy
        AllVolume=AllVolumeFinal(:, :, j);
        ROI=AllVolume(:, find(PosROI1D==i));
        avg=mean(ROI, 2);
        clustMeanPos(:, j, i)=avg;
    end
end

% combine neg and pos clusters
clustMeanNeg2D=reshape(clustMeanNeg, numSub, []);
clustMeanPos2D=reshape(clustMeanPos, numSub, []);
% NP 'age_demean', 'DS_FT_demean', 'DS_BT_demean', 'ageByFTdemean', 'ageByBTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean'
clustMeanAndNP=horzcat(clustMeanNeg2D, clustMeanPos2D, NP(:,6), NP(:, 8:11), NP(:, 14:16));

save([resultDir, metric, '_clusterMeanAndNP.txt'],'-ascii','-double','-tabs', 'clustMeanAndNP')




