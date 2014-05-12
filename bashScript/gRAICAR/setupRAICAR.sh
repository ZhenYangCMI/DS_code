maskGroup='68sub'
subList="/home2/data/Projects/workingMemory/mask/subjectList_Num_${maskGroup}.txt" 


standard_template='/home2/data/Projects/workingMemory/data/gRAICAR_analysis/MNI152_T1_3mm_brain.nii'

# for Rockland sample
subList="/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/reorder_subjects_gRAICAR126.list" 
for subject in `cat $subList`; do
echo ${subject}
#mkdir /home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/ICAComp_ari/${subject}
#3dTstat -mean -prefix /home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/${subject}/FunImg/ICA_gms/BOLDrestingCAP_gms_mean.nii.gz /home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/${subject}/FunImg/ICA_gms/BOLDrestingCAP_gms.nii.gz
#3dcalc -a /home2/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/ICAComp1W/${subject}/wmelodic_IC.nii -expr 'a' -prefix /home2/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/DPARSF/${subject}/Fun/ICA_DPARSFA/melodic_autoDim/wmelodic_IC.nii.gz

#applywarp --ref=${standard_template} --in=/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/${subject}/FunImg/ICA_gms/BOLDrestingCAP_gms_mean.nii.gz --out=/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/${subject}/FunImg/ICA_gms/BOLDrestingCAP_gms_mean_mni152_Zhi.nii.gz --warp=/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/${subject}/T1Img/reg/highres2standard_warpZhi.nii.gz --premat=/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/${subject}/FunImg/reg/example_func2highresZhi.mat

applywarp --ref=${standard_template} --in=/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/${subject}/FunImg/ICA_gms/BOLDrestingCAP_gms_mean.nii.gz --out=/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/${subject}/FunImg/ICA_gms/BOLDrestingCAP_gms_mean_mni152_Zhen.nii.gz --warp=/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/${subject}/T1Img/reg/highres2MNI152_warp.nii.gz --premat=/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/${subject}/FunImg/reg/example_func2highresBBR.mat
done




# create a mask to maskout the regions ourside of the brain before run melodic
for i in `cat $subList`; do
3dAutomask -overwirte -prefix /home/data/Projects/workingMemory/data/DPARSF_analysis/FunImgAR/${i}/rarest_mask.nii /home/data/Projects/workingMemory/data/DPARSF_analysis/FunImgAR/${i}/rarest.nii 
    echo "Image for subject $i has been resampled";
done


# create mask for gRAICAR normalized components
for i in `cat $subList`; do

3dAutomask -overwrite -prefix /home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub${i}/rest_1_FunImgARCF/ICA/melodic_autoDim/wmelodic_IC_mask.nii /home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub${i}/rest_1_FunImgARCF/ICA/melodic_autoDim/wmelodic_IC.nii

    echo "Mask for subject $i has been created";
done

3dMean -prefix /home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/mask/wmelodic_IC_mask_68sub.nii /home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub*/rest_1_FunImgARCF/ICA/melodic_autoDim/wmelodic_IC_mask.nii

3dcalc -a /home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/mask/wmelodic_IC_mask_68sub.nii -expr 'step(a-0.8999)' -prefix /home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/mask/wmelodic_IC_mask_68sub_90pct.nii

# change the .nii file to .nii.gz file 
for i in `cat $subList`; do
3dcalc -a /home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub${i}/rest_1_FunImgARCF/ICA/melodic_autoDim/wmelodic_IC.nii -expr 'a' -prefix /home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub${i}/rest_1_FunImgARCF/ICA/melodic_autoDim/wmelodic_IC.nii.gz
echo "subject $i";
done

# smot
smooth=4.5

maskGroup='68sub'
subList="/home2/data/Projects/workingMemory/mask/subjectList_Num_${maskGroup}.txt" 
for i in `cat $subList`; do
#mkdir /home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub{i}/rest_1_FunImgARCFS
cp /home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub${i}/rest_1_FunImgARCF/AllVolume_masked.nii /home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub{i}/rest_1_FunImgARCFS/
3dmerge -1blur_fwhm 4.5 -doall -prefix /home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub${i}/rest_1_FunImgARCF/AllVolume_masked_fwhm${smooth}.nii /home/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/sub${i}/rest_1_FunImgARCF/AllVolume_masked.nii

done



