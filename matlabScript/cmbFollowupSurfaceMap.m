
% This script will combine individual surface map for into one panel 

clear
clc
close all
%%%Get the Surface maps
ROImaskGroup={'adoles_BT'}; % Thishis is only for adoles_BT
totPlot=23;
%groupList={'child_BT', 'child_FT', 'adoles_BT', 'adoles_FT'}, this this is
%used to organize subject according to their FT and BT scores, in ascedning
%order
groupList={'child_BT'}

for k=1:length(ROImaskGroup)
    ROImask=char(ROImaskGroup{k})
    
    for t=1:length(groupList)
        group=char(groupList{t})
        
        subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_', group,'.txt']);
        numSub=length(subList);
        
        UnitRow = 2168;
        
        %UnitColumn = 1531*2;
        UnitColumn = 3095;
        
        BackGroundColor = uint8([255*ones(1,1,3)]);
        
        %imdata_All = 255*ones(UnitRow*length(MeasureSet),UnitColumn*length(ConditionList),3);
        
        numRow=3;
        numColumn=4;
        
        imdata_All1 = repmat(BackGroundColor,[UnitRow*numRow,UnitColumn*numColumn,1]);
        imdata_All2 = repmat(BackGroundColor,[UnitRow*numRow,UnitColumn*numColumn,1]);
        
        %LeftMaskFile = '/home/data/HeadMotion_YCG/YAN_Scripts/HeadMotion/Parts/Left2FigureMask_BrainNetViewerMediumView.jpg';
        
        DataUpDir = ['/home2/data/Projects/workingMemory/figs/CWAS/46sub/CWAS_followup/', ROImask, '/'];
        
        OutputUpDir = ['/home2/data/Projects/workingMemory/figs/CWAS/46sub/CWAS_followup/combined/'];
        
        SurfaceMapSuffix='_SurfaceMap.jpg';
        
        
        % plot the first 12 subjects
        for j=1:12
            j
            sub=num2str(subList(j));
            
            %LeftMask = imread(LeftMaskFile);
            imdata = imread([DataUpDir, 'z', ROImask, '_', sub,SurfaceMapSuffix]);
            
            %imdata(LeftMask==255) = 255;
            % imdata = imdata(1:end-80,120:1650,:);
            
            imdata=imdata(1:end,120:3214,:);
            if rem(j, 3)~=0
                row=rem(j,3)
                column=ceil(j/3)
                imdata_All1 (((rem(j,3)-1)*UnitRow + 1):rem(j,3)*UnitRow,((ceil(j/3)-1)*UnitColumn + 1):ceil(j/3)*UnitColumn,:) = imdata;
            else
                imdata_All1 ((2*UnitRow + 1):3*UnitRow,((ceil(j/3)-1)*UnitColumn + 1):ceil(j/3)*UnitColumn,:) = imdata;
                row=3
                column=ceil(j/3)
            end
        end
        
        figure
        image(imdata_All1)
        axis off          % Remove axis ticks and numbers
        axis image        % Set aspect ratio to obtain square pixels
        OutJPGName=[OutputUpDir,'z', ROImask, 'Mask_', group, 'Groupsub1to12.jpg'];
        eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);
        
        
                % plot sub 13-23
        for j=13:23
            j
            sub=num2str(subList(j));
            
                        %LeftMask = imread(LeftMaskFile);
            imdata = imread([DataUpDir, 'z', ROImask, '_', sub,SurfaceMapSuffix]);
            
            %imdata(LeftMask==255) = 255;
            % imdata = imdata(1:end-80,120:1650,:);
            
            imdata=imdata(1:end,120:3214,:);
            if rem(j-12, 3)~=0
                row=rem(j-12,3)
                column=ceil((j-12)/3)
                imdata_All2 (((rem(j-12,3)-1)*UnitRow + 1):rem(j-12,3)*UnitRow,((ceil((j-12)/3)-1)*UnitColumn + 1):ceil((j-12)/3)*UnitColumn,:) = imdata;
            else
                imdata_All2 ((2*UnitRow + 1):3*UnitRow,((ceil((j-12)/3)-1)*UnitColumn + 1):ceil((j-12)/3)*UnitColumn,:) = imdata;
                row=3
                column=ceil((j-12)/3)
            end
        end
        
        figure
        image(imdata_All2)
        axis off          % Remove axis ticks and numbers
        axis image        % Set aspect ratio to obtain square pixels
        OutJPGName=[OutputUpDir,'z', ROImask, 'Mask_', group, 'Groupsub13to23.jpg'];
        eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);
    end
end



