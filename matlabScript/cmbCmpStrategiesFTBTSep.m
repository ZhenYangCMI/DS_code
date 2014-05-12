
% This script will combine individual surface map for into one panel

clear
clc
close all
%%%Get the Surface maps
OutputUpDir = ['/home/data/Projects/workingMemory/figs/cmpStrategies/'];

measure='CWAS'; % 'DegreeCentrality_PositiveBinarizedSumBrain', 'ReHo', 'CWAS'


%imdata_All = 255*ones(UnitRow*length(MeasureSet),UnitColumn*length(ConditionList),3);

if strcmp(measure, 'CWAS')
    strategyList={'noGSR', 'GSR', 'gCor', 'compCor'};
    effectListFT={'ageByFTdemean', 'age_demean', 'DS_FT_demean'};
    effectListBT={'ageByBTdemean', 'age_demean', 'DS_BT_demean'};
    mapList={'zstats', 'thresh', 'cluster_mask'};
else
    strategyList={'noGSR', 'GSR', 'gCor', 'compCor', 'meanRegress'};
    effectListFT={'T3', 'T2', 'T1'};
    effectListBT={'T3', 'T2', 'T1'};
    mapList={'unthreshed', 'easythresh'};
    %mapList={'easythresh'};
end

for k=1:length(mapList)
    map=char(mapList{k})
    close all
    BackGroundColor = uint8([255*ones(1,1,3)]);
    numRow=length(effectListFT);
    numCol=length(strategyList);
    
    img1=[];
    t=0;
    
    for i=1:numRow
        row=char(effectListFT{i})
        for j=1:numCol
            col=char(strategyList{j})
            t=t+1
            if strcmp(measure, 'CWAS')
                img1{t,1} = {['/home/data/Projects/workingMemory/groupAnalysis/CWAS_', col, '/CWAS68sub/FTSepLinearFWHM8.mdmr/surfaceMap/', map, '_', row, '_SurfaceMap.jpg']};
            else
                if strcmp(map, 'unthreshed')
                    img1{t,1} = {['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_', col, '/FTBTSepModel/linear/FT/', measure, '/', map, '/', measure, '_FT_', row, '_Z_SurfaceMap.jpg']};
                else
                    img1{t,1} = {['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_', col, '/FTBTSepModel/linear/FT/', measure, '/', map, '/cmb/thresh_', measure, '_FT_', row, '_Z_cmb_SurfaceMap.jpg']};
                end
                
            end
        end
    end
    
    img2=[];
    t=0;
    
    for i=1:numRow
        row=char(effectListBT{i})
        for j=1:numCol
            col=char(strategyList{j})
            t=t+1
            if strcmp(measure, 'CWAS')
                img2{t,1} = {['/home/data/Projects/workingMemory/groupAnalysis/CWAS_', col, '/CWAS68sub/BTSepLinearFWHM8.mdmr/surfaceMap/', map, '_', row, '_SurfaceMap.jpg']};
            else
                if strcmp(map, 'unthreshed')
                    img2{t,1} = {['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_', col, '/FTBTSepModel/linear/BT/', measure, '/', map, '/', measure, '_BT_', row, '_Z_SurfaceMap.jpg']};
                else
                    img2{t,1} = {['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_', col, '/FTBTSepModel/linear/BT/', measure, '/', map, '/cmb/thresh_', measure, '_BT_', row, '_Z_cmb_SurfaceMap.jpg']};
                end
                
            end
        end
    end
    
    img=vertcat(img1, img2)
    
    for k=1: numRow*2*numCol
        fileRead=char(img{k})
        imdata(:, :, :, k)=imread(fileRead);
    end
    
    % define the size of the row, the column, and the whole picture
    UnitRow = size(imdata,1); % this num should be corresponding to the size(imdata, 1)
    
    UnitColumn = size(imdata,2); % this num should be corresponding to the size(imdata, 2)
    
    imdata_All = repmat(BackGroundColor,[UnitRow*numRow*2,UnitColumn*numCol,1]);
    
    
    k=0
    for m=1:numRow*2
        for n=1:numCol
            k=k+1
            imdata_All (1+(m-1)*UnitRow:m*UnitRow,1+(n-1)*UnitColumn:n*UnitColumn,:) = imdata(:, :, :, k);
        end
        
        figure
        image(imdata_All)
        axis off          % Remove axis ticks and numbers
        axis image        % Set aspect ratio to obtain square pixels
        OutJPGName=[OutputUpDir,measure, '_', map, '_cmbCmpStrategiesFTBTSep.png'];
        eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);
    end
    
end


