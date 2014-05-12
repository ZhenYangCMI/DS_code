subList="/home2/data/Projects/workingMemory/code/C-PAC-Config/subject_list_Num.txt" 
for i in `cat $subList`; do
3dcalc -a /home2/data/Projects/workingMemory/results/CPAC_analysis/output/sym_links/pipeline_HackettCity/linear1.wm1.global1.motion1.quadratic1.csf1_CSF_0.98_GM_0.7_WM_0.96/sub$i/scan_rest_1_rest/sca_roi/roi_rois_3mm/bandpass_freqs_0.01.0.1/fwhm_6/sca_roi_Z_smooth_2.nii.gz \
 -b /home2/data/Projects/workingMemory/data/DPARSF_analysis/ResultsS_MNICal/FC/szROI2FCMap_$i.nii \
-expr 'a-b' \
-prefix /home2/data/Projects/workingMemory/figs/cmpCpacAndDparsf/FC2_dif_CPACminusDPARSF/FC2_dif_CPACminusDPARSF_$i.
    
done
