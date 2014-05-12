
% This script will combine individual surface map for into one panel

clear
clc
close all
%%%Get the Surface maps

covTypeList={'noGSR', 'GSR', 'gCor', 'compCor'}
%measureList={'cluster_mask', 'thresh'};
mapList={'zstats'}
effect='Linear'

for j=1:length(covTypeList)
    covType=char(covTypeList{j})
    
    for i=1:length(mapList)
        map=char(mapList{i})
        
        UnitRow = 2168; % this num should be corresponding to the size(imdata1, 1)
        
        %UnitColumn = 1531*2;
        UnitColumn = 3334; % this num should be corresponding to the size(imdata1, 2)
        
        
        BackGroundColor = uint8([255*ones(1,1,3)]);
        
        %imdata_All = 255*ones(UnitRow*length(MeasureSet),UnitColumn*length(ConditionList),3);
        
        numRow=3;
        numColumn=2;
        
        imdata_All = repmat(BackGroundColor,[UnitRow*numRow,UnitColumn*numColumn,1]);
        
        
        DataUpDir = ['/home2/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/CWAS68sub/fullModel', effect, 'FWHM8.mdmr/surfaceMap/'];
        %mkdir (['/home2/data/Projects/workingMemory/figs/CWAS_', covType, '/fullModel', effect, 'FWHM8/'])
        OutputUpDir = ['/home2/data/Projects/workingMemory/figs/CWAS_', covType, '/fullModel', effect, 'FWHM8/'];
        
        % T1: main effect of age, T2: main effect of FT, T3: main
        % effect of BT, T4: ageByFT, T5: agebyBT
        
        imdata1 = imread([DataUpDir, map, '_ageByFTdemean_SurfaceMap.jpg']);
        %imdata6=imdata6(1:end,120:1200,:); take a part of the image
        imdata2 = imread([DataUpDir, map, '_age_demean_SurfaceMap.jpg']);
        
        imdata3 = imread([DataUpDir, map, '_DS_FT_demean_SurfaceMap.jpg']);
        
        imdata4 = imread([DataUpDir, map, '_ageByBTdemean_SurfaceMap.jpg']);
        
        imdata5 = imread([DataUpDir, map, '_DS_BT_demean_SurfaceMap.jpg']);
        
        %imdata(LeftMask==255) = 255;
        % imdata = imdata(1:end-80,120:1650,:);
        
        imdata_All (1:1*UnitRow,1:1*UnitColumn,:) = imdata1;
        imdata_All (1*UnitRow+1:2*UnitRow,0.5*UnitColumn+1:1.5*UnitColumn,:) = imdata2;
        imdata_All (2*UnitRow+1:3*UnitRow,1:1*UnitColumn,:) = imdata3;
        imdata_All (1:1*UnitRow,1*UnitColumn+1:2*UnitColumn,:) = imdata4;
        imdata_All (2*UnitRow+1:3*UnitRow,UnitColumn+1:2*UnitColumn,:) = imdata5;
        
        figure
        image(imdata_All)
        axis off          % Remove axis ticks and numbers
        axis image        % Set aspect ratio to obtain square pixels
        OutJPGName=[OutputUpDir,'sub68FullModel', effect, '_', map,'_', covType, '.jpg'];
        eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);
    end
end



