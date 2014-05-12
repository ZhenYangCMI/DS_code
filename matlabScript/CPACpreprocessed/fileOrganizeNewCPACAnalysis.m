clear
clc

subListFile=['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt'];
subList = load(subListFile);
numSub=length(subList)

processDate='1_1_14';

% orgnize the CPAC processed data.

covTypeList={'noGSR','GSR', 'compCor'};

for j=1:length(covTypeList)
    covType=char(covTypeList{j})
    
    destinationDir=['/home/data/Projects/workingMemory/results/CPAC_', processDate, '/reorgnized/', covType, '/'];
    
    if strcmp(covType, 'compCor')
        pipeline='_compcor_ncomponents_5_selector_pc10.linear1.wm0.global0.motion1.quadratic1.gm0.compcor1.csf0';
    elseif strcmp(covType, 'noGSR')
        pipeline='_compcor_ncomponents_5_selector_pc10.linear1.wm1.global0.motion1.quadratic1.gm0.compcor0.csf1';
    elseif strcmp(covType, 'GSR')
        pipeline='_compcor_ncomponents_5_selector_pc10.linear1.wm1.global1.motion1.quadratic1.gm0.compcor0.csf1';
    end
    
    %         mkdir ([destinationDir, 'T1Img'])
    %         mkdir ([destinationDir, 'FunImg'])
    %         mkdir ([destinationDir, 'ReHo'])
    %         mkdir ([destinationDir, 'VMHC'])
    %         mkdir ([destinationDir, 'fALFF'])
    mkdir ([destinationDir, 'DegreeCentrality'])
    %         mkdir ([destinationDir, 'DualRegression'])
    
    for i=1:numSub
        sub=num2str(subList(i));
        disp(['Working on ', sub])
        
        subDir=['/home/data/Projects/workingMemory/results/CPAC_', processDate, '/output/pipeline_', processDate, '/', sub];
        
        %         anat=[subDir, '/mni_normalized_anatomical/ants_deformed.nii.gz'];
        %         anat2MNIAffine=[subDir, '/ants_affine_xfm/ants_Affine.txt']; % anat to mni
        %         anat2MNIWarp=[subDir, '/anatomical_to_mni_nonlinear_xfm/ants_Warp.nii.gz'];
        %         fun2anatAffine=['/home/data/Projects/workingMemory/results/CPAC_', processDate, '/working/resting_preproc_', sub, '/_scan_FunImg_rest/fsl_reg_2_itk_0/affine.txt'];
        
        %funNative=[subDir, '/functional_freq_filtered/_scan_FunImg_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/', pipeline, '/_bandpass_freqs_0.01.0.1/bandpassed_demeaned_filtered.nii.gz'];
        %         fun=[subDir, '/functional_mni/_scan_FunImg_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/', pipeline, '/_bandpass_freqs_0.01.0.1/bandpassed_demeaned_filtered_wtsimt.nii.gz']  % functional already in MNI space, only need to smooth and resample before run CWAS
        %         meanFun=[subDir, '/mean_functional_in_mni/_scan_FunImg_rest/rest_3dc_tshift_RPI_3dv_3dc_3dT_wimt.nii.gz'] % mean funImg in MNI
        %         ReHo=[subDir, '/raw_reho_map/_scan_FunImg_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/', pipeline, '/_bandpass_freqs_0.01.0.1/ReHo.nii.gz'];
        %         VMHC=[subDir, '/vmhc_raw_score/_scan_FunImg_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/', pipeline, '/_bandpass_freqs_0.01.0.1/_fwhm_6/bandpassed_demeaned_filtered_maths_wtsimt_3dTcor.nii.gz'];
        %         fALFF=[subDir, '/falff_img/_scan_FunImg_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/', pipeline, '/_hp_0.01/_lp_0.1/rest_3dc_tshift_RPI_3dv_automask_3dc.nii.gz']
        DegreeCentrality=['/home/data/Projects/workingMemory/results/CPAC_', processDate, '/output/pipeline_ds', processDate, '/', sub '/centrality_outputs/_scan_FunImg_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/', pipeline, '/_bandpass_freqs_0.01.0.1/_mask_autoMask_68sub_90percent/degree_centrality_binarize.nii.gz'];
        %         DualRegression=[subDir, '/dr_tempreg_maps_stack/_scan_FunImg_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/', pipeline, '/_bandpass_freqs_0.01.0.1/_spatial_map_gRAICAR7Comp/temp_reg_map.nii.gz'];
        %
        
        %         copyfile(anat, [destinationDir, 'T1Img/normT1_', sub, '.nii.gz'])
        %         copyfile(anat2MNIAffine, [destinationDir, 'T1Img/anat2MNIAffine_', sub, '.txt'])
        %         copyfile(anat2MNIWarp, [destinationDir, 'T1Img/anat2MNIWarp_', sub, '.nii.gz'])
        %         copyfile(fun2anatAffine, [destinationDir, 'T1Img/fun2anatAffine_', sub, '.txt'])
        
        %copyfile(funNative, [destinationDir, 'FunImg/FunImg_', sub, '.nii.gz'])
        %         copyfile(fun, [destinationDir, 'FunImg/normFunImg_', sub, '.nii.gz'])
        %         copyfile(meanFun, [destinationDir, 'FunImg/normMeanFun_', sub, '.nii.gz'])
        %         copyfile(ReHo, [destinationDir, 'ReHo/ReHo_', sub, '.nii.gz'])
        %         copyfile(VMHC, [destinationDir, 'VMHC/SnormVMHC_', sub, '.nii.gz'])
        %         copyfile(fALFF, [destinationDir, 'fALFF/fALFF_', sub, '.nii.gz'])
        copyfile(DegreeCentrality, [destinationDir, 'DegreeCentrality/DegreeCentrality_', sub, '.nii.gz'])
        %         copyfile(DualRegression, [destinationDir, 'DualRegression/DualRegression_', sub, '.nii.gz'])
        
    end
end


% copy over the raw data from DPARSFA analysis dir. The first 5 volumes are already removed, so don't remove any time points when run CPAC
for i=1:numSub
    sub=num2str(subList(i));
    disp(['Working on ', sub])
    
    sourceFunDataDir=['/home/data/Projects/workingMemory/data/DPARSFanalysis/FunImg/', sub, '/'];
    sourceT1DataDir=['/home/data/Projects/workingMemory/data/DPARSFanalysis/T1Img/', sub, '/'];
    destinatFunDataDir=['/home/data/Projects/workingMemory/data/CPACAnalysisNew/wave1/', sub, '/FunImg'];
    destinatT1DataDir=['/home/data/Projects/workingMemory/data/CPACAnalysisNew/wave1/', sub, '/T1Img'];
    mkdir (destinatFunDataDir)
    mkdir (destinatT1DataDir)
    copyfile([sourceFunDataDir, 'rest.nii'], [destinatFunDataDir, '/'])
    copyfile([sourceT1DataDir, 'mprage.nii'], [destinatT1DataDir, '/'])
end
