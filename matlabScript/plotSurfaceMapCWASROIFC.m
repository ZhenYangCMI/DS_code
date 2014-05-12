
% This script will plot individual surface map 

clear
clc
close all
%%%Get the Surface maps
ROImaskGroup={'child_FT'}; % can be 'child_BT' or 'adoles'
mapType='z';

for k=1:length(ROImaskGroup)
    ROImask=char(ROImaskGroup{k})
    
    subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_46sub.txt']);
    numSub=length(subList);
    
    for j=1:numSub
        sub=num2str(subList(j));
        
        imgInputDir = ['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followup/CWAS', ROImask];
        mkdir(['/home2/data/Projects/workingMemory/figs/CWAS/46sub/CWAS_followup/', ROImask]);
        surfaceMapOutputDir = ['/home2/data/Projects/workingMemory/figs/CWAS/46sub/CWAS_followup/', ROImask, '/'];
        
        NMin=-0.001; PMin = 0.001;
        NMax=-0.5; PMax=0.5;
        
        % AFNI colorMap
        %ColorMap=[1,1,0;1,0.8,0;1,0.6,0;1,0.4118,0;1,0.2667,0;1,0,0;0,0,1;0,0.2667,1;0,0.4118,1;0,0.6,1;0,0.8,1;0,1,1;];
        % the colorMap used in the pib
        ColorMap=[1,1,0;1,0.9,0;1,0.8,0;1,0.7,0;1,0.6,0;1,0.5,0;0,0.5,1;0,0.6,1;0,0.7,1;0,0.8,1;0,0.9,1;0,1,1;];
        ColorMap=flipdim(ColorMap,1);
        cmap1 = colorRamp(ColorMap(1:6,:), 32);
        cmap2= colorRamp(ColorMap(7:end,:), 32);
        ColorMap=vertcat(cmap1,cmap2)
        
        %ColorMap=jet(12);
        
        Prefix='';
        
        PicturePrefix='';
        
        ClusterSize=0;
        
        SurfaceMapSuffix='_SurfaceMap.jpg';
        
        
        ConnectivityCriterion=18;
        
        [BrainNetViewerPath, fileN, extn] = fileparts(which('BrainNet.m'));
        
        SurfFileName=[BrainNetViewerPath,filesep,'Data',filesep,'SurfTemplate',filesep,'BrainMesh_ICBM152_smoothed.nv'];
        
        viewtype='MediumView';
        
        if strcmp(ROImask, 'adoles_BT')
            InputName = [imgInputDir,filesep,'z', ROImask, '_', sub, '.nii'];
            OutputName = [surfaceMapOutputDir,'z', ROImask, '_', sub, SurfaceMapSuffix];
            H_BrainNet = rest_CallBrainNetViewer(InputName,NMin,PMin,ClusterSize,ConnectivityCriterion,SurfFileName,viewtype,ColorMap,NMax,PMax);
            eval(['print -r300 -djpeg -noui ''',OutputName,''';']);
        elseif strcmp(ROImask, 'child_BT')
            numSeed=2;
            for i=1:numSeed
                InputName = [imgInputDir,filesep,'zROI', num2str(i), ROImask, '_', sub, '.nii'];
                OutputName = [surfaceMapOutputDir,'zROI', num2str(i), ROImask, '_', sub, SurfaceMapSuffix];
                H_BrainNet = rest_CallBrainNetViewer(InputName,NMin,PMin,ClusterSize,ConnectivityCriterion,SurfFileName,viewtype,ColorMap,NMax,PMax);
                eval(['print -r300 -djpeg -noui ''',OutputName,''';']);
            end
        elseif strcmp(ROImask, 'child_FT')
            numSeed=4;
            for i=1:numSeed
                InputName = [imgInputDir,filesep,'zROI', num2str(i), ROImask, '_', sub, '.nii'];
                OutputName = [surfaceMapOutputDir,'zROI', num2str(i), ROImask, '_', sub, SurfaceMapSuffix];
                H_BrainNet = rest_CallBrainNetViewer(InputName,NMin,PMin,ClusterSize,ConnectivityCriterion,SurfFileName,viewtype,ColorMap,NMax,PMax);
                eval(['print -r300 -djpeg -noui ''',OutputName,''';']);
            end
        end
        
    end
end



