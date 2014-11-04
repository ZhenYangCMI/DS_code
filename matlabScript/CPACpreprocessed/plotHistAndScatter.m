% This script
%1. Scatterplot the different preprocessing strategies for each apprach
% 2. Plot a histogram for a given approach

clear
clc

addpath /home/data/Projects/Zhen/commonCode/REST_V1.8_130615
%measureList={'DegreeCentrality', 'ReHo', 'fALFF', 'VMHC', 'CWAS'};
measureList={'VMHC'}
numMeasure=length(measureList);

figDir='/home/data/Projects/Zhen/workingMemory/figs/paper_figs/compStrategies/histAndScatter/';

for j=1:numMeasure
    close all
    measure=char(measureList{j})
    FileNameSet=[];
    
    if strcmp(measure, 'CWAS')
        strategyList={'compCor', 'GSR', 'gCor', 'noGSR'};
        mask=['/home/data/Projects/Zhen/workingMemory/mask/CPAC_12_16_13/noGSR/stdMask_68sub_3mm_preSmooth_100percent.nii.gz'];
        for i=1:length(strategyList)
            strategy=char(strategyList{i})
            FileNameSet{i,1}=['/home/data/Projects/Zhen/workingMemory/figs/paper_figs/compStrategies/', strategy, '/CWAS/zstats_ageByFTdemean.nii.gz'];
        end
    else
        if strcmp(measure, 'VMHC')
            mask=['/home/data/Projects/Zhen/workingMemory/mask/CPAC_1_1_14/noGSR/autoMask_68sub_90percent_L.nii'];
        else
            mask=['/home/data/Projects/Zhen/workingMemory/mask/CPAC_1_1_14/noGSR/autoMask_68sub_90percent.nii'];
        end
        strategyList={'meanRegress', 'compCor', 'GSR', 'gCor', 'noGSR'};
        for i=1:length(strategyList)
            strategy=char(strategyList{i})
            %FileNameSet{i,1}=['/home/data/Projects/Zhen/workingMemory/figs/paper_figs/compStrategies/', strategy, '/', measure, '_Full_T4_Z.nii'];
            FileNameSet{i,1}=['/home/data/Projects/Zhen/workingMemory/results/CPAC_1_1_14/groupAnalysis/', strategy, '/VMHC/unthresh/VMHC_Full_T4_Z_L.nii'];
        end
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
    
    % Plot histogram
        for k=1:length(strategyList)
            strategy=char(strategyList{k})
            figure(k)
            if strcmp(measure, 'CWAS')
                xvalue=-4:0.5:4;
                hist(AllVolume(:, k), xvalue)
                ylim([0 12000])
                %set(gca, 'XTick', [-5:2.5:5], 'XTickLabel', [], 'YTickLabel',[])
                set(gca, 'XTick', [-5:2.5:5])
            elseif strcmp(measure, 'ReHo')
                xvalue=-5:0.5:5;
                hist(AllVolume(:, k), xvalue)
                ylim([0 40000])
                set(gca, 'XTickLabel', [], 'YTickLabel',[])
            elseif strcmp(measure, 'DegreeCentrality')
                xvalue=-5:0.5:5;
                hist(AllVolume(:, k), xvalue)
                ylim([0 45000])
                %set(gca, 'YTick', 0:15000:45000)
                set(gca, 'XTickLabel', [], 'YTickLabel',[])
            elseif strcmp(measure, 'fALFF')
                xvalue=-5:0.5:5;
                hist(AllVolume(:, k), xvalue)
                ylim([0 40000])
                set(gca, 'XTickLabel', [], 'YTickLabel',[])
            elseif strcmp(measure, 'VMHC')
                xvalue=-5:0.5:5;
                hist(AllVolume(:, k), xvalue)
                ylim([0 25000])
                %set(gca, 'XTickLabel', [], 'YTickLabel',[])
            end
    
            h = findobj(gca,'Type','patch');
            color=[70 130 180];
            set(h,'FaceColor',color/255,'EdgeColor','k', 'LineWidth', 2.5)
            set(gca, 'LineWidth', 2)
            axis square
            %saveas(figure(k), [figDir, 'hist_', measure,'_', strategy '.png'])
        end
    
    % compute the correlations and scatterplot all voxels
    
%     [r, p]=corrcoef(AllVolume)
%     t=0;
%     
%     for m=1:length(strategyList)
%         row=char(strategyList{m})
%         for n=1:length(strategyList)
%             col=char(strategyList{n})
%             if m~=n
%                 t=t+1;
%                 figure(t)
%                 dotColor=[70 130 180]/255;
%                 scatter(AllVolume(:,m), AllVolume(:, n), 0.05, repmat(dotColor, size(AllVolume, 1), 1), 'fill')
%                 h=lsline
%                 color=[220 20 60];
%                 set ( h, 'Linewidth', 3 )
%                 set ( h, 'Color', color/255 )
%                 
%                 if strcmp(measure, 'CWAS')
%                     xlim([-5 5])
%                     ylim([-5 5])
%                     set(gca, 'XTick', -5:2.5:5, 'YTick', -5:2.5:5, 'XTickLabel', [], 'YTickLabel',[])
%                 else
%                     xlim([-6 6])
%                     ylim([-6 6])
%                     set(gca, 'XTick', -6:2:6, 'YTick', -6:2:6, 'XTickLabel', [], 'YTickLabel',[])
%                 end
%                 axis square
%                 box on
%                 set(gca, 'LineWidth', 2)
%                 saveas(figure(t), [figDir, 'Scatterplot_', measure,'_', row, 'VS', col,'.png'])
%             else
%                 continue
%             end
%         end
%     end
end

% figure(2)
% imagesc(r)
% colorbar
% caxis([0.2 1])
% saveas(figure(2), [figDir, 'cmpStrategies_corrcoef', measure, '.png'])


