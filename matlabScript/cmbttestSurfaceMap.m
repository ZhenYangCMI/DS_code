
% This script will combine individual surface map for into one panel

clear
clc
close all
%%%Get the Surface maps
ROImaskGroup='adoles' % Thishis is only for adoles_BT
task='BT'

UnitRow = 2168; % this num should be corresponding to the size(imdata1, 1)

%UnitColumn = 1531*2;
UnitColumn = 3334; % this num should be corresponding to the size(imdata1, 2)


BackGroundColor = uint8([255*ones(1,1,3)]);

%imdata_All = 255*ones(UnitRow*length(MeasureSet),UnitColumn*length(ConditionList),3);

numRow=3;
numColumn=2;

imdata_All = repmat(BackGroundColor,[UnitRow*numRow,UnitColumn*numColumn,1]);


%LeftMaskFile = '/home/data/HeadMotion_YCG/YAN_Scripts/HeadMotion/Parts/Left2FigureMask_BrainNetViewerMediumView.jpg';

DataUpDir1 = ['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/ttestPerformGroup/meanFCHighAndLow/easythresh/surfaceMap/'];
DataUpDir2=['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/ttestPerformGroup/HighMinusLow/easythresh/surfaceMap/'];

OutputUpDir = ['/home/data/Projects/workingMemory/figs/CWAS/46sub/ttestPerformGroup/cmb/'];

if strcmp(ROImaskGroup, 'adoles') && strcmp(task, 'BT')
    %LeftMask = imread(LeftMaskFile);
    imdata1 = imread([DataUpDir1, 'thresh_', ROImaskGroup, '_', task, 'Maskadoles_', task, 'SubgroupMeantop_Z_cmb_SurfaceMap.jpg']);
         %imdata6=imdata6(1:end,120:1200,:); take a part of the image
    imdata2 = imread([DataUpDir1, 'thresh_', ROImaskGroup, '_', task, 'Maskadoles_', task, 'SubgroupMeanbottom_Z_cmb_SurfaceMap.jpg']);
        
    imdata3 = imread([DataUpDir2, 'thresh_',ROImaskGroup, '_', task, 'Maskadoles_', task, 'SubgroupHighMinusLow_Z_cmb_SurfaceMap.jpg']);
        
    imdata4 = imread([DataUpDir1, 'thresh_', ROImaskGroup, '_', task, 'Maskchild_', task, 'SubgroupMeantop_Z_cmb_SurfaceMap.jpg']);
        
    imdata5 = imread([DataUpDir1, 'thresh_', ROImaskGroup, '_', task, 'Maskchild_', task, 'SubgroupMeanbottom_Z_cmb_SurfaceMap.jpg']);
        
    imdata6 = imread([DataUpDir2, 'thresh_',ROImaskGroup, '_', task, 'Maskchild_', task, 'SubgroupHighMinusLow_Z_cmb_SurfaceMap.jpg']);
           
    %imdata(LeftMask==255) = 255;
    % imdata = imdata(1:end-80,120:1650,:);
    
    imdata_All (1:1*UnitRow,1:1*UnitColumn,:) = imdata1;
    imdata_All (1*UnitRow+1:2*UnitRow,1:1*UnitColumn,:) = imdata2;
    imdata_All (2*UnitRow+1:3*UnitRow,1:1*UnitColumn,:) = imdata3;
    imdata_All (1:1*UnitRow,1*UnitColumn+1:2*UnitColumn,:) = imdata4;
    imdata_All (1*UnitRow+1:2*UnitRow,UnitColumn+1:2*UnitColumn,:) = imdata5;
    imdata_All (2*UnitRow+1:3*UnitRow,UnitColumn+1:2*UnitColumn,:) = imdata6;
    
    figure
    image(imdata_All)
    axis off          % Remove axis ticks and numbers
    axis image        % Set aspect ratio to obtain square pixels
    OutJPGName=[OutputUpDir,ROImaskGroup, '_', task,'ttest.jpg'];
    eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);
    
elseif strcmp(ROImaskGroup, 'child')
    if strcmp(task, 'BT')
        numSeed=2
    elseif strcmp(task, 'FT')
        numSeed=4
    end
    for j=1:numSeed
        seed=num2str(j)
        imdata1 = imread([DataUpDir1, 'thresh_', ROImaskGroup, '_', task, 'MaskROI', seed, 'adoles_', task, 'SubgroupMeantop_Z_cmb_SurfaceMap.jpg']);
              
        imdata2 = imread([DataUpDir1, 'thresh_', ROImaskGroup, '_', task, 'MaskROI', seed, 'adoles_', task, 'SubgroupMeanbottom_Z_cmb_SurfaceMap.jpg']);
                
        imdata3 = imread([DataUpDir2, 'thresh_',ROImaskGroup, '_', task, 'MaskROI', seed, 'adoles_', task, 'SubgroupHighMinusLow_Z_cmb_SurfaceMap.jpg']);
               
        imdata4 = imread([DataUpDir1, 'thresh_', ROImaskGroup, '_', task, 'MaskROI', seed, 'child_', task, 'SubgroupMeantop_Z_cmb_SurfaceMap.jpg']);
       
               imdata5 = imread([DataUpDir1, 'thresh_', ROImaskGroup, '_', task, 'MaskROI', seed, 'child_', task, 'SubgroupMeanbottom_Z_cmb_SurfaceMap.jpg']);
                
        imdata6 = imread([DataUpDir2, 'thresh_',ROImaskGroup, '_', task, 'MaskROI', seed, 'child_', task, 'SubgroupHighMinusLow_Z_cmb_SurfaceMap.jpg']);
       
        
        
        %imdata(LeftMask==255) = 255;
        % imdata = imdata(1:end-80,120:1650,:);
        
        imdata_All (1:1*UnitRow,1:1*UnitColumn,:) = imdata1;
        imdata_All (1*UnitRow+1:2*UnitRow,1:1*UnitColumn,:) = imdata2;
        imdata_All (2*UnitRow+1:3*UnitRow,1:1*UnitColumn,:) = imdata3;
        imdata_All (1:1*UnitRow,1*UnitColumn+1:2*UnitColumn,:) = imdata4;
        imdata_All (1*UnitRow+1:2*UnitRow,UnitColumn+1:2*UnitColumn,:) = imdata5;
        imdata_All (2*UnitRow+1:3*UnitRow,UnitColumn+1:2*UnitColumn,:) = imdata6;
        
        
        figure
        image(imdata_All)
        axis off          % Remove axis ticks and numbers
        axis image        % Set aspect ratio to obtain square pixels
        OutJPGName=[OutputUpDir,ROImaskGroup, '_', task, 'MaskROI', seed, 'ttest.jpg'];
        eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);
        
    end
end



