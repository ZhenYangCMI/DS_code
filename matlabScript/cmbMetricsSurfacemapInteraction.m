
% This script will combine individual surface map for into one panel

clear
clc
close all
%%%Get the Surface maps


UnitRow = 2168; % this num should be corresponding to the size(imdata1, 1)

%UnitColumn = 1531*2;
UnitColumn = 3334; % this num should be corresponding to the size(imdata1, 2)


BackGroundColor = uint8([255*ones(1,1,3)]);

%imdata_All = 255*ones(UnitRow*length(MeasureSet),UnitColumn*length(ConditionList),3);

numRow=6;
numCol=6;

imdata_All = repmat(BackGroundColor,[UnitRow*numRow,UnitColumn*numCol,1]);


%LeftMaskFile = '/home/data/HeadMotion_YCG/YAN_Scripts/HeadMotion/Parts/Left2FigureMask_BrainNetViewerMediumView.jpg';

OutputUpDir = ['/home/data/Projects/workingMemory/figs/'];
% T1: ME of age; T2: ME of FT; T3:  ME of BT; T4: ageByFT; T5: ageByBT
% CWAS
img1 = ['/home/data/Projects/workingMemory/groupAnalysis/CWAS_noGSR/CWAS68sub/fullModelLinearFWHM8.mdmr/surfaceMap/thresh_ageByFTdemean_SurfaceMap.jpg'];
img2 = ['/home/data/Projects/workingMemory/groupAnalysis/CWAS_noGSR/CWAS68sub/fullModelLinearFWHM8.mdmr/surfaceMap/thresh_ageByBTdemean_SurfaceMap.jpg'];
img3 = ['/home/data/Projects/workingMemory/groupAnalysis/CWAS_GSR/68sub/CWAS68sub/fullModelLinearFWHM8.mdmr/surfaceMap/thresh_ageByFTdemean_SurfaceMap.jpg'];
img4 = ['/home/data/Projects/workingMemory/groupAnalysis/CWAS_GSR/68sub/CWAS68sub/fullModelLinearFWHM8.mdmr/surfaceMap/thresh_ageByBTdemean_SurfaceMap.jpg'];
img5 = ['/home/data/Projects/workingMemory/groupAnalysis/CWAS_gCor/fullModelLinearFWHM8.mdmr/surfaceMap/thresh_ageByFTdemean_SurfaceMap.jpg'];
img6 = ['/home/data/Projects/workingMemory/groupAnalysis/CWAS_gCor/fullModelLinearFWHM8.mdmr/surfaceMap/thresh_ageByBTdemean_SurfaceMap.jpg'];

% ReHo
img7 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_noGSR/fullModel/linear/ReHo/easythresh/cmb/thresh_ReHo_Full_T4_Z_cmb_SurfaceMap.jpg'];
img8 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_noGSR/fullModel/linear/ReHo/easythresh/cmb/thresh_ReHo_Full_T5_Z_cmb_SurfaceMap.jpg'];
img9 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_GSR/fullModel/linear/ReHo/easythresh/cmb/thresh_ReHo_Full_T4_Z_cmb_SurfaceMap.jpg'];
img10 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_GSR/fullModel/linear/ReHo/easythresh/cmb/thresh_ReHo_Full_T5_Z_cmb_SurfaceMap.jpg'];
img11 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_gCor/fullModel/linear/ReHo/easythresh/cmb/thresh_ReHo_Full_T4_Z_cmb_SurfaceMap.jpg'];
img12 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_gCor/fullModel/linear/ReHo/easythresh/cmb/thresh_ReHo_Full_T5_Z_cmb_SurfaceMap.jpg'];

