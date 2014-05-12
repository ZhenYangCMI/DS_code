function [correl]=cmpHist(measure1.txt measure2.txt)
% this script scatter plot the given deriviative value renerated using two
% CPAC and DPARSF for all voxels
clear all
close all
clc


configPath='/home2/data/Projects/workingMemory/code/C-PAC-Config/'
subList=load([configPath, 'subject_list_Num.txt']);
numSub=length(subList);
pearsonList=zeros(numSub);
mask='/home2/data/Projects/workingMemory/mask/CPAC_mean_fun_mask_standard_100pc.nii';

    file1=fopen('/home2/data/Projects/workingMemory/data/cmpCPACandDPARSF/CPACReHo.txt', 'rt')
    file2=fopen('/home2/data/Projects/workingMemory/data/cmpCPACandDPARSF/DPARSFReHo.txt', 'rt')
    
    i=0
    while  feof(file1)==0 
        i=i+1;
        tline1=fgets(file1);
        tline2=fgets(file2); 
        
   [Outdata,VoxDim,Header]=rest_readfile(mask);
   s1=sprintf('''tline1''');
   s2=eval(eval(s1));
   gunzip(eval(s2))
   eval(sprintf('[Outdata1,VoxDim1,Header1]=rest_readfile(s2)'));
   
    end
    
   s3=sprintf('''tline2''');
   s4=eval(eval(s3));
   eval(sprintf('[Outdata2,VoxDim2,Header2]=rest_readfile(s4)'));
 
tmp1=Outdata1(find(Outdata~=0));
tmp2=Outdata2(find(Outdata~=0));

CPAC1D=reshape(tmp1, [], 1);
DPARSF1D=reshape(tmp2, [], 1)
    
correl=corrcoef(CPAC1D, DPARSF1D);
pearsonList(i)=correl(1,2);

    end
    
figure()
hist(corrList, -1:0.2:1)





    
    
    
    
    
    
    
