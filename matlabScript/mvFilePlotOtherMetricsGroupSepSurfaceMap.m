% this script

clear
clc


measureList={'ReHo', 'ALFF', 'fALFF', 'VMHC', 'DegreeCentrality_PositiveBinarizedSumBrain_FullBrain', 'DegreeCentrality_PositiveWeightedSumBrain_FullBrain',...
    'DegreeCentrality_PositiveBinarizedSumBrain_GreyMatter', 'DegreeCentrality_PositiveWeightedSumBrain_GreyMatter'};

% organize the combined map to a dir
for i=1:length(measureList)
    measure=char(measureList{i})
    cd (['/home/data/Projects/workingMemory/groupAnalysis/groupSep/', measure, '/easythresh/'])
    mkdir cmb
    fileList=dir('thresh_*_cmb.nii')
    for j=1:length(fileList)
        file=fileList(j).name
        movefile (file, 'cmb')
    end
end

% plot surface map
cd /home/data/Projects/workingMemory/code/matlabScript
for i=1:length(measureList)
    measure=char(measureList{i})
    
    imgInputDir = ['/home/data/Projects/workingMemory/groupAnalysis/groupSep/', measure, '/easythresh/cmb'];
    
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
    
    DirImg = dir([imgInputDir,filesep,Prefix,'*.nii']);
    numImg=length(DirImg)
    
    for i=1:numImg
        InputName = [imgInputDir,filesep,DirImg(i).name];
        
        OutputName = [surfaceMapOutputDir,filesep, DirImg(i).name(1:end-4),SurfaceMapSuffix];
        
        H_BrainNet = rest_CallBrainNetViewer(InputName,NMin,PMin,ClusterSize,ConnectivityCriterion,SurfFileName,viewtype,ColorMap,NMax,PMax);
        
        eval(['print -r300 -djpeg -noui ''',OutputName,''';']);
    end
    
end
