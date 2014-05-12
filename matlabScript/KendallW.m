clear
clc

subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt']);
numSub=length(subList)
mask=['/home/data/Projects/workingMemory/mask/otherMetrics_mask_68sub_GSR/stdMask_fullBrain_68sub_90percent.nii'];
[MaskData,VoxDimMask,HeaderMask]=rest_readfile(mask);
% MaskData=rest_loadmask(nDim1, nDim2, nDim3, [maskDir,'stdMask_fullBrain_68sub_90percent.nii']);
MaskData =logical(MaskData);%Revise the mask to ensure that it contain only 0 and 1
MaskDataOneDim=reshape(MaskData,[],1)';
MaskIndex = find(MaskDataOneDim);

%measureList={'ReHo','fALFF', 'VMHC', 'skewness', 'DegreeCentrality_PositiveBinarizedSumBrain', 'DegreeCentrality_PositiveWeightedSumBrain'};
measureList={'ReHo'};
numMeasure=length(measureList)

%covTypeList={'noGSR', 'GSR', 'compCor', 'meanRegress'};
covTypeList={'noGSR', 'GSR', 'compCor', 'meanRegress'}
numCovType=length(covTypeList);

for j=1:numMeasure
    measure=char(measureList{j});
    
    Ranks_AllVolume=zeros(numSub, length(MaskIndex),numCovType);
    
    for k=1:numCovType
        covType=char(covTypeList{k});
        
        if strcmp(covType, 'meanRegress')
            
            file=['/home/data/Projects/workingMemory/data/DPARSFanalysis/', covType, '/', measure, '_AllVolume_', covType, '.nii'];
            [AllVolume,VoxelSize,theImgFileList, Header] =rest_to4d(file);
        else
            
            % define FileNameSet
            FileNameSet=[];
            for i=1:numSub
                sub=subList(i)
                
                if strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain')
                    FileName = ['/home/data/Projects/workingMemory/data/DPARSFanalysis/', covType, '/ResultsWS/DegreeCentralityFullBrain/', 'sw', measure, 'Map_', num2str(sub), '.nii'];
                else
                    FileName = ['/home/data/Projects/workingMemory/data/DPARSFanalysis/', covType, '/ResultsWS/', measure, '/', 'sw', measure, 'Map_', num2str(sub), '.nii'];
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
        
        [nDim1,nDim2,nDim3,nSub]=size(AllVolume);
        AllVolume=reshape(AllVolume,[],nSub)';
        
        % remove the regions outside of the brain and convert data into 2D
        
        
        % MaskData=rest_loadmask(nDim1, nDim2, nDim3, [maskDir,'stdMask_fullBrain_68sub_90percent.nii']);
        %MaskData =logical(MaskData);%Revise the mask to ensure that it contain only 0 and 1
        
        %MaskDataOneDim=reshape(MaskData,[],1)';
        %MaskIndex = find(MaskDataOneDim);
        AllVolume=AllVolume(:, MaskIndex);
        
        % Calcualte the rank
        CUTNUMBER=1;
        nDimTimePoints=nSub;
        fprintf('\n\t Rank calculating...');
        
        %YAN Chao-Gan, 120328. No longer change to uint16 type.
        %Ranks_AllVolume = repmat(zeros(1,size(AllVolume,2)), [size(AllVolume,1), 1]);
        %Ranks_AllVolume = repmat(uint16(zeros(1,size(AllVolume,2))), [size(AllVolume,1), 1]);
        
        SegmentLength = ceil(size(AllVolume,2) / CUTNUMBER);
        for iCut=1:CUTNUMBER
            if iCut~=CUTNUMBER
                Segment = (iCut-1)*SegmentLength+1 : iCut*SegmentLength;
            else
                Segment = (iCut-1)*SegmentLength+1 : size(AllVolume,2);
            end
            
            AllVolume_Piece = AllVolume(:,Segment);
            nVoxels_Piece = size(AllVolume_Piece,2);
            
            [AllVolume_Piece,SortIndex] = sort(AllVolume_Piece,1);
            db=diff(AllVolume_Piece,1,1);
            db = db == 0;
            sumdb=sum(db,1);
            
            %YAN Chao-Gan, 120328. No longer change to uint16 type.
            SortedRanks = repmat([1:nDimTimePoints]',[1,nVoxels_Piece]);
            %SortedRanks = repmat(uint16([1:nDimTimePoints]'),[1,nVoxels_Piece]);
            % For those have the same values at the current time point and previous time point (ties)
            if any(sumdb(:))
                TieAdjustIndex=find(sumdb);
                for i=1:length(TieAdjustIndex)
                    ranks=SortedRanks(:,TieAdjustIndex(i));
                    ties=db(:,TieAdjustIndex(i));
                    tieloc = [find(ties); nDimTimePoints+2];
                    maxTies = numel(tieloc);
                    tiecount = 1;
                    while (tiecount < maxTies)
                        tiestart = tieloc(tiecount);
                        ntied = 2;
                        while(tieloc(tiecount+1) == tieloc(tiecount)+1)
                            tiecount = tiecount+1;
                            ntied = ntied+1;
                        end
                        % Compute mean of tied ranks
                        ranks(tiestart:tiestart+ntied-1) = ...
                            sum(ranks(tiestart:tiestart+ntied-1)) / ntied;
                        tiecount = tiecount + 1;
                    end
                    SortedRanks(:,TieAdjustIndex(i))=ranks;
                end
            end
            clear db sumdb;
            SortIndexBase = repmat([0:nVoxels_Piece-1].*nDimTimePoints,[nDimTimePoints,1]);
            SortIndex=SortIndex+SortIndexBase;
            clear SortIndexBase;
            Ranks_Piece = zeros(nDimTimePoints,nVoxels_Piece);
            Ranks_Piece(SortIndex)=SortedRanks;
            clear SortIndex SortedRanks;
            
            %YAN Chao-Gan, 120328. No longer change to uint16 type.
            %Ranks_Piece=uint16(Ranks_Piece); % Change to uint16 to get the same results of previous version.
            
            Ranks_AllVolume(:,Segment, k) = Ranks_Piece;
            fprintf('.');
        end
    end
    
    
    % compute the Kendall W and entrophy
    numVox=size(Ranks_AllVolume, 2)
    WList=zeros(numVox,1);
    EList=zeros(numVox,1);
    for m=1:numVox
        X=squeeze(Ranks_AllVolume(:,m,:));
        W = f_kendall(X);
        E=-W*log(W);
        WList(m,1)=W;
        EList(m,1)=E;
        
    end
    
    % write wList to img
    KendallWBrain=zeros(size(MaskDataOneDim));
    KendallWBrain(1,MaskIndex)=WList;
    KendallWBrain=reshape(KendallWBrain,nDim1, nDim2, nDim3);
    
    Header.pinfo = [1;0;0];
    Header.dt    =[16,0];
    
    outName=['/home/data/Projects/workingMemory/groupAnalysis/rawscores/cmpStrategies/kendall_', measure, '.nii'];
    rest_Write4DNIfTI(KendallWBrain,Header,outName)
    
    % write EList to img
    entropyBrain=zeros(size(MaskDataOneDim));
    entropyBrain(1,MaskIndex)=EList;
    entropyBrain=reshape(entropyBrain,nDim1, nDim2, nDim3);
    
    Header.pinfo = [1;0;0];
    Header.dt    =[16,0];
    
    outName=['/home/data/Projects/workingMemory/groupAnalysis/rawscores/cmpStrategies/entropy_', measure, '.nii'];
    rest_Write4DNIfTI(entropyBrain,Header,outName)
    
end

