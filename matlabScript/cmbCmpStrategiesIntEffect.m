
% This script will combine individual surface map for into one panel

clear
clc
close all
%%%Get the Surface maps
OutputUpDir = ['/home/data/Projects/workingMemory/figs/cmpStrategies/'];

measure='ReHo'; % 'DegreeCentrality_PositiveBinarizedSumBrain', 'ReHo', 'CWAS'
strategyList={'noGSR', 'GSR', 'gCor', 'compCor', 'meanRegress'};

%imdata_All = 255*ones(UnitRow*length(MeasureSet),UnitColumn*length(ConditionList),3);

if strcmp(measure, 'ReHo')
    
    mapList={'negcluster1', 'negcluster2', 'poscluster1'};
elseif strcmp(measure, 'DegreeCentrality_PositiveBinarizedSumBrain')
    
    mapList={'negcluster1', 'negcluster2', 'negcluster3', 'negcluster4'};
    %mapList={'poscluster1', 'poscluster2', 'poscluster3', 'poscluster4', 'poscluster5', 'poscluster6'};
    end


for k=1:length(mapList)
    
    map=char(mapList{k})
    
    
    BackGroundColor = uint8([255*ones(1,1,3)]);
    numRow=length(mapList);
    numCol=length(strategyList);
    
    img=[];
    t=0;
    for i=1:numRow
        row=char(mapList{i})
        for j=1:numCol
            col=char(strategyList{j})
            t=t+1
            
            img{t,1} = {['/home/data/Projects/workingMemory/figs/cmpStrategies/', measure, '_INTageByFT', row, '_', col, '.png']};
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
OutJPGName=[OutputUpDir,measure, '_', map, '_cmbCmpStrategiesInt.png'];
eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);