% DC
img13 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_noGSR/fullModel/linear/DegreeCentrality_PositiveBinarizedSumBrain_FullBrain/easythresh/cmb/thresh_DegreeCentrality_PositiveBinarizedSumBrain_Full_T4_Z_cmb_SurfaceMap.jpg'];
img14 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_noGSR/fullModel/linear/DegreeCentrality_PositiveBinarizedSumBrain_FullBrain/easythresh/cmb/thresh_DegreeCentrality_PositiveBinarizedSumBrain_Full_T5_Z_cmb_SurfaceMap.jpg'];
img15 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_GSR/fullModel/linear/DegreeCentrality_PositiveBinarizedSumBrain_FullBrain/easythresh/cmb/thresh_DegreeCentrality_PositiveBinarizedSumBrain_Full_T4_Z_cmb_SurfaceMap.jpg'];
img16 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_GSR/fullModel/linear/DegreeCentrality_PositiveBinarizedSumBrain_FullBrain/easythresh/cmb/thresh_DegreeCentrality_PositiveBinarizedSumBrain_Full_T5_Z_cmb_SurfaceMap.jpg'];
img17 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_gCor/fullModel/linear/DegreeCentrality_PositiveBinarizedSumBrain_FullBrain/easythresh/cmb/thresh_DegreeCentrality_PositiveBinarizedSumBrain_Full_T4_Z_cmb_SurfaceMap.jpg'];
img18 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_gCor/fullModel/linear/DegreeCentrality_PositiveBinarizedSumBrain_FullBrain/easythresh/cmb/thresh_DegreeCentrality_PositiveBinarizedSumBrain_Full_T5_Z_cmb_SurfaceMap.jpg'];

% fALFF
img19 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_noGSR/fullModel/linear/fALFF/easythresh/cmb/thresh_fALFF_Full_T4_Z_cmb_SurfaceMap.jpg'];
img20 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_noGSR/fullModel/linear/fALFF/easythresh/cmb/thresh_fALFF_Full_T5_Z_cmb_SurfaceMap.jpg'];
img21 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_GSR/fullModel/linear/fALFF/easythresh/cmb/thresh_fALFF_Full_T4_Z_cmb_SurfaceMap.jpg'];
img22 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_GSR/fullModel/linear/fALFF/easythresh/cmb/thresh_fALFF_Full_T5_Z_cmb_SurfaceMap.jpg'];
img23 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_gCor/fullModel/linear/fALFF/easythresh/cmb/thresh_fALFF_Full_T4_Z_cmb_SurfaceMap.jpg'];
img24 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_gCor/fullModel/linear/fALFF/easythresh/cmb/thresh_fALFF_Full_T5_Z_cmb_SurfaceMap.jpg'];

% VMHC
img25 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_noGSR/fullModel/linear/VMHC/easythresh/cmb/thresh_VMHC_Full_T4_Z_cmb_SurfaceMap.jpg'];
img26 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_noGSR/fullModel/linear/VMHC/easythresh/cmb/thresh_VMHC_Full_T5_Z_cmb_SurfaceMap.jpg'];
img27 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_GSR/fullModel/linear/VMHC/easythresh/cmb/thresh_VMHC_Full_T4_Z_cmb_SurfaceMap.jpg'];
img28 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_GSR/fullModel/linear/VMHC/easythresh/cmb/thresh_VMHC_Full_T5_Z_cmb_SurfaceMap.jpg'];
img29 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_gCor/fullModel/linear/VMHC/easythresh/cmb/thresh_VMHC_Full_T4_Z_cmb_SurfaceMap.jpg'];
img30 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_gCor/fullModel/linear/VMHC/easythresh/cmb/thresh_VMHC_Full_T5_Z_cmb_SurfaceMap.jpg'];

% skewness
img31 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_noGSR/fullModel/linear/skewness/easythresh/cmb/thresh_skewness_Full_T4_Z_cmb_SurfaceMap.jpg'];
img32 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_noGSR/fullModel/linear/skewness/easythresh/cmb/thresh_skewness_Full_T5_Z_cmb_SurfaceMap.jpg'];
img33 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_GSR/fullModel/linear/skewness/easythresh/cmb/thresh_skewness_Full_T4_Z_cmb_SurfaceMap.jpg'];
img34 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_GSR/fullModel/linear/skewness/easythresh/cmb/thresh_skewness_Full_T5_Z_cmb_SurfaceMap.jpg'];
img35 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_gCor/fullModel/linear/skewness/easythresh/cmb/thresh_skewness_Full_T4_Z_cmb_SurfaceMap.jpg'];
img36 =['/home/data/Projects/workingMemory/groupAnalysis/rawscores/otherMetrics68sub_gCor/fullModel/linear/skewness/easythresh/cmb/thresh_skewness_Full_T5_Z_cmb_SurfaceMap.jpg'];

for k=1: numRow*numCol
    fileRead=eval(sprintf('img%s', num2str(k)))
    imdata(:, :, :, k)=imread(fileRead);
end


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
    OutJPGName=[OutputUpDir,'cmbInteraction1_full.jpg'];
    eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);
end




