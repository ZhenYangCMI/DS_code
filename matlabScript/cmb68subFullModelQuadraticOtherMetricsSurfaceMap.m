
% This script will combine individual surface map for into one panel
clear
clc
close all
%%%Get the Surface maps
modelOrder='quadratic'
measureList={'ReHo', 'fALFF', 'VMHC', 'DegreeCentrality_PositiveBinarizedSumBrain', 'DegreeCentrality_PositiveWeightedSumBrain'};

for i=1:length(measureList)
    measure=char(measureList{i})
    
    UnitRow = 2168; % this num should be corresponding to the size(imdata1, 1)
    
    %UnitColumn = 1531*2;
    UnitColumn = 3334; % this num should be corresponding to the size(imdata1, 2)
    
    
    BackGroundColor = uint8([255*ones(1,1,3)]);
    
    %imdata_All = 255*ones(UnitRow*length(MeasureSet),UnitColumn*length(ConditionList),3);
    
    numRow=5;
    numColumn=2;
    
    imdata_All = repmat(BackGroundColor,[UnitRow*numRow,UnitColumn*numColumn,1]);
    
    
    %LeftMaskFile = '/home/data/HeadMotion_YCG/YAN_Scripts/HeadMotion/Parts/Left2FigureMask_BrainNetViewerMediumView.jpg';
    
    if strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain') || strcmp(measure, 'DegreeCentrality_PositiveWeightedSumBrain')
        maskType={'FullBrain', 'GreyMatter', 'FullBrain0.5'};
        for j=1:length(maskType)
            mask=char(maskType{j});
            DataUpDir = ['/home2/data/Projects/workingMemory/groupAnalysis/otherMetrics68sub/fullModel/', modelOrder, '/', measure, '_', mask, '/easythresh/cmb/'];
            OutputUpDir = ['/home/data/Projects/workingMemory/figs/otherMetrics68sub/fullModel', modelOrder, '/'];
            
            % T1: main effect of age, T2: main effect of age2, T3: main
            % effect of FT, T4: main effect of BT; T5: AgeByFT, T6:
            % agebyBT; T7: age2ByFT; T8: age2ByBT
            
            imdata1 = imread([DataUpDir, 'thresh_', measure, '_Full_T7_Z_cmb_SurfaceMap.jpg']);
            %imdata6=imdata6(1:end,120:1200,:); take a part of the image
            imdata2 = imread([DataUpDir, 'thresh_', measure, '_Full_T5_Z_cmb_SurfaceMap.jpg']);
            
            imdata3 = imread([DataUpDir, 'thresh_', measure, '_Full_T2_Z_cmb_SurfaceMap.jpg']);
            
            imdata4 = imread([DataUpDir, 'thresh_', measure, '_Full_T1_Z_cmb_SurfaceMap.jpg']);
            
            imdata5 = imread([DataUpDir, 'thresh_', measure, '_Full_T3_Z_cmb_SurfaceMap.jpg']);
            
            imdata6 = imread([DataUpDir, 'thresh_', measure, '_Full_T8_Z_cmb_SurfaceMap.jpg']);
            
            imdata7 = imread([DataUpDir, 'thresh_', measure, '_Full_T6_Z_cmb_SurfaceMap.jpg']);
            
            imdata8= imread([DataUpDir, 'thresh_', measure, '_Full_T4_Z_cmb_SurfaceMap.jpg']);
            
            imdata_All (1:1*UnitRow,1:1*UnitColumn,:) = imdata1;
            imdata_All (1*UnitRow+1:2*UnitRow,1:1*UnitColumn,:) = imdata2;
            imdata_All (2*UnitRow+1:3*UnitRow,0.5*UnitColumn+1:1.5*UnitColumn,:) = imdata3;
            imdata_All (3*UnitRow+1:4*UnitRow,0.5*UnitColumn+1:1.5*UnitColumn,:) = imdata4;
            imdata_All (4*UnitRow+1:5*UnitRow,1:1*UnitColumn,:) = imdata5;
            imdata_All (1:1*UnitRow,1*UnitColumn+1:2*UnitColumn,:) = imdata6;
            imdata_All (1*UnitRow+1:2*UnitRow,1*UnitColumn+1:2*UnitColumn,:) = imdata7;
            imdata_All (4*UnitRow+1:5*UnitRow,1*UnitColumn+1:2*UnitColumn,:) = imdata8;
            
            figure
            image(imdata_All)
            axis off          % Remove axis ticks and numbers
            axis image        % Set aspect ratio to obtain square pixels
            OutJPGName=[OutputUpDir,'sub68FullModel',modelOrder, '_',  measure, '_', mask '.jpg'];
            eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);
        end
    else
        DataUpDir = ['/home2/data/Projects/workingMemory/groupAnalysis/otherMetrics68sub/fullModel/', modelOrder, '/', measure, '/easythresh/cmb/'];
        
        OutputUpDir = ['/home/data/Projects/workingMemory/figs/otherMetrics68sub/fullModel', modelOrder, '/'];
        
        % T1: main effect of age, T2: main effect of age2, T3: main
        % effect of FT, T4: main effect of BT; T5: AgeByFT, T6:
        % agebyBT; T7: age2ByFT; T8: age2ByBT
        
        imdata1 = imread([DataUpDir, 'thresh_', measure, '_Full_T7_Z_cmb_SurfaceMap.jpg']);
        %imdata6=imdata6(1:end,120:1200,:); take a part of the image
        imdata2 = imread([DataUpDir, 'thresh_', measure, '_Full_T5_Z_cmb_SurfaceMap.jpg']);
        
        imdata3 = imread([DataUpDir, 'thresh_', measure, '_Full_T2_Z_cmb_SurfaceMap.jpg']);
        
        imdata4 = imread([DataUpDir, 'thresh_', measure, '_Full_T1_Z_cmb_SurfaceMap.jpg']);
        
        imdata5 = imread([DataUpDir, 'thresh_', measure, '_Full_T3_Z_cmb_SurfaceMap.jpg']);
        
        imdata6 = imread([DataUpDir, 'thresh_', measure, '_Full_T8_Z_cmb_SurfaceMap.jpg']);
        
        imdata7 = imread([DataUpDir, 'thresh_', measure, '_Full_T6_Z_cmb_SurfaceMap.jpg']);
        
        imdata8= imread([DataUpDir, 'thresh_', measure, '_Full_T4_Z_cmb_SurfaceMap.jpg']);
        
        imdata_All (1:1*UnitRow,1:1*UnitColumn,:) = imdata1;
        imdata_All (1*UnitRow+1:2*UnitRow,1:1*UnitColumn,:) = imdata2;
        imdata_All (2*UnitRow+1:3*UnitRow,0.5*UnitColumn+1:1.5*UnitColumn,:) = imdata3;
        imdata_All (3*UnitRow+1:4*UnitRow,0.5*UnitColumn+1:1.5*UnitColumn,:) = imdata4;
        imdata_All (4*UnitRow+1:5*UnitRow,1:1*UnitColumn,:) = imdata5;
        imdata_All (1:1*UnitRow,1*UnitColumn+1:2*UnitColumn,:) = imdata6;
        imdata_All (1*UnitRow+1:2*UnitRow,1*UnitColumn+1:2*UnitColumn,:) = imdata7;
        imdata_All (4*UnitRow+1:5*UnitRow,1*UnitColumn+1:2*UnitColumn,:) = imdata8;
        
        figure
        image(imdata_All)
        axis off          % Remove axis ticks and numbers
        axis image        % Set aspect ratio to obtain square pixels
        OutJPGName=[OutputUpDir,'sub68FullModel', modelOrder, '_', measure, '.jpg'];
        eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);
    end
end



