% multicolinearity test for noGSR, GSR, compCor, and meanRegression
clear
clc

numSub=68
%model=load(['/home/data/Projects/workingMemory/data/regressionModelCPACNewAnalysisAgeByDSDemean.txt']);
model=load(['/home/data/Projects/workingMemory/data/regressionModelCPACNewAnalysisAgeDemeanByDSDemean.txt']);
labelsFull={'age_demean', 'DS_FT_demean', 'DS_BT_demean', 'ageByFTdemean', 'ageByBTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
    modelFull=[model(:, 14) model(:, 15) model(:, 16) model(:, 18) model(:, 19) model(:, 21) model(:, 22) model(:, 23) ones(numSub, 1)];

labelsDF={'age_demean',  'DS_FT_demean', 'ageByFTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
    modelDF=[model(:, 14) model(:, 15) model(:, 18) model(:, 21) model(:, 22) model(:, 23) ones(numSub, 1)];
 
 labelsDB={'age_demean', 'DS_BT_demean', 'ageByBTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
    modelDB=[model(:, 14) model(:, 16) model(:, 19) model(:, 21) model(:, 22) model(:, 23) ones(numSub, 1)];

labelsTot={'age_demean', 'DS_totT_demean', 'ageBytotTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'constant'}
    modelTot=[model(:, 14) model(:, 17) model(:, 20) model(:, 21) model(:, 22) model(:, 23) ones(numSub, 1)];

% You can also add an interecept term, which reproduces Belsley et al.'s
% example
colldiag(modelDF,labelsDF)
colldiag(modelDB,labelsDB)
colldiag(modelTot,labelsTot)
colldiag(modelFull,labelsFull)


% multicolinearity test for gCor

clear
clc

numSub=68
%model=load(['/home/data/Projects/workingMemory/data/regressionModelCPACNewAnalysisAgeByDSDemean.txt']);
model=load(['/home/data/Projects/workingMemory/data/regressionModelCPACNewAnalysisAgeDemeanByDSDemean.txt']);
labelsFull={'age_demean', 'DS_FT_demean', 'DS_BT_demean', 'ageByFTdemean', 'ageByBTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'gCor_demean', 'constant'}
    modelFull=[model(:, 14) model(:, 15) model(:, 16) model(:, 18) model(:, 19) model(:, 21) model(:, 22) model(:, 23) model(:, 24) ones(numSub, 1)];

labelsDF={'age_demean',  'DS_FT_demean', 'ageByFTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'gCor_demean', 'constant'}
    modelDF=[model(:, 14) model(:, 15) model(:, 18) model(:, 21) model(:, 22) model(:, 23) model(:, 24) ones(numSub, 1)];
 
 labelsDB={'age_demean', 'DS_BT_demean', 'ageByBTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'gCor_demean', 'constant'}
    modelDB=[model(:, 14) model(:, 16) model(:, 19) model(:, 21) model(:, 22) model(:, 23) model(:, 24) ones(numSub, 1)];

labelsTot={'age_demean', 'DS_totT_demean', 'ageBytotTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean', 'gCor_demean', 'constant'}
    modelTot=[model(:, 14) model(:, 17) model(:, 20) model(:, 21) model(:, 22) model(:, 23) model(:, 24) ones(numSub, 1)];

% You can also add an interecept term, which reproduces Belsley et al.'s
% example
colldiag(modelDF,labelsDF)
colldiag(modelDB,labelsDB)
colldiag(modelTot,labelsTot)
colldiag(modelFull,labelsFull)


