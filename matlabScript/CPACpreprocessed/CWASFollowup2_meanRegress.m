clear
clc


covType='noGSR' % covType can be noGSR or compCor

subID=load(['/home/data/Projects/Zhen/workingMemory/mask/subjectList_Num_68sub.txt']);
numSub=num2str(length(subID));

model='TotTSep' % fullModel or TotTSep
if strcmp(model, 'TotTSep')
    effectList={'ageByTotTdemean', 'DS_TotT_demean'};
else
    %effectList={'DS_FT_demean', 'DS_BT_demean', 'ageByFTdemean', 'ageByBTdemean'};
    effectList={'DS_FT_demean', 'DS_BT_demean'}
end


BrainMaskFile=['/home/data/Projects/Zhen/workingMemory/mask/CPAC_12_16_13/', covType, '/stdMask_68sub_3mm_preSmooth_100percent.nii'];

for j=1:length(effectList)
    effect=char(effectList{j})
    mkdir (['/home/data/Projects/Zhen/workingMemory/results/CPAC_12_16_13/groupAnalysis/', covType, '/CWAS3mmSmallMask/followUpFC_meanRegress'])
    dataOutDir=['/home/data/Projects/Zhen/workingMemory/results/CPAC_12_16_13/groupAnalysis/', covType, '/CWAS3mmSmallMask/followUpFC_meanRegress/'];
    %Test if all the subjects exist
    
    FileNameSet=[];
    
    ROIDef=['/home/data/Projects/Zhen/workingMemory/results/CPAC_12_16_13/groupAnalysis/', covType, '/CWAS3mmSmallMask/', model, 'FWHM8.mdmr/cluster_mask_', effect, '.nii.gz']
    [Outdata,VoxDim,Header]=rest_readfile(ROIDef);
    [nDim1 nDim2 nDim3]=size(Outdata);
    ROI1D=reshape(Outdata, [], 1)';
    %ROI1D=ROI1D(1, MaskIndex);
    numClust=length(unique(ROI1D(find(ROI1D~=0))))
    
    for k=1:numClust
        
        for i=1:length(subID)
            sub=num2str(subID(i));
            disp(['Working on ', sub])
            
            %if strcmp(effect, 'DS_FT_demean') || strcmp(effect, 'DS_BT_demean')
                %FileName =['/home/data/Projects/Zhen/workingMemory/results/CPAC_12_16_13/groupAnalysis/', covType, '/CWAS3mmSmallMask/', model, 'FWHM8.mdmr/', effect, '_followUp/ROI', num2str(k), 'FC_', effect, '_', sub, '.nii'];
            %else
                FileName =['/home/data/Projects/Zhen/workingMemory/results/CPAC_12_16_13/groupAnalysis/', covType, '/CWAS3mmSmallMask/', model, 'FWHM8.mdmr/', effect, '_followUp/FC_', effect, '_', sub, '.nii'];
            %end
            
            if ~exist(FileName,'file')
                
                disp(sub)
                
            else
                
                FileNameSet{i,1}=FileName;
                
            end
            
        end
        
        
        FileNameSet;
        
        [AllVolume,vsize,theImgFileList, Header,nVolumn] =rest_to4d(FileNameSet);
        
        
        
        [nDim1 nDim2 nDim3 nDimTimePoints]=size(AllVolume);
        
        
        
        
        
        %Set Mask
        
        if ~isempty(BrainMaskFile)
            
            [MaskData,MaskVox,MaskHead]=rest_readfile(BrainMaskFile);
            
        else
            
            MaskData=ones(nDim1,nDim2,nDim3);
            
        end
        
        
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
        
        
        
        AllVolumeBAK = AllVolume;
        
        
        % compute the mean and st acorss all voxels for each sub
        Mean_AllSub = mean(AllVolume)';
        
        Std_AllSub = std(AllVolume)';
        
        %Prctile_25_75 = prctile(AllVolume,[25 50 75]);
        
        
        %Median_AllSub = Prctile_25_75(2,:)';
        
        %IQR_AllSub = (Prctile_25_75(3,:) - Prctile_25_75(1,:))';
        
        
        Mat = [];
        
        Mat.Mean_AllSub = Mean_AllSub;
        
        Mat.Std_AllSub = Std_AllSub;
        
        OutputName=[dataOutDir, model, '_', effect, '_ROI', num2str(k) ];
        save([OutputName,'_MeanSTD.mat'],'Mean_AllSub','Std_AllSub');
        
        
        Cov = Mat.Mean_AllSub;
        
        
        %Mean centering
        
        Cov = (Cov - mean(Cov))/std(Cov);
        
        
        AllVolumeMean = mean(AllVolume,2);
        
        AllVolume = (AllVolume-repmat(AllVolumeMean,1,size(AllVolume,2)));
        
        
        %AllVolume = (eye(size(Cov,1)) - Cov*inv(Cov'*Cov)*Cov')*AllVolume; %If the time series are columns
        
        AllVolume = AllVolume*(eye(size(Cov,1)) - Cov*inv(Cov'*Cov)*Cov')';  %If the time series are rows
        
        %AllVolume = AllVolume + repmat(AllVolumeMean,1,size(AllVolume,2));
        
        
        AllVolumeSign = sign(AllVolume);
        
        
        % write the data as a 4D volume
        AllVolumeBrain = (zeros(nDim1*nDim2*nDim3, nDimTimePoints));
        
        AllVolumeBrain(MaskIndex,:) = AllVolume;
        
        
        
        AllVolumeBrain=reshape(AllVolumeBrain,[nDim1, nDim2, nDim3, nDimTimePoints]);
        
        Header_Out = Header;
        
        Header_Out.pinfo = [1;0;0];
        
        Header_Out.dt    =[16,0];
        
        %write 4D file as a nift file
        outName=[dataOutDir, model, '_', effect, '_ROI', num2str(k), '_AllVolume_meanRegress.nii'];
        rest_Write4DNIfTI(AllVolumeBrain,Header_Out,outName)
        
    end
end
