
% This script will combine individual surface map for into one panel for both full and separate models

clear
clc
close all
%%%Get the Surface maps
modelList={'fullModel', 'sepModel'} % sepModel or fullModel
mapList={'thresh', 'zstats', 'cluster_mask'}; % thresh zstats cluster_mask
covTypeList={'compCor', 'gCor', 'GSR', 'noGSR'};

OutputUpDir = ['/home/data/Projects/workingMemory/figs/CPAC_12_16_13/CWAS/'];

for m=1:length(modelList)
    model=char(modelList{m})
    
    for n=1:length(mapList)
        map=char(mapList{n})
        
        if strcmp(model, 'sepModel')
            effectList={'ageByFTdemean', 'DS_FT_demean', 'ageByBTdemean', 'DS_BT_demean', 'ageByTotTdemean', 'DS_TotT_demean'};
        else
            effectList={'ageByFTdemean', 'ageByBTdemean', 'DS_FT_demean', 'DS_BT_demean', 'ageByTotTdemean', 'DS_TotT_demean'};
        end
        
        BackGroundColor = uint8([255*ones(1,1,3)]);
        numRow=length(covTypeList);
        numCol=length(effectList);
        
        img=[];
        t=0;
        for i=1:numRow
            row=char(covTypeList{i})
            for j=1:numCol
                col=char(effectList{j})
                t=t+1
                
                if strcmp(model, 'fullModel')
                    if strcmp(col, 'ageByTotTdemean') | strcmp(col, 'DS_TotT_demean')
                        imgDir=['/home/data/Projects/workingMemory/results/CPAC_12_16_13/groupAnalysis/', row, '/CWAS3mm/TotTSepFWHM8.mdmr/surfaceMap/'];
                    else
                    imgDir=['/home/data/Projects/workingMemory/results/CPAC_12_16_13/groupAnalysis/', row, '/CWAS3mm/fullModelFWHM8.mdmr/surfaceMap/']
                    end
                    img{t,1} = {[imgDir, map, '_', col, '_SurfaceMap.jpg']};
                   
                else
                    if strcmp(col, 'ageByFTdemean') | strcmp(col, 'DS_FT_demean')
                        imgDir=['/home/data/Projects/workingMemory/results/CPAC_analysis_new/groupAnalysis/', row, '/CWAS/FTSepFWHM8.mdmr/surfaceMap/']
                    elseif strcmp(col, 'ageByBTdemean') | strcmp(col, 'DS_BT_demean')
                        imgDir=['/home/data/Projects/workingMemory/results/CPAC_analysis_new/groupAnalysis/', row, '/CWAS/BTSepFWHM8.mdmr/surfaceMap/']
                    else
                        imgDir='/home/data/Projects/workingMemory/results/CPAC_12_16_13/groupAnalysis/', row, '/CWAS3mm/TotTSepModelFWHM8.mdmr/surfaceMap/'
                    end
                    img{t,1} = {[imgDir, map, '_', col, '_SurfaceMap.jpg']};
                    
                end
            end
        end
        
        for k=1: numRow*numCol
            fileRead=char(img{k})
            imdata(:, :, :, k)=imread(fileRead);
        end
        
        % define the size of the row, the column, and the whole picture
        UnitRow = size(imdata,1); % this num should be corresponding to the size(imdata, 1)
        
        UnitColumn = size(imdata,2); % this num should be corresponding to the size(imdata, 2)
        
        imdata_All = repmat(BackGroundColor,[UnitRow*numRow,UnitColumn*numCol,1]);
        
        
        k=0
        for m=1:numRow
            for n=1:numCol
                k=k+1
                imdata_All (1+(m-1)*UnitRow:m*UnitRow,1+(n-1)*UnitColumn:n*UnitColumn,:) = imdata(:, :, :, k);
            end
        end
        
        figure
        image(imdata_All)
        axis off          % Remove axis ticks and numbers
        axis image        % Set aspect ratio to obtain square pixels
        OutJPGName=[OutputUpDir,'CWAS_', map, '_', model, '.jpg'];
        eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);
        
        
    end
end



