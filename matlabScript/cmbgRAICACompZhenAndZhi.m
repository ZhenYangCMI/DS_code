
% This script will combine individual surface map for into one panel

clear
clc
close all
%%%Get the Surface maps
type='compMatch_ANTsAndZhi_unthreshed' % control the output name
numComp=36;
dataDir1='/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/gRAICAR_PR_autoDim_ANTs/compMaps/unthreshed/';
dataDir2='/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/gRAICAR_PR_autoDim_Zhi_new/compMaps/unthreshed/';

compListZhen=[1 2 5 20 4 31 6 10 3 7 15 13 9 26 17 37 14 11] % ANTs 

%compListZhen=[10 4 27 52 25 41 54 29 12 17 18 22 33 38 4 10 29 24] % mathced according to the spatial correlations
%of unthresholded maps with Zhi's complist. CA4 and 6 are matched with 52 and 41 which are the seond and the third
%largest correlations as both of them are originally matched with 54 and,
%CA7 has the highest correlation with 54, %fnirt+BBR

% the unmatched ones are replaced by comp2 the empty map. Using Zhen's warp
%compList=[10 4 27 2 25 54 24 29 1 17 18 22 33 2 14 36 2 23] % matched by
%visually insepct the thresholed (Z>0.5) map fnirt+BRR

compListZhi=[1 2 6 20 4 29 5 17 3 9 15 13 10 30 11 34 8 12] % the
%unmatched ones are replaced by comp2 the empty map. Using Zhi's warp

compListZhenAndZhi=reshape([compListZhen;compListZhi], 1, [])
numRow=6;
numCol=6;

OutputUpDir = ['/home/data/Projects/workingMemory/figs/gRAICAR/'];

% save the img file path
img=[]
for i=1:numComp
    t=compListZhenAndZhi(i)
    if mod(i,2)~=0
        img{i,1} = [dataDir1,'unthreshedComp00', num2str(t), '_SurfaceMap.jpg'];
    else
        img{i,1} = [dataDir2,'unthreshedComp00', num2str(t), '_SurfaceMap.jpg'];
    end
end

% read in the img and save them as one matrixs
for k=1: numRow*numCol
    if k<numComp+1
        fileRead=img{k}
        imdata(:, :, :, k)=imread(fileRead);
    end
end

UnitRow = size(imdata, 1); % this num should be corresponding to the size(imdata1, 1)

UnitColumn = size(imdata, 2); % this num should be corresponding to the size(imdata1, 2)


BackGroundColor = uint8([255*ones(1,1,3)]);
imdata_All = repmat(BackGroundColor,[UnitRow*numRow,UnitColumn*numCol,1]);


k=0
for m=1:numRow
    for n=1:numCol
        k=k+1
        if k<numComp+1
            imdata_All (1+(m-1)*UnitRow:m*UnitRow,1+(n-1)*UnitColumn:n*UnitColumn,:) = imdata(:, :, :, k);
        end
    end
end
figure
image(imdata_All)
axis off          % Remove axis ticks and numbers
axis image        % Set aspect ratio to obtain square pixels
OutJPGName=[OutputUpDir,'gRAICARcomp_',type, '.jpg'];
eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);




