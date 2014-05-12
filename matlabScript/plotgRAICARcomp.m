

clear
clc
close all

% define path and variables
mapType='threshed0.8'
numComp=33;
compDir='/home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/gRAICAR_PR_autoDim_ANTs/compMaps/'
thresh=0.8;
mkdir ([compDir, mapType])
for i=1:numComp
    compID=num2str(i)
    if i<10
        FileName=[compDir, 'comp00', compID, '.nii']
    else
        FileName=[compDir, 'comp0', compID, '.nii']
    end
    [Outdata,VoxDim,Header]=rest_readfile(FileName);
    [nDim1 nDim2 nDim3]=size(Outdata);
    img1D=reshape(Outdata, [], 1);
    img1D(find(abs(img1D)<thresh))=0;
    img=reshape(img1D, nDim1,nDim2, nDim3);
    outFile=[compDir, mapType, '/', mapType, 'Comp00', compID, '.nii']
    rest_WriteNiftiImage(img,Header,outFile)
end

Prefix='';
imgInputDir = [compDir, mapType];
NMin=-0.001; PMin = 0.001;
NMax=-3; PMax=3;
DirImg = dir([imgInputDir,filesep,Prefix,'*.nii']);
% AFNI colorMap
%ColorMap=[1,1,0;1,0.8,0;1,0.6,0;1,0.4118,0;1,0.2667,0;1,0,0;0,0,1;0,0.2667,1;0,0.4118,1;0,0.6,1;0,0.8,1;0,1,1;];
% the colorMap used in the pib
ColorMap=[1,1,0;1,0.9,0;1,0.8,0;1,0.7,0;1,0.6,0;1,0.5,0;0,0.5,1;0,0.6,1;0,0.7,1;0,0.8,1;0,0.9,1;0,1,1;];
ColorMap=flipdim(ColorMap,1);
cmap1 = colorRamp(ColorMap(1:6,:), 32);
cmap2= colorRamp(ColorMap(7:end,:), 32);
ColorMap=vertcat(cmap1,cmap2);

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
