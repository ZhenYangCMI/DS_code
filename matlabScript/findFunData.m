clear
clc


dataSet={'wave1'};
numDataSet=length(dataSet);

subListFile=['/home/data/Projects/workingMemory/data/subList.txt'];
subList = load(subListFile);
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
            mkdir(['/home/data/Projects/workingMemory/data/filesOtherThanNIFT/FunImg/',sub])
            saveDir= ['/home/data/Projects/workingMemory/data/filesOtherThanNIFT/FunImg/',sub,'/'];
            origDir =[dataDir,data,'/sub',sub,'/originals'];
            cd (origDir)
            funFolderName=dir('*Rest_*');
            numFunFiles=length(funFolderName);
            if numFunFiles == 0
                disp(['The files structure of ', sub, ' is different from that of others in ', data])
                ls
                save(['/home/data/Projects/workingMemory/data/filesOtherThanNIFT/FunImg/',sub,'DiffStruct.mat'],'sub')
            elseif numFunFiles == 1
                copyfile(funFolderName(1).name,saveDir)
            
            % for subjects who has rest 1 and rest 2
            elseif numFunFiles == 2
                count=0;
                for k=1:numFunFiles
                    funDir=[subDir,'/originals/',funFolderName(k).name];
                    cd (funDir)
                    dataFile=dir('*.nii.gz')
                    data=dataFile.name;
                    % convert the 4D image to 4D matrix
                    [AllVolume, VoxelSize, ImgFileList, Header1, nVolumn] =rest_to4d(data);
                    [nDim1 nDim2 nDim3 nDimTimePoints]=size(AllVolume);
                    if nDimTimePoints ==180
                        count=count+1;
                        goodData(count)=cellstr(funFolderName(k).name)
                    end
                end
                cd (origDir)
                copyfile(char(goodData(1)),saveDir)
            else
                numSubBadRuns=numSubBadRuns+1;
                subBadRuns(numSubBadRuns)=cellstr(sub);
                goodData=cell(1,2);
                count=0;
                for k=1:numFunFiles
                    funDir=[subDir,'/originals/',funFolderName(k).name];
                    cd (funDir)
                    dataFile=dir('*.nii.gz')
                    data=dataFile.name;
                    % convert the 4D image to 4D matrix
                    [AllVolume, VoxelSize, ImgFileList, Header1, nVolumn] =rest_to4d(data);
                    [nDim1 nDim2 nDim3 nDimTimePoints]=size(AllVolume);
                    if nDimTimePoints ==180
                        count=count+1;
                        goodData(count)=cellstr(funFolderName(k).name)
                    end
                end
                cd (origDir)
                copyfile(char(goodData(1)),saveDir)
            end
        else
            disp ([sub,' does not exist in ', data])
        end
    end
end
save(['/home/data/Projects/workingMemory/data/filesOtherThanNIFT/FunImg/subBadRuns.mat'], 'subBadRuns' )