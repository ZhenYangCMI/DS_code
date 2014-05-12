
% This script will combine individual surface map for into one panel

clear
clc
close all
%%%Get the Surface maps
covTypeList={'noGSR','GSR', 'gCor', 'compCor'};
mapList={'zstats'}; %'cluster_mask', 'thresh', 'zstats'
effectList={'Linear'} % 'Linear', or 'Quadratic'
%modelist={'FTSep', 'BTSep'};  % 'fullModel', or 'FTSep', 'BTSep'

for j=1:length(covTypeList)
    covType=char(covTypeList{j})
    
    for n=1:length(effectList)
        effect=char(effectList{n})
        
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
            
            
            DataUpDir1 = ['/home2/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/CWAS68sub/FTSep', effect, 'FWHM8.mdmr/surfaceMap/'];
            DataUpDir2 = ['/home2/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/CWAS68sub/BTSep', effect, 'FWHM8.mdmr/surfaceMap/'];
            
            mkdir (['/home2/data/Projects/workingMemory/figs/CWAS_', covType, '/FTBTSep', effect, 'FWHM8/'])
            OutputUpDir = ['/home2/data/Projects/workingMemory/figs/CWAS_', covType, '/FTBTSep', effect, 'FWHM8/'];
            
            imdata1 = imread([DataUpDir1, map, '_ageByFTdemean_SurfaceMap.jpg']);
            %imdata6=imdata6(1:end,120:1200,:); take a part of the image
            imdata2 = imread([DataUpDir1, map, '_age_demean_SurfaceMap.jpg']);
            imdata3 = imread([DataUpDir1, map, '_DS_FT_demean_SurfaceMap.jpg']);
            
            imdata4 = imread([DataUpDir2, map, '_ageByBTdemean_SurfaceMap.jpg']);
            %imdata6=imdata6(1:end,120:1200,:); take a part of the image
            imdata5 = imread([DataUpDir2, map, '_age_demean_SurfaceMap.jpg']);
            imdata6 = imread([DataUpDir2, map, '_DS_BT_demean_SurfaceMap.jpg']);
            
            %imdata(LeftMask==255) = 255;
            % imdata = imdata(1:end-80,120:1650,:);
            
            % This is for 5 rows and 2 columns
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
            OutJPGName=[OutputUpDir,'sub68FTBTSep','_', effect, '_',  map, '_', covType, '.jpg'];
            eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);
        end
    end
end





