% this script scatter plot the given deriviative value renerated using two
% CPAC and DPARSF for all voxels

clear
clc


%measureList={'ReHo', 'ALFF', 'fALFF', 'VMHC', 'DCBinary', 'DCWeighted'};
measureList={'ReHo'};
numMeasure=length(measureList);

configPath='/home2/data/Projects/workingMemory/code/C-PAC-Config/'
subList=load([configPath, 'subject_list_Num.txt']);
numSub=length(subList);

CPACPath='/home2/data/Projects/workingMemory/results/CPAC_analysis/output/sym_links/pipeline_HackettCity/linear1.wm1.global1.motion1.quadratic1.csf1_CSF_0.98_GM_0.7_WM_0.96/';
DPARSFPath='/home2/data/Projects/workingMemory/data/DPARSF_analysis/';
figDir='/home2/data/Projects/workingMemory/figs/cmpCpacAndDparsf/';
mask='/home2/data/Projects/workingMemory/mask/commonCPAC100pctAndDparsf.nii';
maskDC='/home2/data/Projects/workingMemory/mask/DCmask_common_CPAC45sub100pct_MNIGrey25pc_DPARSF.nii';


for j=1:numMeasure
    close all
    measure=char(measureList{j})

pearsonList=zeros(numSub, 1);
WList=zeros(numSub, 1);
for i=1:numSub
    sub=subList(i)
    subID=['sub', num2str(sub)];
    
    if strcmp(measure, 'ReHo')
        CPACfile=[CPACPath, subID, '/scan_rest_1_rest/reho/bandpass_freqs_0.01.0.1/fwhm_6/reho_Z_to_standard_smooth_3mm.nii.gz'];
        DPARSFfile=[DPARSFPath, 'ResultsWS/ReHo/swzReHoMap_', num2str(sub), '_3mm.nii'];
    elseif strcmp(measure, 'ALFF')
        CPACfile=[CPACPath, subID, '/scan_rest_1_rest/alff/hp_0.01/lp_0.1/fwhm_6/alff_Z_to_standard_smooth_3mm.nii.gz'];
        DPARSFfile=[DPARSFPath, 'ResultsWS/ALFF/swzALFFMap_', num2str(sub), '_3mm.nii'];
    elseif strcmp(measure, 'fALFF')
        CPACfile=[CPACPath, subID, '/scan_rest_1_rest/alff/hp_0.01/lp_0.1/fwhm_6/falff_Z_to_standard_smooth_3mm.nii.gz'];
        DPARSFfile=[DPARSFPath, 'ResultsWS/fALFF/swzfALFFMap_', num2str(sub), '_3mm.nii'];
%     elseif strcmp(measure, 'VMHC')
%         CPACfile=[CPACPath, subID, '/scan_rest_1_rest/vmhc/bandpass_freqs_0.01.0.1/fwhm_6/vmhc_z_score_3mm.nii.gz'];
%         DPARSFfile=[DPARSFPath, 'ResultsS_MNICal/VMHC/szVMHCMap_', num2str(sub), '.nii'];
%     elseif strcmp(measure, 'DCBinary')
%         CPACfile=[CPACPath, subID, '/scan_rest_1_rest/centrality/mask_meanFunMask45subcd100pc_Grey25pc/bandpass_freqs_0.01.0.1/degree_centrality_binarize_maths.nii.gz'];
%         DPARSFfile=[DPARSFPath, 'Results/DegreeCentrality/zDegreeCentrality_PositiveBinarizedSumBrainMap_', num2str(sub), '.nii'];
%     elseif strcmp(measure, 'DCWeighted')
%         CPACfile=[CPACPath, subID, '/scan_rest_1_rest/centrality/mask_meanFunMask45sub100pc_Grey25pc/bandpass_freqs_0.01.0.1/degree_centrality_weighted_maths.nii.gz'];
%         DPARSFfile=[DPARSFPath, 'Results/DegreeCentrality/zDegreeCentrality_PositiveWeightedSumBrainMap_', num2str(sub), '.nii'];
    end
    
    if strcmp(measure, 'DCBinary') | strcmp(measure, 'DCWeighted')
        disp('DC mask was used.')
        [Outdata,VoxDim,Header]=rest_readfile(maskDC);
    else
        disp('Common mask was used.')
    [Outdata,VoxDim,Header]=rest_readfile(mask);
    end
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
end

a=subList(find(pearsonList<0.6));
b=pearsonList(find(pearsonList<0.6));
c=subList(find(WList<0.6));
d=WList(find(WList<0.6));
pearsonLow=horzcat(a,b)
KendallLow=horzcat(c,d)

pearsonReport=horzcat(subList, pearsonList);
KendallReport=horzcat(subList, WList);

save([figDir, 'cmpCPACandDP_lowPearson_', measure, '_nativeCal.txt'], '-ascii', '-tabs', 'pearsonLow')
save([figDir, 'cmpCPACandDP_lowKendall_', measure, '_nativeCal.txt'], '-ascii', '-tabs', 'KendallLow')
save([figDir, 'cmpCPACandDP_Pearson_', measure, '_nativeCal.txt'], '-ascii', '-tabs', 'pearsonReport')
save([figDir, 'cmpCPACandDP_Kendall_', measure, '_nativeCal.txt'], '-ascii', '-tabs', 'KendallReport')

figure(1)
subplot(2,1,1)
hist(pearsonList,-0.2:0.1:1.2)
ylim([0 70])
xlim([-0.2 1.2])
title('Pearson')
ylabel('Number of Subjects')
subplot(2,1,2)
hist(WList, -0.2:0.1:1.2)
ylim([0 70])
xlim([-0.2 1.2])
title('Kendall')
ylabel('Number of Subjects')
saveas(figure(1), [figDir, 'cmpCPACandDP_', measure, '_nativeCal_smoothed.png'])

end