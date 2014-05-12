for i in 0000 0001 0002 0003 0004 0005 0006 0007 0008 0009; do
mkdir -p /home/data/Projects/dickstein_new/flameo/dr_$i;
fslmaths /home/data/Projects/dickstein_new/output/pipeline_Phoenix/group_analysis_results/_grp_model_nov_79/dr_tempreg_maps_z_files_smooth/_scan_func_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/_compcor_ncomponents_5_selector_pc10.linear1.wm0.global0.motion1.quadratic0.gm0.compcor1.csf0/_bandpass_freqs_0.01.0.1/_spatial_map_smith_rsn20/_fwhm_5/temp_reg_map_z_$i/merged/temp_reg_map_z_${i}_wimt_maths_merged.nii.gz -abs -Tmin -bin /home/data/Projects/dickstein_new/flameo/dr_$i/merged_mask.nii.gz;
cd /home/data/Projects/dickstein_new/flameo/dr_$i;
flameo 
--copefile=/home/data/Projects/dickstein_new/output/pipeline_Phoenix/group_analysis_results/_grp_model_nov_79/dr_tempreg_maps_z_files_smooth/_scan_func_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/_compcor_ncomponents_5_selector_pc10.linear1.wm0.global0.motion1.quadratic0.gm0.compcor1.csf0/_bandpass_freqs_0.01.0.1/_spatial_map_smith_rsn20/_fwhm_5/temp_reg_map_z_$i/merged/temp_reg_map_z_${i}_wimt_maths_merged.nii.gz 
--covsplitfile=/home/data/Projects/dickstein_new/settings/Models/nov_79/nov_79.grp 
--designfile=/home/data/Projects/dickstein_new/settings/Models/nov_79/nov_79.mat 
--fcontrastsfile=/home/data/Projects/dickstein_new/settings/Models/nov_79/nov_79.fts 
--ld=stats 
--maskfile=/home/data/Projects/dickstein_new/flameo/dr_$i/merged_mask.nii.gz 
--runmode=ols 
--tcontrastsfile=/home/data/Projects/dickstein_new/settings/Models/nov_79/nov_79.con;
done

