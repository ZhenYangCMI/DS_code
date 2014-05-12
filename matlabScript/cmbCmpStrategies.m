
% This script will combine individual surface map for into one panel

clear
clc
close all
%%%Get the Surface maps
OutputUpDir = ['/home/data/Projects/workingMemory/figs/cmpStrategies/'];

measure='ReHo'; % 'DegreeCentrality_PositiveBinarizedSumBrain', 'ReHo', 'CWAS'


%imdata_All = 255*ones(UnitRow*length(MeasureSet),UnitColumn*length(ConditionList),3);

if strcmp(measure, 'CWAS')
    strategyList={'noGSR', 'GSR', 'gCor', 'compCor'};
    effectList={'ageByFTdemean', 'ageByBTdemean', 'age_demean', 'DS_FT_demean', 'DS_BT_demean'};
    mapList={'zstats', 'thresh', 'cluster_mask'};
else
    strategyList={'noGSR', 'GSR', 'gCor', 'compCor', 'meanRegress'};
    effectList={'T4', 'T5', 'T1', 'T2', 'T3'};
    mapList={'unthreshed', 'easythresh'};
    %mapList={'easythresh'};
end

for k=1:length(mapList)
    map=char(mapList{k})
    close all
    BackGroundColor = uint8([255*ones(1,1,3)]);
    numRow=length(effectList);
    numCol=length(strategyList);
    
    img=[];
    t=0;
    
    for i=1:numRow
        row=char(effectList{i})
        for j=1:numCol
            col=char(strategyList{j})
            t=t+1
            if strcmp(measure, 'CWAS')
                img{t,1} = {['/home/data/Projects/workingMemory/groupAnalysis/CWAS_', col, '/CWAS68sub/fullModelLinearFWHM8.mdmr/surfaceMap/', map, '_', row, '_SurfaceMap.jpg']};
            else
                if strcmp(map, 'unthreshed')
                    img{t,1} = {['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_', col, '/fullModel/linear/', measure, '/', map, '/', measure, '_Full_', row, '_Z_SurfaceMap.jpg']};
                else
                    img{t,1} = {['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_', col, '/fullModel/linear/', measure, '/', map, '/cmb/thresh_', measure, '_Full_', row, '_Z_cmb_SurfaceMap.jpg']};
                end
                
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
        
        figure
        image(imdata_All)
        axis off          % Remove axis ticks and numbers
        axis image        % Set aspect ratio to obtain square pixels
        OutJPGName=[OutputUpDir,measure, '_', map, '_cmbCmpStrategies.png'];
        eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);
    end
    
end


