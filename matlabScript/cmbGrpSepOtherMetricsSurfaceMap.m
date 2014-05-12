
% This script will combine individual surface map for into one panel

clear
clc
close all
%%%Get the Surface maps
measureList={'ReHo', 'ALFF', 'fALFF', 'VMHC', 'DegreeCentrality_PositiveBinarizedSumBrain', 'DegreeCentrality_PositiveWeightedSumBrain'};

for i=1:length(measureList)
    measure=char(measureList{i})
    
    UnitRow = 2168; % this num should be corresponding to the size(imdata1, 1)
    
    %UnitColumn = 1531*2;
    UnitColumn = 3334; % this num should be corresponding to the size(imdata1, 2)
    
    
    BackGroundColor = uint8([255*ones(1,1,3)]);
    
    %imdata_All = 255*ones(UnitRow*length(MeasureSet),UnitColumn*length(ConditionList),3);
    
    numRow=2;
    numColumn=2;
    
    imdata_All = repmat(BackGroundColor,[UnitRow*numRow,UnitColumn*numColumn,1]);
    
    
    %LeftMaskFile = '/home/data/HeadMotion_YCG/YAN_Scripts/HeadMotion/Parts/Left2FigureMask_BrainNetViewerMediumView.jpg';
    
    if strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain') || strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain')
        maskType={'FullBrain', 'GreyMatter'};
        for j=1:length(maskType)
            mask=char(maskType{j});
            DataUpDir = ['/home/data/Projects/workingMemory/groupAnalysis/groupSep/', measure, '_', mask, '/easythresh/cmb/'];
            OutputUpDir = ['/home/data/Projects/workingMemory/figs/otherMetrics/groupSep/'];
            
            % T1: DS effect
            
            imdata1 = imread([DataUpDir, 'thresh_adoles_', measure, '_FT_T1_Z_cmb_SurfaceMap.jpg']);
            %imdata6=imdata6(1:end,120:1200,:); take a part of the image
            imdata2 = imread([DataUpDir, 'thresh_child_', measure, '_FT_T1_Z_cmb_SurfaceMap.jpg']);
            
            imdata3 = imread([DataUpDir, 'thresh_adoles_', measure, '_BT_T1_Z_cmb_SurfaceMap.jpg']);
            
            imdata4 = imread([DataUpDir, 'thresh_child_', measure, '_BT_T1_Z_cmb_SurfaceMap.jpg']);
            
            
            %imdata(LeftMask==255) = 255;
            % imdata = imdata(1:end-80,120:1650,:);
            
            imdata_All (1:1*UnitRow,1:1*UnitColumn,:) = imdata1;
            imdata_All (1*UnitRow+1:2*UnitRow,1:1*UnitColumn,:) = imdata2;
            imdata_All (1:1*UnitRow,1*UnitColumn+1:2*UnitColumn,:) = imdata3;
            imdata_All (1*UnitRow+1:2*UnitRow,UnitColumn+1:2*UnitColumn,:) = imdata4;
            
            
            figure
            image(imdata_All)
            axis off          % Remove axis ticks and numbers
            axis image        % Set aspect ratio to obtain square pixels
            OutJPGName=[OutputUpDir,'groupSep', measure, '_', mask '.jpg'];
            eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);
        end
    else
        DataUpDir = ['/home/data/Projects/workingMemory/groupAnalysis/groupSep/', measure, '/easythresh/cmb/'];
        
        OutputUpDir = ['/home/data/Projects/workingMemory/figs/otherMetrics/groupSep/'];
        
        % T1: main effect of age, T2: DS by age, T3: DS main effect
        
        % T1: DS effect
        
        imdata1 = imread([DataUpDir, 'thresh_adoles_', measure, '_FT_T1_Z_cmb_SurfaceMap.jpg']);
        %imdata6=imdata6(1:end,120:1200,:); take a part of the image
        imdata2 = imread([DataUpDir, 'thresh_child_', measure, '_FT_T1_Z_cmb_SurfaceMap.jpg']);
        
        imdata3 = imread([DataUpDir, 'thresh_adoles_', measure, '_BT_T1_Z_cmb_SurfaceMap.jpg']);
        
        imdata4 = imread([DataUpDir, 'thresh_child_', measure, '_BT_T1_Z_cmb_SurfaceMap.jpg']);
        
        
        %imdata(LeftMask==255) = 255;
        % imdata = imdata(1:end-80,120:1650,:);
        
        imdata_All (1:1*UnitRow,1:1*UnitColumn,:) = imdata1;
        imdata_All (1*UnitRow+1:2*UnitRow,1:1*UnitColumn,:) = imdata2;
        imdata_All (1:1*UnitRow,1*UnitColumn+1:2*UnitColumn,:) = imdata3;
        imdata_All (1*UnitRow+1:2*UnitRow,UnitColumn+1:2*UnitColumn,:) = imdata4;
        
        
        figure
        image(imdata_All)
        axis off          % Remove axis ticks and numbers
        axis image        % Set aspect ratio to obtain square pixels
        OutJPGName=[OutputUpDir,'groupSep', measure, '.jpg'];
        eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);
    end
end



