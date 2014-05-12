clear
clc

subListFile=['/home/data/Projects/workingMemory/data/subList.txt'];
subList = load(subListFile);
numSub=length(subList)

sourceDir=['/home/data/Projects/workingMemory/data/'];
destinatFunDataDir=['/home/data/Projects/workingMemory/data/DPARSF_analysis/FunImg'];
destinatT1DataDir=['/home/data/Projects/workingMemory/data/DPARSF_analysis/T1Img'];

for i=1:numSub
    sub=num2str(subList(i));
    disp(['Working on ', sub])
    mkdir (destinatFunDataDir, sub)
    mkdir (destinatT1DataDir, sub)

    subDestinatT1DataDir=([destinatT1DataDir,'/',sub]);
    subSourceT1DataDir=(['/home/data/Projects/workingMemory/data/CPAC_analysis/wave1/sub',sub,'/anat_1']);
    cd (subSourceT1DataDir)
    T1DataFile=dir('*.nii.gz');
    T1FileToCopy=T1DataFile.name;
    copyfile (T1FileToCopy, subDestinatT1DataDir)
    
    subDestinatFunDataDir=([destinatFunDataDir,'/',sub]);
    subSourceFunDataDir=(['/home/data/Projects/workingMemory/data/CPAC_analysis/wave1/sub',sub,'/rest_1']);
    cd (subSourceFunDataDir)
    funDataFile=dir('*.nii.gz');
    funFileToCopy=funDataFile.name;
    copyfile (funFileToCopy, subDestinatFunDataDir)
end






% old file to copy
dataSet={'wave1'};
numDataSet=length(dataSet);

subListFile=['/home/data/Projects/workingMemory/data/subList.txt'];
subList = load(subListFile);
numSub=length(subList)

sourceFunDataDir=['/home/data/Projects/workingMemory/data/filesOtherThanNIFT/FunImg/'];
sourceT1DataDir=['/home/data/Projects/workingMemory/data/filesOtherThanNIFT/T1Img/'];
destinatFunDataDir=['/home/data/Projects/workingMemory/data/DPARSF_analysis/FunImg'];
destinatT1DataDir=['/home/data/Projects/workingMemory/data/DPARSF_analysis/T1Img'];

for i=1:numSub
    sub=num2str(subList(i));
    disp(['Working on ', sub])
    mkdir (destinatFunDataDir, sub)
    mkdir (destinatT1DataDir, sub)
    
    % move the functional file
    subSourceFunDataDir=[sourceFunDataDir, sub];
    subDestinatFunDataDir=[destinatFunDataDir, '/',sub,'/'];
    
    cd (subSourceFunDataDir)
    funDataFile=dir('*.nii.gz');
    funFileToMove=funDataFile.name;
    movefile (funFileToMove, subDestinatFunDataDir)
    
    % move the anatomic file
    subSourceT1DataDir=[sourceT1DataDir, sub];
    subDestinatT1DataDir=[destinatT1DataDir, '/',sub, '/'];
    
    cd (subSourceT1DataDir)
    T1DataFile=dir('*.nii.gz');
    T1FileToMove=T1DataFile.name;
    movefile (T1FileToMove, subDestinatT1DataDir)
end
