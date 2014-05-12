
% This script will combine individual surface map for into one panel

clear
clc
close all
%%%Get the Surface maps
map='easythresh';
covType='meanRegress';


OutputUpDir = ['/home/data/Projects/workingMemory/figs/CPACpreprocessedNew/'];


    measureList={'ReHo', 'DegreeCentrality_PositiveBinarizedSumBrain','fALFF', 'VMHC', 'skewness'};


numMeasure=length(measureList)

effectList={'T4', 'T5', 'T2', 'T3'};

for k=1:length(measureList)
    
    measure=char(measureList{k})
    
    BackGroundColor = uint8([255*ones(1,1,3)]);
    numRow=length(measureList);
    numCol=length(effectList);
    
    img=[];
    t=0;
    for i=1:numRow
        row=char(measureList{i})
        for j=1:numCol
            col=char(effectList{j})
            t=t+1
            if strcmp(map, 'unthreshed')
                img{t,1} = {sprintf('/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_meanRegress/fullModel/linear/%s/unthreshed/%s_Full_%s_Z_SurfaceMap.jpg', row, row, col)};
            else
                img{t,1} = {sprintf('/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_meanRegress/fullModel/linear/%s/easythresh/cmb/thresh_%s_Full_%s_Z_cmb_SurfaceMap.jpg', row, row, col)};
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
end

figure
image(imdata_All)
axis off          % Remove axis ticks and numbers
axis image        % Set aspect ratio to obtain square pixels
OutJPGName=[OutputUpDir,covType, filesep, covType, '_', approach, '_', map 'DPARSF.jpg'];
eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);





