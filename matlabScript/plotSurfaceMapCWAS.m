
% This script will plot individual surface map and combine individual
% ones into one panel

clear
clc
close all
%%%Get the Surface maps
group='CWASadoles' % 'CWASchild', 'CWASadoles', 'CWAS46sub' 
%when group=CWAS46sub, run BT, FT separately as the age effect has the same
%name and will overwrite the output file, or change the age effect name in
%the original folder
effectList={'FTandBTogether'};
numEffect=length(effectList);
mapTypeList={'cluster_mask', 'thresh'};

for k=1:length(mapTypeList)
    mapType=char(mapTypeList{k})
    
    for j=1:numEffect
        effect=char(effectList{j});
        imgInputDir = ['/home2/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/', group, '/', effect, '.mdmr'];
        %mkdir(['/home2/data/Projects/workingMemory/figs/CWAS/']);
        surfaceMapOutputDir = ['/home2/data/Projects/workingMemory/figs/CWAS/46sub/CWAS/', effect, '/'];
        
        if strcmp(mapType, 'thresh')
            NMin=-0.001; PMin = 0.001;
            NMax=-4; PMax=4;
            
            
            % AFNI colorMap
            %ColorMap=[1,1,0;1,0.8,0;1,0.6,0;1,0.4118,0;1,0.2667,0;1,0,0;0,0,1;0,0.2667,1;0,0.4118,1;0,0.6,1;0,0.8,1;0,1,1;];
            % the colorMap used in the pib
            ColorMap=[1,1,0;1,0.9,0;1,0.8,0;1,0.7,0;1,0.6,0;1,0.5,0;0,0.5,1;0,0.6,1;0,0.7,1;0,0.8,1;0,0.9,1;0,1,1;];
            ColorMap=flipdim(ColorMap,1);
            cmap1 = colorRamp(ColorMap(1:6,:), 32);
            cmap2= colorRamp(ColorMap(7:end,:), 32);
            ColorMap=vertcat(cmap1,cmap2)
            
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
            
            OutputName = [surfaceMapOutputDir,DirImg(i).name(1:end-7), '_', group, '_', SurfaceMapSuffix];
            
            H_BrainNet = rest_CallBrainNetViewer(InputName,NMin,PMin,ClusterSize,ConnectivityCriterion,SurfFileName,viewtype,ColorMap,NMax,PMax);
            
            eval(['print -r300 -djpeg -noui ''',OutputName,''';']);
        end
    end
end


