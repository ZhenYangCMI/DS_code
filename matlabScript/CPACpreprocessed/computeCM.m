clear
clc
close all

rmpath /home/milham/matlab/REST_V1.7
rmpath /home/milham/matlab/REST_V1.7/Template
rmpath /home/milham/matlab/REST_V1.7/man
rmpath /home/milham/matlab/REST_V1.7/mask
rmpath /home/milham/matlab/REST_V1.7/rest_spm5_files

%restoredefaultpath

addpath(genpath('/home/data/Projects/Zhen/commonCode/spm8'))
addpath /home/data/Projects/Zhen/commonCode/DPARSF_V2.3_130615
addpath /home/data/Projects/Zhen/commonCode/DPARSF_V2.3_130615/Subfunctions/
addpath /home/data/Projects/Zhen/commonCode/REST_V1.8_130615


addpath /home/data/Projects/Zhen/commonCode
codeDir='/home/data/Projects/Zhen/commonCode/';
javaaddpath([codeDir, 'poi_library/poi-3.8-20120326.jar']);
javaaddpath([codeDir, 'poi_library/poi-ooxml-3.8-20120326.jar']);
javaaddpath([codeDir, 'poi_library/poi-ooxml-schemas-3.8-20120326.jar']);
javaaddpath([codeDir, 'poi_library/xmlbeans-2.3.0.jar']);
javaaddpath([codeDir, 'poi_library/dom4j-1.6.1.jar']);
javaaddpath([codeDir, 'poi_library/stax-api-1.0.1.jar']);


% define path and variables
maskDir='/home/data/Projects/Zhen/workingMemory/figs/paper_figs/clusterMask/';
clustList=dir([maskDir, 'cluster_mask_*.nii.gz'])
resultDir=maskDir;
delete ([resultDir, 'clusterCM.xls'])


% read in the cluster mask
t=1;

for i=1:length(clustList)
    effect=clustList(i).name
    effect=cellstr(effect(14:end-7));
    str1='A';
    linenumber1=sprintf('%s%d',str1,t);
    xlwrite([resultDir, 'clusterCM.xls'],effect, 'sheet1', linenumber1);
    
    t=t+1;
    linenumber2=sprintf('%s%d',str1,t);
    title={'clustNumber', 'ICenter', 'JCenter', 'KCenter', 'XCenter', 'YCenter', 'ZCenter'};
    xlwrite([resultDir, 'clusterCM.xls'],title, 'sheet1', linenumber2);
    
    maskFile=[maskDir, 'cluster_mask_', char(effect), '.nii.gz'];
    
    % compute the CM
    
    [Data Head]=rest_ReadNiftiImage(maskFile);
    
    [nDim1 nDim2 nDim3]=size(Data);
    
    [I J K] = ndgrid(1:nDim1,1:nDim2,1:nDim3);
    
    Element = unique(Data);
    Element(1) = []; % This is the background 0
    Table = [];
    for iElement=1:length(Element)
        
        ICenter = mean(I(Data==Element(iElement)));
        JCenter = mean(J(Data==Element(iElement)));
        KCenter = mean(K(Data==Element(iElement)));
        
        Center = Head.mat*[ICenter JCenter KCenter 1]';
        XCenter = Center(1);
        YCenter = Center(2);
        ZCenter = Center(3);
        
        Table = [Table;[iElement,ICenter,JCenter,KCenter,XCenter,YCenter,ZCenter]];
    end
    t=t+1;
    if ~isempty(Table)
        linenumber3=sprintf('%s%d',str1,t);
        xlwrite([resultDir, 'clusterCM.xls'],Table, 'sheet1', linenumber3);
    end
    t=t+size(Table, 1);
end

