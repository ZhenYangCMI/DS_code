
% This script will combine individual surface map for into one panel

clear
clc
close all
%%%Get the Surface maps
measure='DegreeCentrality_PositiveBinarizedSumBrain'; % 'DegreeCentrality_PositiveBinarizedSumBrain', 'ReHo', 'CWAS'

BackGroundColor = uint8([255*ones(1,1,3)]);

%imdata_All = 255*ones(UnitRow*length(MeasureSet),UnitColumn*length(ConditionList),3);

if strcmp(measure, 'CWAS')
  strategyList={'noGSR', 'GSR', 'gCor', 'compCor'}
else
strategyList={'noGSR', 'GSR', 'gCor', 'compCor', 'meanRegress'}
end

numRow=length(strategyList);
numCol=length(strategyList); 

OutputUpDir = ['/home/data/Projects/workingMemory/figs/'];
img=[];
t=0;


for i=1:numRow
    row=char(strategyList{i})
    for j=1:numCol
        col=char(strategyList{j})
        t=t+1
        img{t,1} = {['/home/data/Projects/workingMemory/figs/cmpStrategies/', measure, '_', row, '_', col, '.png']};
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
    OutJPGName=[OutputUpDir,measure, '_cmbCmpStrategyScatter.png'];
    eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);
end




