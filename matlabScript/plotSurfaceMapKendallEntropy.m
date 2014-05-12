
% This script will plot individual surface map and combine individual
% ones into one panel

clear
clc
close all
%%%Get the Surface maps
mapType='entropy'; % kendall or entropy

imgInputDir = ['/home/data/Projects/workingMemory/groupAnalysis/rawscores/cmpStrategies/'];
surfaceMapOutputDir = imgInputDir;

if strcmp(mapType, 'kendall')
    NMin=0; PMin = 0.5;
    NMax=0; PMax=1;
     
else
    NMin=0; PMin = 0;
    NMax=0; PMax=0.4;
   
end
ColorMap=jet(12);
% AFNI colorMap
%ColorMap=[1,1,0;1,0.8,0;1,0.6,0;1,0.4118,0;1,0.2667,0;1,0,0;0,0,1;0,0.2667,1;0,0.4118,1;0,0.6,1;0,0.8,1;0,1,1;];
% the colorMap used in the pib
% ColorMap=[1,1,0;1,0.9,0;1,0.8,0;1,0.7,0;1,0.6,0;1,0.5,0;0,0.5,1;0,0.6,1;0,0.7,1;0,0.8,1;0,0.9,1;0,1,1;];
% ColorMap=flipdim(ColorMap,1);
% cmap1 = colorRamp(ColorMap(1:6,:), 32);
% cmap2= colorRamp(ColorMap(7:end,:), 32);
% ColorMap=vertcat(cmap1,cmap2);



Prefix='';

PicturePrefix='';

ClusterSize=0;

SurfaceMapSuffix='_SurfaceMap.jpg';


ConnectivityCriterion=18;

[BrainNetViewerPath, fileN, extn] = fileparts(which('BrainNet.m'));

SurfFileName=[BrainNetViewerPath,filesep,'Data',filesep,'SurfTemplate',filesep,'BrainMesh_ICBM152_smoothed.nv'];

viewtype='MediumView';

DirImg = dir([imgInputDir,filesep, mapType, '*.nii']);


numImg=length(DirImg)

for i=1:numImg
    InputName = [imgInputDir,filesep,DirImg(i).name];
    
    OutputName = [surfaceMapOutputDir,DirImg(i).name(1:end-4), SurfaceMapSuffix];
    
    H_BrainNet = rest_CallBrainNetViewer(InputName,NMin,PMin,ClusterSize,ConnectivityCriterion,SurfFileName,viewtype,ColorMap,NMax,PMax);
    
    eval(['print -r300 -djpeg -noui ''',OutputName,''';']);
end


