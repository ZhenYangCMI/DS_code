% multicolinearity test
clear
clc

modelType= ['modelOtherMetrics68sub']  %'modelOtherMetrics'
numSub=68

model=load(['/home/data/Projects/workingMemory/data/', modelType, '.txt']);
labelsFull={'constant', 'age_demean', 'DS_FT_demean', 'DS_BT_demean', 'ageByFTdemean', 'ageByBTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean'}
modelFull=[ones(numSub, 1) model(:, 6) model(:, 8) model(:, 9) model(:, 10) model(:, 11) model(:, 14) model(:, 15) model(:, 16) ];

labelsFT={'constant' 'age_demean',  'DS_FT_demean', 'ageByFTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean'}
 modelFT=[ones(numSub, 1) model(:, 6) model(:, 8) model(:, 10) model(:, 14) model(:, 15) model(:, 16) ];
 
 labelsBT={'constant' 'age_demean', 'DS_BT_demean', 'ageByBTdemean', 'WASI_Full4IQ_demean', 'meanFDJenk_demean', 'hand_demean'}
  modelBT=[ones(numSub, 1) model(:, 6) model(:, 9) model(:, 11) model(:, 14) model(:, 15) model(:, 16) ];

% You can also add an interecept term, which reproduces Belsley et al.'s
% example
colldiag(modelFT,labelsFT)
colldiag(modelBT,labelsBT)
colldiag(modelFull,labelsFull)

figure(1)
imagesc(modelFull)

%infoFT=colldiag(modelFT,labelsFT,0.5,true);
%
% % That can be passed along for visualization
%colldiag_tableplot(infoFT);
%
%
% infoBT=colldiag(modelBT,labels,0.5,true);
% colldiag_tableplot(infoBT);
