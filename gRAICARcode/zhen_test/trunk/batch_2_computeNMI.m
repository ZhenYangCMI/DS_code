
% batch_2_computeNMI.m
%
% Batch script for parallel computing of NMI
% 1. Please make sure the following settings are correct;
% 2. For parallel computing, please start multiple matlab instances and execute this script in each of the instances
%  
% The gRAICAR package is written by
% Zhi Yang Ph.D
% Institute of Psychology, Chinese Academy of Sciences, Beijing, China
% 
% Reference: Zhi Yang, Xi-Nian Zuo, Peipei Wang, Zhihao Li, Stephen LaConte, Peter Bandettini, Xiaoping Hu
% Generalized RAICAR: Discover homogeneous subject (sub)groups by reproducibility of their intrinsic connectivity networks. NeuroImage. In press.

%%%%%%%%% requires user changes %%%%%%%%%%%%%%%
% rootdir: the path of directory in which the entire analysis is runing
rootDir = '/home2/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/';

% outdir: the name of directory for the output of gRAICAR (!!!!relative to the rootDir, instead of full path!!!!)
outDir = '/gRAICAR_PR_autoDim';

% taskName: name of the analysis task, will be used as the prefix of the configFile that stores information about the analysis.
taskName = 'rest';

% pathSbList: path to the subject list file (!!!!relative to the rootDir, instead of full path!!!!)
% the subject list file contains a list (column) of subject names. The data for each subject are under the directory with the listed subject name
pathSbList = '/scripts/subjectList_Num_68sub.txt'

% icaPrefix: name of the Melodic ICA file
icaPrefix = 'melodic_IC_mni152_3mm.nii.gz';

% icaDir: path of the ICA directory (!!!!relative to the subject directory, instead of full path!!!!)
icaDir='/func/ICA/melodic_autoDim';

% maskPath: path of the mask file (!!!!relative to the rootDir, instead of full path!!!!)
maskPath = 'meanFunMask0.9_72sub.nii';

%%%%%%%%%% end of user input %%%%%%%%%%%%%%%%%%%

inPrefix = [rootDir, outDir, '/',taskName];
cueFile = [rootDir, outDir, '/progress.log'];
% call distributed computing function
gRAICAR_distrCompNMI (inPrefix,cueFile);
