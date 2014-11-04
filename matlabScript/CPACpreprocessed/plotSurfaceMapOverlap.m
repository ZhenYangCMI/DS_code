clear
clc
close all

addpath /home/data/Projects/Zhen/microstate/DPARSF_preprocessed/code/REST_V1.8_121225
addpath /home/data/Projects/Zhen/commonCode/DPARSF_V2.2_130309
addpath /home/data/Projects/Zhen/BIRD/BIRD_code/dynamicAnalysis/BrainNetViewer

imgInputDir = ['/home/data/Projects/Zhen/workingMemory/figs/paper_figs/compStrategies/strategyOverlap/surfacemap'];
cd (imgInputDir)

NMin=-0.01; PMin = 0.01;
NMax=-3; PMax=3; % for overlap of strategies thresholded results, set as -5 and 5; for the overlap set as -3 and 3, for CWAS set -2 2
% for overlap of approaches, set as -2 to 2

Prefix='';
DirImg = dir([imgInputDir,filesep,Prefix,'*L.nii']);

% AFNI colorMap
% ColorMap=[1,1,0;1,0.8,0;1,0.6,0;1,0.4118,0;1,0.2667,0;1,0,0;0,0,1;0,0.2667,1;0,0.4118,1;0,0.6,1;0,0.8,1;0,1,1;];
% ColorMap=[1,1,0;1,0.8,0;1,0.6,0;1,0.4118,0;1,0.2667,0; 64, 224, 208; 106, 90, 205; 30, 144, 255; 255, 255, 0; 220, 20, 60];
% 
% ColorMap=[1,0.8,0;1,0.6,0;1,0.4118,0;1,0.2667,0; 64, 224, 208; 106, 90, 205; 30, 144, 255; 255, 255, 0];


% put a fake one in the middle, make the number of color odd number. All colors on the left of the middle point will be used. The colors on the right side will depends on the value in the image. The last one may not be used. Before plotting, recode the value to be roughly symmetric 
 ColorMap=[106, 196, 255; 106, 90, 205; 230, 123, 184; 255, 255, 255; 228, 108, 10; 225, 227, 0;255,255, 255]; %used for overlap of strategies
%ColorMap=[106 90 205; 255 64 0;255 255 255; 255 255 0; 0 128 0]; % used for overlap of approaches
%ColorMap=[0, 0, 255; 0, 128, 0; 128, 0, 128; 255, 255, 255; 255, 0, 0; 225, 255, 0;255, 255, 255]
ColorMap=ColorMap/255;

% the colorMap used for threshed map
% ColorMap=[1,1,0;1,0.9,0;1,0.8,0;1,0.7,0;1,0.6,0;1,0.5,0;0,0.5,1;0,0.6,1;0,0.7,1;0,0.8,1;0,0.9,1;0,1,1;];
% ColorMap=flipdim(ColorMap,1);
% cmap1 = colorRamp(ColorMap(1:6,:), 32);
% cmap2= colorRamp(ColorMap(7:end,:), 32);
% ColorMap=vertcat(cmap1,cmap2);


surfaceMapOutputDir = imgInputDir;
numImg=length(DirImg)


PicturePrefix='';

ClusterSize=0;

SurfaceMapSuffix='_SurfaceMap.jpg';


ConnectivityCriterion=18;

[BrainNetViewerPath, fileN, extn] = fileparts(which('BrainNet.m'));

SurfFileName=[BrainNetViewerPath,filesep,'Data',filesep,'SurfTemplate',filesep,'BrainMesh_ICBM152_smoothed.nv'];

viewtype='MediumView';



for i=1:numImg
    InputName = [imgInputDir,filesep,DirImg(i).name];
    
    OutputName = [surfaceMapOutputDir,filesep, DirImg(i).name(1:end-4),SurfaceMapSuffix];
    
    H_BrainNet = rest_CallBrainNetViewer(InputName,NMin,PMin,ClusterSize,ConnectivityCriterion,SurfFileName,viewtype,ColorMap,NMax,PMax);
    
    eval(['print -r300 -djpeg -noui ''',OutputName,''';']);
end

