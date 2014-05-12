
% This script will plot individual surface map

clear
clc
close all
%%%Get the Surface maps
covTypeList={'noGSR','GSR', 'gCor', 'compCor'}
effectList={'Linear'} % 'Linear', or 'Quadratic'
modelist={'BTSep', 'FTSep', 'fullModel'};  % 'fullModel', or 'FTSep', 'BTSep'
%mapTypeList={'cluster_mask', 'thresh'};
mapTypeList={'zstats'};

for j=1:length(covTypeList)
    covType=char(covTypeList{j})
    
    for m=1:length(modelist)
        model=char(modelist{m})
        
        for n=1:length(effectList)
            effect=char(effectList{n})
            
            imgInputDir = ['/home2/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/CWAS68sub/', model, effect, 'FWHM8.mdmr/'];
            mkdir (['/home2/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/CWAS68sub/', model, effect,'FWHM8.mdmr/surfaceMap/'])
            surfaceMapOutputDir = ['/home2/data/Projects/workingMemory/groupAnalysis/CWAS_', covType, '/CWAS68sub/', model, effect, 'FWHM8.mdmr/surfaceMap/']
            
            for k=1:length(mapTypeList)
                mapType=char(mapTypeList{k})
                
                if strcmp(mapType, 'thresh') || strcmp(mapType, 'zstats')
                    NMin=-0.001; PMin = 0.001;
                    NMax=-4; PMax=4; % if thresh map use NMax=-4; PMax=4;
                    % AFNI colorMap
                    %ColorMap=[1,1,0;1,0.8,0;1,0.6,0;1,0.4118,0;1,0.2667,0;1,0,0;0,0,1;0,0.2667,1;0,0.4118,1;0,0.6,1;0,0.8,1;0,1,1;];
                    % the colorMap used in the pib
                    ColorMap=[1,1,0;1,0.9,0;1,0.8,0;1,0.7,0;1,0.6,0;1,0.5,0;0,0.5,1;0,0.6,1;0,0.7,1;0,0.8,1;0,0.9,1;0,1,1;];
                    ColorMap=flipdim(ColorMap,1);
                    cmap1 = colorRamp(ColorMap(1:6,:), 32);
                    cmap2= colorRamp(ColorMap(7:end,:), 32);
                    ColorMap=vertcat(cmap1,cmap2);
                    
                else
                    NMin=-0.1; PMin = 0.1;
                    NMax=-6; PMax=6;
                    ColorMap=jet(12);
                end
                
                Prefix='';
                
                PicturePrefix='';
                
                ClusterSize=0;
                
                SurfaceMapSuffix='_SurfaceMap.jpg';
                
                
                ConnectivityCriterion=18;
                
                [BrainNetViewerPath, fileN, extn] = fileparts(which('BrainNet.m'));
                
                SurfFileName=[BrainNetViewerPath,filesep,'Data',filesep,'SurfTemplate',filesep,'BrainMesh_ICBM152_smoothed.nv'];
                
                viewtype='MediumView';
                
                DirImg = dir([imgInputDir,filesep, mapType, '*.nii.gz']);
                
                
                numImg=length(DirImg)
                
                for i=1:numImg
                    InputName = [imgInputDir,filesep,DirImg(i).name];
                    
                    OutputName = [surfaceMapOutputDir,DirImg(i).name(1:end-7), SurfaceMapSuffix];
                    
                    H_BrainNet = rest_CallBrainNetViewer(InputName,NMin,PMin,ClusterSize,ConnectivityCriterion,SurfFileName,viewtype,ColorMap,NMax,PMax);
                    
                    eval(['print -r300 -djpeg -noui ''',OutputName,''';']);
                end
            end
        end
    end
end

