
% This script will combine individual surface map for into one panel

clear
clc
close all
%%%Get the Surface maps
ROImaskGroup='adoles' % Thishis is only for adoles_BT
task='BT'
corrType='spearman' %'spearman', 'pearson'

UnitRow = 900; % this num should be corresponding to the size(imdata1, 1)

%UnitColumn = 1531*2;
UnitColumn = 1081; % this num should be corresponding to the size(imdata1, 2)


BackGroundColor = uint8([255*ones(1,1,3)]);

%imdata_All = 255*ones(UnitRow*length(MeasureSet),UnitColumn*length(ConditionList),3);

numRow=2;
numColumn=2;

imdata_All = repmat(BackGroundColor,[UnitRow*numRow,UnitColumn*numColumn,1]);


%LeftMaskFile = '/home/data/HeadMotion_YCG/YAN_Scripts/HeadMotion/Parts/Left2FigureMask_BrainNetViewerMediumView.jpg';

DataUpDir = ['/home/data/Projects/workingMemory/figs/CWAS/46sub/distanceMatrix/'];

OutputUpDir = [DataUpDir, 'cmb/'];

if strcmp(ROImaskGroup, 'adoles') && strcmp(task, 'BT')
    %LeftMask = imread(LeftMaskFile);
    imdata1 = imread([DataUpDir, corrType, '/meanDist_', ROImaskGroup, task, 'Mask_adolessubGroup_', corrType, '.png']);
    imdata1=imdata1(1:end,120:1200,:);
    
    imdata2 = imread([DataUpDir, corrType, '/meanDistClust_', ROImaskGroup, '_',task, 'Mask_adoles_', task,'subGroup_', corrType, '.png']);
    imdata2=imdata2(1:end,120:1200,:);
    
    imdata3 = imread([DataUpDir, corrType, '/meanDist_', ROImaskGroup, task, 'Mask_childsubGroup_', corrType, '.png']);
    imdata3=imdata3(1:end,120:1200,:);
    
    imdata4 = imread([DataUpDir, corrType, '/meanDistClust_', ROImaskGroup, '_',task, 'Mask_child_', task,'subGroup_', corrType, '.png']);
    imdata4=imdata4(1:end,120:1200,:);
    %imdata(LeftMask==255) = 255;
    % imdata = imdata(1:end-80,120:1650,:);
    
    imdata_All (1:1*UnitRow,1:1*UnitColumn,:) = imdata1;
    imdata_All (1*UnitRow+1:2*UnitRow,1:1*UnitColumn,:) = imdata2;
    imdata_All (1:1*UnitRow,1*UnitColumn+1:2*UnitColumn,:) = imdata3;
    imdata_All (1*UnitRow+1:2*UnitRow,1*UnitColumn+1:2*UnitColumn,:) = imdata4;
    
    figure
    image(imdata_All)
    axis off          % Remove axis ticks and numbers
    axis image        % Set aspect ratio to obtain square pixels
    OutJPGName=[OutputUpDir,'distMatri_' ROImaskGroup,task, 'Mask_', corrType, '.jpg'];
    eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);
    
elseif strcmp(ROImaskGroup, 'child')
    if strcmp(task, 'BT')
        numSeed=2
    elseif strcmp(task, 'FT')
        numSeed=4
    end
    for j=1:numSeed
        seed=num2str(j)
        imdata1 = imread([DataUpDir, corrType, '/meanDistROI',seed, '_', ROImaskGroup, task, 'Mask_adolessubGroup_', corrType, '.png']);
        imdata1=imdata1(1:end,120:1200,:);
        
        imdata2 = imread([DataUpDir, corrType, '/meanDistClust_ROI',seed, ROImaskGroup, '_',task, 'Mask_adoles_', task,'subGroup_', corrType, '.png']);
        imdata2=imdata2(1:end,120:1200,:);
        
        imdata3 = imread([DataUpDir, corrType, '/meanDistROI',seed, '_', ROImaskGroup, task, 'Mask_childsubGroup_', corrType, '.png']);
        imdata3=imdata3(1:end,120:1200,:);
        
        imdata4 = imread([DataUpDir, corrType, '/meanDistClust_ROI', seed, ROImaskGroup, '_',task, 'Mask_child_', task,'subGroup_', corrType, '.png']);
        imdata4=imdata4(1:end,120:1200,:);
        %imdata(LeftMask==255) = 255;
        % imdata = imdata(1:end-80,120:1650,:);
        
        imdata_All (1:1*UnitRow,1:1*UnitColumn,:) = imdata1;
        imdata_All (1*UnitRow+1:2*UnitRow,1:1*UnitColumn,:) = imdata2;
        imdata_All (1:1*UnitRow,1*UnitColumn+1:2*UnitColumn,:) = imdata3;
        imdata_All (1*UnitRow+1:2*UnitRow,1*UnitColumn+1:2*UnitColumn,:) = imdata4;
        
        figure
        image(imdata_All)
        axis off          % Remove axis ticks and numbers
        axis image        % Set aspect ratio to obtain square pixels
        OutJPGName=[OutputUpDir,'distMatrixROI', seed, '_' ROImaskGroup,task, 'Mask_', corrType, '.jpg'];
        eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);
        
    end
end



