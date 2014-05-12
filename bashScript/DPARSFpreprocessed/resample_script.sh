for i in `ls /home2/data/Projects/workingMemory/results/CPAC_analysis/output/sym_links/pipeline_HackettCity/linear1.wm1.global1.motion1.quadratic1.csf1_CSF_0.98_GM_0.7_WM_0.96`; do
    3dresample -dxyz 3.0 3.0 3.0 -prefix /home2/data/Projects/workingMemory/results/CPAC_analysis/output/sym_links/pipeline_HackettCity/linear1.wm1.global1.motion1.quadratic1.csf1_CSF_0.98_GM_0.7_WM_0.96/$i/scan_rest_1_rest/sca_roi/roi_rois_3mm/bandpass_freqs_0.01.0.1/sca_roi_Z_2_3mm.nii.gz  -inset /home2/data/Projects/workingMemory/results/CPAC_analysis/output/sym_links/pipeline_HackettCity/linear1.wm1.global1.motion1.quadratic1.csf1_CSF_0.98_GM_0.7_WM_0.96/$i/scan_rest_1_rest/sca_roi/roi_rois_3mm/bandpass_freqs_0.01.0.1/sca_roi_Z_2.nii.gz;
    echo "Image for subject $i has been resampled";
done

for i in `ls /home2/data/Projects/workingMemory/data/DPARSF_analysis/FunImg`; do
3dresample -dxyz 3.0 3.0 3.0 -prefix /home2/data/Projects/workingMemory/data/DPARSF_analysis/nativeCal/Results/FC/zROI2FCMap_${i}_3mm.nii -inset /home2/data/Projects/workingMemory/data/DPARSF_analysis/nativeCal/Results/FC/zROI2FCMap_${i}.nii;
3drefit -deoblique /home2/data/Projects/workingMemory/data/DPARSF_analysis/nativeCal/Results/FC/zROI1FCMap_${i}_3mm.nii;
    3dresample -orient RPI -prefix /home2/data/Projects/workingMemory/data/DPARSF_analysis/nativeCal/Results/FC/zROI2FCMap_${i}_3mm_RPI.nii -inset /home2/data/Projects/workingMemory/data/DPARSF_analysis/nativeCal/Results/FC/zROI2FCMap_${i}_3mm.nii;
    echo "Image for subject $i has been resampled";
done

for i in `ls /home2/data/Projects/workingMemory/data/DPARSF_analysis/FunImg`; do
3dresample -dxyz 3.0 3.0 3.0 -prefix /home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub${i}/rest_1_FunImgARCF/Filtered_4DVolume_3mm.nii -inset /home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub${i}/rest_1_FunImgARCF/Filtered_4DVolume.nii;
3drefit -deoblique /home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub${i}/rest_1_FunImgARCF/Filtered_4DVolume_3mm.nii;
    3dresample -orient RPI -prefix /home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub${i}/rest_1_FunImgARCF/Filtered_4DVolume_3mm_RPI.nii -inset /home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub${i}/rest_1_FunImgARCF/Filtered_4DVolume_3mm.nii;
    echo "Image for subject $i has been resampled";
done

for i in `ls /home2/data/Projects/workingMemory/data/DPARSF_analysis/FunImg`; do
3dAutomask -overwirte -prefix /home/data/Projects/workingMemory/data/DPARSF_analysis/FunImgAR/${i}/rarest_mask.nii /home/data/Projects/workingMemory/data/DPARSF_analysis/FunImgAR/${i}/rarest.nii 
    echo "Image for subject $i has been resampled";
done

for measure in fALFF ReHo DegreeCentrality_PositiveBinarizedSumBrain skewness; do

covType=noGSR
for measure in fALFF ReHo DegreeCentrality_PositiveBinarizedSumBrain skewness; do
for i in `ls /home/data/Projects/workingMemory/data/DPARSFanalysis/compCor/FunImgARCW`; do
#3dresample -dxyz 3.0 3.0 3.0 -prefix /home/data/Projects/workingMemory/data/DPARSFanalysis/GSR/Results/${measure}/${measure}Map_${i}_3mm.nii -inset /home/data/Projects/workingMemory/data/DPARSFanalysis/GSR/Results/${measure}/${measure}Map_${i}.nii;
3dcalc -a /home/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/Results/${measure}/${measure}Map_${i}.nii -expr 'a' -prefix /home/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/Results/${measure}/${measure}Map_${i}_deobliq.nii
3drefit -deoblique /home/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/Results/${measure}/${measure}Map_${i}_deobliq.nii;
    3dresample -orient RPI -prefix /home/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/Results/${measure}/${measure}Map_${i}_deobliq_RPI.nii -inset /home/data/Projects/workingMemory/data/DPARSFanalysis/${covType}/Results/${measure}/${measure}Map_${i}_deobliq.nii;
    echo "Image for subject $i has been resampled";
done
done


for measure in fALFF ReHo; do
for i in `ls /home/data/Projects/workingMemory/data/DPARSFanalysis/compCor/FunImgARCW`; do
3dcalc -a /home/data/Projects/workingMemory/data/DPARSFanalysis/Results/${measure}/${measure}Map_${i}.nii -expr 'a' -prefix /home/data/Projects/workingMemory/data/DPARSFanalysis/Results/${measure}/${measure}Map_${i}_deobliq.nii
3drefit -deoblique /home/data/Projects/workingMemory/data/DPARSFanalysis/Results/${measure}/${measure}Map_${i}_deobliq.nii;
    3dresample -orient RPI -prefix /home/data/Projects/workingMemory/data/DPARSFanalysis/Results/${measure}/${measure}Map_${i}_deobliq_RPI.nii -inset /home/data/Projects/workingMemory/data/DPARSFanalysis/Results/${measure}/${measure}Map_${i}_deobliq.nii;
    echo "Image for subject $i has been resampled";
done
done
