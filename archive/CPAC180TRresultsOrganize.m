clear
clc

subListFile=['/home/data/Projects/workingMemory/data/subList.txt'];
subList = load(subListFile);
numSub=length(subList)

destinatDir=['/home2/data/Projects/workingMemory/results/CPAC_analysis/archive/reorganize180TR/ReHo/'];

for i=1:numSub
    sub=num2str(subList(i));
    disp(['Working on ', sub])
    
    subSourceDir=(['/home2/data/Projects/workingMemory/results/CPAC_analysis/archive/output/sub', sub,'/reho_Z_to_standard_smooth/',...
    '_scan_rest_1_rest/_csf_threshold_0.98/_gm_threshold_0.7/_wm_threshold_0.98/',...
    '_compcor_ncomponents_5_selector_pc10.linear1.wm1.global1.motion1.quadratic1.gm0.compcor0.csf1/_bandpass_freqs_0.01.0.1/_fwhm_6']);
    cd (subSourceDir)
    DataFile=dir('*.nii.gz');
    FileToCopy=DataFile.name;
    copyfile (FileToCopy, subDestinatT1DataDir)
    
    
end






% old file to copy
dataSet={'wave1'};
numDataSet=length(dataSet);

subListFile=['/home/data/Projects/workingMemory/data/subList.txt'];
subList = load(subListFile);
numSub=length(subList)

sourceFunDataDir=['/home/data/Projects/workingMemory/data/filesOtherThanNIFT/FunImg/'];
sourceT1DataDir=['/home/data/Projects/workingMemory/data/filesOtherThanNIFT/T1Img/'];
destinatDir=['/home/data/Projects/workingMemory/data/DPARSF_analysis/FunImg'];
destinatT1DataDir=['/home/data/Projects/workingMemory/data/DPARSF_analysis/T1Img'];

for i=1:numSub
    sub=num2str(subList(i));
    disp(['Working on ', sub])
    mkdir (destinatDir, sub)
    mkdir (destinatT1DataDir, sub)
    
    % move the functional file
    subSourceFunDataDir=[sourceFunDataDir, sub];
    subDestinatFunDataDir=[destinatDir, '/',sub,'/'];
    
    cd (subSourceFunDataDir)
    funDataFile=dir('*.nii.gz');
    funFileToMove=funDataFile.name;
    movefile (funFileToMove, subDestinatFunDataDir)
    
    % move the anatomic file
    subSourceDir=[sourceT1DataDir, sub];
    subDestinatT1DataDir=[destinatT1DataDir, '/',sub, '/'];
    
    cd (subSourceDir)
    DataFile=dir('*.nii.gz');
    T1FileToMove=DataFile.name;
    movefile (T1FileToMove, subDestinatT1DataDir)
end
