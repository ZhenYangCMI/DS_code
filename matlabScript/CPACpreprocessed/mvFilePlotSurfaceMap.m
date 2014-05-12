clear
clc
close all

preprocessingDate='1_1_14';
covTypeList={'meanRegress', 'GSR', 'noGSR', 'compCor', 'gCor'}

mapType='unthresh' % thresh unthresh or cluster_mask

measureList={'ReHo', 'fALFF', 'DegreeCentrality', 'VMHC', 'skewness', 'DualRegression0', 'DualRegression1', 'DualRegression2', 'DualRegression3', 'DualRegression4', 'DualRegression5'};
%measureList={'DegreeCentrality'};
numMeasure=length(measureList)

for m=1:length(covTypeList)
    covType=char(covTypeList{m})
    
    % organize the combined map to a dir
    for i=1:length(measureList)
        measure=char(measureList{i})
        
        
        if strcmp(mapType, 'cluster_mask')
            resultsDir=['/home/data/Projects/workingMemory/results/CPAC_', preprocessingDate, '/groupAnalysis/', covType, '/', measure, '/easythresh'];
            cd (resultsDir)
            mkdir cluster_mask
            fileList=dir('cluster_mask_*.nii.gz')
            for j=1:length(fileList)
                file=fileList(j).name
                movefile (file, 'cluster_mask')
            end
        elseif strcmp(mapType, 'thresh')
            resultsDir=['/home/data/Projects/workingMemory/results/CPAC_', preprocessingDate, '/groupAnalysis/', covType, '/', measure, '/easythresh'];
            cd (resultsDir)
            mkdir cmb
            fileList=dir('thresh_*_cmb.nii')
            for j=1:length(fileList)
                file=fileList(j).name
                movefile (file, 'cmb')
            end
            
        elseif strcmp(mapType, 'unthresh')
            resultsDir=['/home/data/Projects/workingMemory/results/CPAC_', preprocessingDate, '/groupAnalysis/', covType, '/', measure];
            cd (resultsDir)
            mkdir unthresh
            fileList=dir('*_Z.nii')
            for j=1:length(fileList)
                file=fileList(j).name
                copyfile (file, 'unthresh')
            end
        end
        
        % plot surface map
        cd /home/data/Projects/workingMemory/code/matlabScript/CPACpreprocessed
        
        Prefix='';
        
        if strcmp(mapType, 'cluster_mask')
            imgInputDir = [resultsDir, '/cluster_mask'];
            NMin=-0.001; PMin = 0.001;
            NMax=-5; PMax=5;
            ColorMap=jet(12);
            DirImg = dir([imgInputDir,filesep,Prefix,'*.nii.gz']);
            
        elseif strcmp(mapType, 'thresh')
            imgInputDir = [resultsDir, '/cmb'];
            NMin=-2.33; PMin = 2.33;
            NMax=-5; PMax=5;
            DirImg = dir([imgInputDir,filesep,Prefix,'*.nii']);
            % AFNI colorMap
            %ColorMap=[1,1,0;1,0.8,0;1,0.6,0;1,0.4118,0;1,0.2667,0;1,0,0;0,0,1;0,0.2667,1;0,0.4118,1;0,0.6,1;0,0.8,1;0,1,1;];
            % the colorMap used in the pib
            ColorMap=[1,1,0;1,0.9,0;1,0.8,0;1,0.7,0;1,0.6,0;1,0.5,0;0,0.5,1;0,0.6,1;0,0.7,1;0,0.8,1;0,0.9,1;0,1,1;];
            ColorMap=flipdim(ColorMap,1);
            cmap1 = colorRamp(ColorMap(1:6,:), 32);
            cmap2= colorRamp(ColorMap(7:end,:), 32);
            ColorMap=vertcat(cmap1,cmap2);
        elseif strcmp(mapType, 'unthresh')
            imgInputDir = [resultsDir, '/unthresh'];
            NMin=-0.001; PMin = 0.001;
            NMax=-5; PMax=5;
            DirImg = dir([imgInputDir,filesep,Prefix,'*.nii']);
            % AFNI colorMap
            %ColorMap=[1,1,0;1,0.8,0;1,0.6,0;1,0.4118,0;1,0.2667,0;1,0,0;0,0,1;0,0.2667,1;0,0.4118,1;0,0.6,1;0,0.8,1;0,1,1;];
            % the colorMap used in the pib
            ColorMap=[1,1,0;1,0.9,0;1,0.8,0;1,0.7,0;1,0.6,0;1,0.5,0;0,0.5,1;0,0.6,1;0,0.7,1;0,0.8,1;0,0.9,1;0,1,1;];
            ColorMap=flipdim(ColorMap,1);
            cmap1 = colorRamp(ColorMap(1:6,:), 32);
            cmap2= colorRamp(ColorMap(7:end,:), 32);
            ColorMap=vertcat(cmap1,cmap2);
        end
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
    end
end
