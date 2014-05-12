
% This script will plot individual surface map

clear
clc
close all
%%%Get the Surface maps
covType='GSR'
ROImaskGroup='fullModel'; 
groupList={'adoles', 'child'}

for k=1:length(groupList)
    group=char(groupList{k})
    
    imgInputDir = ['/home2/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/68sub/followup/', ROImaskGroup, '/CWASDSregressFC/easythresh/'];
    surfaceMapOutputDir = imgInputDir;
    
    NMin=-0.001; PMin = 0.001;
    NMax=-5; PMax=5;
    
    % AFNI colorMap
    %ColorMap=[1,1,0;1,0.8,0;1,0.6,0;1,0.4118,0;1,0.2667,0;1,0,0;0,0,1;0,0.2667,1;0,0.4118,1;0,0.6,1;0,0.8,1;0,1,1;];
    % the colorMap used in the pib
    ColorMap=[1,1,0;1,0.9,0;1,0.8,0;1,0.7,0;1,0.6,0;1,0.5,0;0,0.5,1;0,0.6,1;0,0.7,1;0,0.8,1;0,0.9,1;0,1,1;];
    ColorMap=flipdim(ColorMap,1);
    cmap1 = colorRamp(ColorMap(1:6,:), 32);
    cmap2= colorRamp(ColorMap(7:end,:), 32);
    ColorMap=vertcat(cmap1,cmap2);
    
    %ColorMap=jet(12);
    
    Prefix='';
    
    PicturePrefix='';
    
    ClusterSize=0;
    
    SurfaceMapSuffix='_SurfaceMap.jpg';
    
    
    ConnectivityCriterion=18;
    
    [BrainNetViewerPath, fileN, extn] = fileparts(which('BrainNet.m'));
    
    SurfFileName=[BrainNetViewerPath,filesep,'Data',filesep,'SurfTemplate',filesep,'BrainMesh_ICBM152_smoothed.nv'];
    
    viewtype='MediumView';
    
            numSeed=2;
        for i=1:numSeed
            InputName=[imgInputDir, 'thresh_', group, '_ROI', num2str(i), '_T1_Z_cmb.nii'];
            OutputName = [surfaceMapOutputDir,'thresh_', group, '_ROI', num2str(i), '_T1_Z_cmb', SurfaceMapSuffix];
            H_BrainNet = rest_CallBrainNetViewer(InputName,NMin,PMin,ClusterSize,ConnectivityCriterion,SurfFileName,viewtype,ColorMap,NMax,PMax);
            eval(['print -r300 -djpeg -noui ''',OutputName,''';']);
        end
    
end



