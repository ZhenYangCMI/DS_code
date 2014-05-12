% this script scatter plot the given deriviative value renerated using two
% CPAC and DPARSF for all voxels

clear
clc

measureList={'CWAS'}; %'DegreeCentrality_PositiveBinarizedSumBrain' 'ReHo'
numMeasure=length(measureList);

CWASstrategyList={'noGSR', 'GSR', 'gCor', 'compCor'};
strategyList={'noGSR', 'GSR', 'gCor', 'compCor', 'meanRegress'};

figDir='/home/data/Projects/workingMemory/figs/cmpStrategies/';
mask=['/home/data/Projects/workingMemory/mask/otherMetrics_mask_68sub_GSR/stdMask_fullBrain_68sub_90percent.nii'];


for j=1:numMeasure
    close all
    measure=char(measureList{j})
    
        if strcmp(measure, 'CWAS')
        FileNameSet=[];
        FileNameSet={'/home/data/Projects/workingMemory/groupAnalysis/CWAS_noGSR/CWAS68sub/fullModelLinearFWHM8.mdmr/zstats_ageByFTdemean.nii.gz'; '/home/data/Projects/workingMemory/groupAnalysis/CWAS_GSR/CWAS68sub/fullModelLinearFWHM8.mdmr/zstats_ageByFTdemean.nii.gz';'/home/data/Projects/workingMemory/groupAnalysis/CWAS_gCor/CWAS68sub/fullModelLinearFWHM8.mdmr/zstats_ageByFTdemean.nii.gz';'/home/data/Projects/workingMemory/groupAnalysis/CWAS_compCor/CWAS68sub/fullModelLinearFWHM8.mdmr/zstats_ageByFTdemean.nii.gz'};
        mask=['/home/data/Projects/workingMemory/mask/CWAS_68sub_GSR/stdMask_68sub_100percent.nii'];
    else
        FileNameSet=[];
        FileNameSet={['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_noGSR/fullModel/linear/', measure, '/', measure, '_Full_T4_Z.nii']; ['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_GSR/fullModel/linear/', measure, '/', measure, '_Full_T4_Z.nii']; ['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_gCor/fullModel/linear/', measure, '/', measure, '_Full_T4_Z.nii'];['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_compCor/fullModel/linear/', measure, '/', measure, '_Full_T4_Z.nii'];['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_meanRegress/fullModel/linear/', measure, '/', measure, '_Full_T4_Z.nii']};
    end
    
    % read in mask file
    [MaskData,VoxDim,Header]=rest_readfile(mask);
    
    % read in groupAnalysis results
    
    if ~isnumeric(FileNameSet)
        [AllVolume,VoxelSize,theImgFileList, Header] =rest_to4d(FileNameSet);
        fprintf('\n\tImage Files in the Group:\n');
        for itheImgFileList=1:length(theImgFileList)
            fprintf('\t%s%s\n',theImgFileList{itheImgFileList});
        end
    end
    
    
    [nDim1,nDim2,nDim3,nStrategies]=size(AllVolume);
    AllVolume=reshape(AllVolume,[],nStrategies);
    
    
    % mask out the nonbrain regions
    MaskDataOneDim=reshape(MaskData,[],1);
    MaskIndex = find(MaskDataOneDim);
    AllVolume=AllVolume(MaskIndex, :);
    AllVolume(find(AllVolume==nan))=0;
    
    % This is for CWAS
    AllVolume(find(AllVolume==-Inf))=0;
    
        for j=1:nStrategies
        figure(1)
        if strcmp(measure, 'CWAS')
            
            subplot(2,2,j)
            strategy=char(CWASstrategyList{j})
            xvalue=-4:0.25:4;
                       
        else
            subplot(2,3,j)
            strategy=char(strategyList{j})
            xvalue=-5:0.25:5;
            
        end
        
        if j==1
            hist(AllVolume(:, 1), xvalue)
        else
            
            hist(AllVolume(:, 1), xvalue)
            hold on
            hist(AllVolume(:, j), xvalue)
            h = findobj(gca,'Type','patch');
            set(h(1),'FaceColor','r', 'EdgeColor','k')
            set (h(1), 'FaceAlpha', 0.3);
        end
        title(strategy)
        if strcmp(measure, 'CWAS')
            ylim([0 3000])
        elseif strcmp(measure, 'ReHo')
            ylim([0 9000])
        else
            ylim([0 12000])
        end
        
    end
    
    
    saveas(figure(1), [figDir, 'cmpStrategies_hist', measure, '.png'])
    % compute the correlations
    %     [r, p]=corrcoef(AllVolume)
    
    
    %         for i=1:nStrategies
    %             if strcmp(measure, 'CWAS')
    %                 strategyRow=char(CWASstrategyList{i})
    %             else
    %                 strategyRow=char(strategyList{i})
    %
    %             end
    %             for j=1:nStrategies
    %                 if strcmp(measure, 'CWAS')
    %                     strategyCol=char(CWASstrategyList{j})
    %
    %                 else
    %                     strategyCol=char(strategyList{j})
    %
    %                 end
    %
    % plot scatterplot of all voxels
    %                 k=k+1
    %                 figure(k)
    %                 scatter(AllVolume(:,i), AllVolume(:, j))
    %                 lsline
    %                 if strcmp(measure, 'CWAS')
    %                     xlim([-4 4])
    %                     ylim([-4 4])
    %                 else
    %                     xlim([-5 5])
    %                     ylim([-5 5])
    %                 end
    %                 saveas(figure(k), [figDir, measure,'_', strategyRow, '_', strategyCol,'.png'])
    %             end
    %         end
    
    %     figure(2)
    %     imagesc(r)
    %     colorbar
    %     caxis([0.2 1])
    %
    %     saveas(figure(2), [figDir, 'cmpStrategies_corrcoef', measure, '.png'])
    
end
