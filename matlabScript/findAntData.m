clear
clc


dataSet={'wave1'};
numDataSet=length(dataSet);

subListFile=['/home/data/Projects/workingMemory/data/subList.txt'];
subList = load(subListFile);
%subList=3236;
numSub=length(subList);

dataDir=['/home/data/Originals/'];
numSubBadRuns=0;
subBadRuns=cell(30,1);

for i=1:numSub
    sub=num2str(subList(i));
    disp(['Working on ', sub])
    
    for j=1:numDataSet
        data=dataSet{j};
        subDir=[dataDir,data,'/sub',sub];
        if exist(subDir,'dir')
            mkdir(['/home/data/Projects/workingMemory/data/filesOtherThanNIFT/T1Img/',sub])
            saveDir= ['/home/data/Projects/workingMemory/data/filesOtherThanNIFT/T1Img/',sub,'/'];
            origDir =[dataDir,data,'/sub',sub,'/originals'];
            cd (origDir)
            antFolderName=dir('*HighResT1');
            numAntFiles=length(antFolderName);
            if numAntFiles == 0
                disp(['The files structure of ', sub, ' is different from that of others in ', data])
                ls
                save(['/home/data/Projects/workingMemory/data/filesOtherThanNIFT/T1Img/',sub,'DiffStruct.mat'],'sub')
            elseif (numAntFiles == 1) | (numAntFiles == 2)
                % These two sub Anat1 Failed, Anat2 were used for analysis
                if strcmp(sub,'8537') | strcmp(sub,'3236')
                    copyfile(antFolderName(2).name,saveDir)
                else
                    copyfile(antFolderName(1).name,saveDir)
                end
            else
                numSubBadRuns=numSubBadRuns+1;
                subBadRuns(numSubBadRuns)=cellstr(sub);
                disp([sub, 'has more than 2 T1 file. Please double check'])
                ls
                if strcmp(sub,'8537') | strcmp(sub,'3236')
                    copyfile(antFolderName(2).name,saveDir)
                else
                    copyfile(antFolderName(1).name,saveDir)
                end
            end
        else
            disp ([sub,' does not exist in ', data])
        end
    end
end
save('/home/data/Projects/workingMemory/data/filesOtherThanNIFT/T1Img/subBadRuns.mat', 'subBadRuns' )