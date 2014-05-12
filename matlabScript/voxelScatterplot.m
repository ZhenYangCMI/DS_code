function [ correl, numVoxelPlotted ] =voxelScatterplot(subList, measure, seed)
%This function plot the given measure of all voxels generated using CPAC
%and DPARSF
%1. sub: a numerical variable
%2. measure: a string. 'ReHo', 'ALFF', 'fALFF', 'VMHC', 'DCBinary',
%'DCWeighted', or 'FC'
% 3. if measure ='FC', give the seedID one wants to plot
%4. corType: the type of pearson's correlation, string, 'low', 'median', or
%'high'

% sub=4494; %4348, 8539 bad subjects
% measure='FC';
% seed=1;
CPACPath='/home2/data/Projects/workingMemory/results/CPAC_analysis/output/sym_links/pipeline_HackettCity/linear1.wm1.global1.motion1.quadratic1.csf1_CSF_0.98_GM_0.7_WM_0.96/';
DPARSFPath='/home2/data/Projects/workingMemory/data/DPARSF_analysis/';
figDir='/home2/data/Projects/workingMemory/figs/cmpCpacAndDparsf/';
mask='/home2/data/Projects/workingMemory/mask/commonCPAC100pctAndDparsf.nii';
maskDC='/home2/data/Projects/workingMemory/mask/DCmask_common_CPAC45sub100pct_MNIGrey25pc_DPARSF.nii';

numSub=length(subList);

for i=1:numSub
    sub=subList(i)
    subID=['sub', num2str(sub)];
    if strcmp(measure, 'ReHo')
        CPACfile=[CPACPath, subID, '/scan_rest_1_rest/reho/bandpass_freqs_0.01.0.1/fwhm_6/reho_Z_to_standard_smooth.nii.gz'];
        DPARSFfile=[DPARSFPath, 'ResultsS/ReHo/szReHoMap_', num2str(sub), '.nii'];
    elseif strcmp(measure, 'ALFF')
        CPACfile=[CPACPath, subID, '/scan_rest_1_rest/alff/hp_0.01/lp_0.1/fwhm_6/alff_Z_to_standard_smooth.nii.gz'];
        DPARSFfile=[DPARSFPath, 'ResultsS/ALFF/szALFFMap_', num2str(sub), '.nii'];
    elseif strcmp(measure, 'fALFF')
        CPACfile=[CPACPath, subID, '/scan_rest_1_rest/alff/hp_0.01/lp_0.1/fwhm_6/falff_Z_to_standard_smooth.nii.gz'];
        DPARSFfile=[DPARSFPath, 'ResultsS/fALFF/szfALFFMap_', num2str(sub), '.nii'];
    elseif strcmp(measure, 'VMHC')
        CPACfile=[CPACPath, subID, '/scan_rest_1_rest/vmhc/bandpass_freqs_0.01.0.1/fwhm_6/vmhc_z_score_3mm.nii.gz'];
        DPARSFfile=[DPARSFPath, 'ResultsS/VMHC/szVMHCMap_', num2str(sub), '.nii'];
    elseif strcmp(measure, 'DCBinary')
        CPACfile=[CPACPath, subID, '/scan_rest_1_rest/centrality/mask_meanFunMask45sub100pc_Grey25pc/bandpass_freqs_0.01.0.1/fwhm_6/degree_centrality_binarize_maths_maths.nii.gz'];
        DPARSFfile=[DPARSFPath, 'ResultsS/DegreeCentrality/szDegreeCentrality_PositiveBinarizedSumBrainMap_', num2str(sub), '.nii'];
    elseif strcmp(measure, 'DCWeighted')
        CPACfile=[CPACPath, subID, '/scan_rest_1_rest/centrality/mask_meanFunMask45sub100pc_Grey25pc/bandpass_freqs_0.01.0.1/fwhm_6/degree_centrality_weighted_maths_maths.nii.gz'];
        DPARSFfile=[DPARSFPath, 'ResultsS/DegreeCentrality/szDegreeCentrality_PositiveWeightedSumBrainMap_', num2str(sub), '.nii'];
    elseif strcmp(measure, 'FC')
%         if (sub==4348) || (sub==8539)
%             disp('Two subjects don''t have SCA data')
%             continue
%         else
        CPACfile=[CPACPath, subID, '/scan_rest_1_rest/sca_roi/roi_rois_3mm/bandpass_freqs_0.01.0.1/fwhm_6/sca_roi_Z_to_standard_smooth_', num2str(seed), '.nii.gz'];
        DPARSFfile=[DPARSFPath, 'ResultsS/FC/szROI', num2str(seed), 'FCMap_', num2str(sub), '.nii'];
        %end
    end
    
    if strcmp(measure, 'DCBinary') | strcmp(measure, 'DCWeighted')
        [Outdata,VoxDim,Header]=rest_readfile(maskDC);
    else
        [Outdata,VoxDim,Header]=rest_readfile(mask);
    end
    
    [Outdata1,VoxDim1,Header1]=rest_readfile(CPACfile);
    [Outdata2,VoxDim2,Header2]=rest_readfile(DPARSFfile);
    
    tmp1=Outdata1(find(Outdata~=0));
    tmp2=Outdata2(find(Outdata~=0));
    
    CPAC1D=reshape(tmp1, [], 1);
    size(CPAC1D)
    DPARSF1D=reshape(tmp2, [], 1);
    size(DPARSF1D)
    correl=corrcoef(CPAC1D, DPARSF1D);
    correl=correl(1,2);
    numVoxelPlotted=size(CPAC1D, 1);
    
    figure(1)
    scatter(CPAC1D, DPARSF1D)
    h=lsline
    set(h, 'lineWidth', 3)
    xlabel(['CPAC ', measure])
    ylabel(['DPARSF', measure])
    title(['sub ', num2str(sub)])
    if strcmp(measure, 'FC')
        saveas(figure(1), [figDir, 'scatter_pearson_', measure, '_', num2str(sub),'_', num2str(seed), '.png'])
    else
            saveas(figure(1), [figDir, 'scatter_pearson_', measure, '_', num2str(sub), '.png'])
    end
    close
    
end

