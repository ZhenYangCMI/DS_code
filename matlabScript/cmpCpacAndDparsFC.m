% this script scatter plot the given deriviative value renerated using two
% CPAC and DPARSF for all voxels

clear
clc
close all

measure='FC' % This is specially for FC
numSeed=2; % number of seed used for seed-based FC analysis
configPath='/home2/data/Projects/workingMemory/code/C-PAC-Config/'
subList=load([configPath, 'subject_list_Num.txt']);
numSub=length(subList);

CPACPath='/home2/data/Projects/workingMemory/results/CPAC_analysis/output/sym_links/pipeline_HackettCity/linear1.wm1.global1.motion1.quadratic1.csf1_CSF_0.98_GM_0.7_WM_0.96/';
DPARSFPath='/home2/data/Projects/workingMemory/data/DPARSF_analysis/ResultsWS/';
figDir='/home2/data/Projects/workingMemory/figs/cmpCpacAndDparsf/';
mask='/home2/data/Projects/workingMemory/mask/commonCPAC100pctAndDparsf.nii';

pearsonList=zeros(numSub, 1);
WList=zeros(numSub, 1);

for j=1:numSeed
    seed=j;
    for i=1:numSub
        sub=subList(i)
        subID=['sub', num2str(sub)];
        
%         if (sub==4348) || (sub==8539)
%             disp('Two subjects don''t have SCA data')
%         else
            
            CPACfile=[CPACPath, subID, '/scan_rest_1_rest/sca_roi/roi_rois_3mm/bandpass_freqs_0.01.0.1/fwhm_6/sca_roi_Z_to_standard_smooth_', num2str(seed), '.nii.gz'];
            DPARSFfile=[DPARSFPath, 'FC/swzROI', num2str(seed), 'FCMap_', num2str(sub), '.nii'];
            [Outdata,VoxDim,Header]=rest_readfile(mask);
            [Outdata1,VoxDim1,Header1]=rest_readfile(CPACfile);
            [Outdata2,VoxDim2,Header2]=rest_readfile(DPARSFfile);
            
            tmp1=Outdata1(find(Outdata~=0));
            tmp2=Outdata2(find(Outdata~=0));
            
            CPAC1D=reshape(tmp1, [], 1);
            DPARSF1D=reshape(tmp2, [], 1);
            
            correl=corrcoef(CPAC1D, DPARSF1D);
            pearsonList(i, 1)=correl(1,2);
            
            RCpac=tiedrank(CPAC1D);
            RDparsf=tiedrank(DPARSF1D);
            X=horzcat(RCpac, RDparsf);
            W = KendallCoef(X);
            WList(i, 1)=W;
%         end
    end
    
    a=subList(find(pearsonList<0.6));
b=pearsonList(find(pearsonList<0.6));
c=subList(find(WList<0.6));
d=WList(find(WList<0.6));
pearsonLow=horzcat(a,b)
KendallLow=horzcat(c,d)

pearsonReport=horzcat(subList, pearsonList);
KendallReport=horzcat(subList, WList);

save([figDir, 'cmpCPACandDP_lowPearson_', measure, '_', num2str(seed), '.txt'], '-ascii', '-tabs', 'pearsonLow')
save([figDir, 'cmpCPACandDP_lowKendall_', measure, '_', num2str(seed),'.txt'], '-ascii', '-tabs', 'KendallLow')
save([figDir, 'cmpCPACandDP_Pearson_', measure, '_', num2str(seed),'.txt'], '-ascii', '-tabs', 'pearsonReport')
save([figDir, 'cmpCPACandDP_Kendall_', measure, '_', num2str(seed),'.txt'], '-ascii', '-tabs', 'KendallReport')
    
    
    
    figure(1)
    subplot(2,1,1)
    hist(pearsonList,21)
    ylim([0 70])
    xlim([-0.2 1.2])
    title('Pearson')
    ylabel('Number of Subjects')
    subplot(2,1,2)
    hist(WList, 21)
    ylim([0 70])
    xlim([-0.2 1.2])
    title('Kendall')
    ylabel('Number of Subjects')
    saveas(figure(1), [figDir, 'cmpCPACandDP_', measure,'_', num2str(seed), '.png'])
        
    
end