
% This script will combine individual surface map for into one panel for both full and separate models

clear
clc
close all
%%%Get the Surface maps
preprocessDate='1_1_14'
model='fullModel' % sepModel or fullModel
map='unthresh'; % easythresh unthresh
covTypeList={'meanRegress', 'gCor', 'compCor', 'GSR', 'noGSR'};
%covTypeList={'meanRegress_compCor'}
approachList={'localMeasure', 'gRAICAR'}; % localMeasure or gRAICAR

for n=1:length(covTypeList)
    covType=char(covTypeList{n})
    
    mkdir(['/home/data/Projects/workingMemory/figs/CPAC_', preprocessDate, '/', covType])
    OutputUpDir = ['/home/data/Projects/workingMemory/figs/CPAC_', preprocessDate, '/', covType, '/'];
    for m=1:length(approachList)
        approach=char(approachList{m})
        
        if strcmp(approach, 'localMeasure')
            measureList={'ReHo', 'DegreeCentrality','fALFF', 'VMHC', 'skewness'};
        else
            measureList={'DualRegression0', 'DualRegression1', 'DualRegression2', 'DualRegression3', 'DualRegression4', 'DualRegression5'};
        end
        
        %measureList={'ReHo'};
        numMeasure=length(measureList)
        
        if strcmp(model, 'sepModel')
            effectList={'DF_T3', 'DF_T2', 'DB_T3', 'DB_T2', 'Tot_T3', 'Tot_T2'};
        else
            effectList={'Full_T4', 'Full_T5', 'Full_T2', 'Full_T3', 'Tot_T3', 'Tot_T2'};
        end
        
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
                    if strcmp(map, 'unthresh')
                        img{t,1} = {sprintf('/home/data/Projects/workingMemory/results/CPAC_%s/groupAnalysis/%s/%s/unthresh/%s_%s_Z_SurfaceMap.jpg', preprocessDate, covType, row, row, col)};
                    else
                        img{t,1} = {sprintf('/home/data/Projects/workingMemory/results/CPAC_%s/groupAnalysis/%s/%s/easythresh/cmb/thresh_%s_%s_Z_cmb_SurfaceMap.jpg', preprocessDate, covType, row, row, col)};
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
        OutJPGName=[OutputUpDir, covType, '_', approach, '_', map, '_', model, '.jpg'];
        eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);
        
    end
    
end



