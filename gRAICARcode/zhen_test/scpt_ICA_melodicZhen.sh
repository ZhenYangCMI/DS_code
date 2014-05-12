
## full/path/to/site
analysisdirectory=/home2/data/Projects/workingMemory/data/gRAICAR_analysis/wave1

## full/path/to/site/subject_list
subject_list=/home2/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt

## name of resting-state scan (no extension)
rest=gms_AllVolume

## name of rest directory
func_dir_name=rest_1_FunImgARCW_gms

## TR
TR=2

## if use freesurfer derived volumes
fs_brain=false #true
## if refine anat registration
ref_anat_reg=false
## standard/template brain
#template_head=${analysisdirectory}/group/templates/lifespan150_2mm.nii.gz
standard_head=${FSLDIR}/data/standard/MNI152_T1_3mm.nii.gz
standard_brain=${FSLDIR}/data/standard/MNI152_T1_3mm_brain.nii.gz
#standard_template=${analysisdirectory}/group/templates/lifespan_3mm_brain.nii.gz

standard_template=/home2/data/Projects/workingMemory/mask/MNI152_T1_3mm_brain_mask_dil.nii.gz
########################################################################################

module load fsl/5.0
# check whether the num IC is specified
num_ic=0
if (( $# > 1 ))
then
	num_ic=$2
fi

subjects=`cat ${subject_list}`

subject=$1

#for realization in `seq 2 30`
#do
## directory setup
dir=${analysisdirectory}
func_dir=${dir}/${subject}/${func_dir_name}
func_reg_dir=${func_dir}/reg

ICA_dir=${func_dir}/ICA

echo --------------------------
echo running subject ${subject}
echo --------------------------

mkdir -p ${ICA_dir} ; cd ${ICA_dir}

## 0. Make mask
#rm -rf ${func_dir}/${rest}_gms_mask.nii.gz
#if [ ! -e ${func_dir}/${rest}_gms_mask.nii.gz ]
#then
3dAutomask -overwrite -prefix ${func_dir}/${rest}_gms_mask.nii.gz  ${func_dir}/${rest}_gms.nii.gz
#fi

## 1. Temporal filtering

#rm -rf ${rest}_filt.nii.gz
#rm -rf ${ICA_dir}/${rest}_filt.nii.gz
#if [ ! -e ${rest}_filt.nii.gz ]
#then
#echo "High-pass filtering: ${subject}"
#3dTcat -rlt -float -overwrite -prefix ${func_dir}/rlt.nii.gz  ${func_dir}/${rest}_gms.nii.gz
#3dFourier -overwrite -lowpass ${lp} -highpass ${hp} -prefix ${ICA_dir}/${rest}_filt.nii.gz ${func_dir}/rlt.nii.gz
#fi


## 2. Spatial smoothing
#if [ ! -e ${rest}_pp_ica.nii.gz ]
#then
#fslmaths ${rest}_filt.nii.gz -kernel gauss ${sigma} -fmean -mas ${func_dir}/${rest}_gms_mask.nii.gz ${rest}_pp_ica.nii.gz
#fi

## 3. ICA
if [ -e ${rest}.nii.gz ]
then
echo "Running MELODIC (${num_ic} components): ${subject}"
rm -rf tmp.ica

if (( $num_ic == 0 ))
then
melodic -i ${rest}.nii.gz --outdir=tmp.ica --mask=${func_dir}/${rest}_gms_mask.nii.gz --nobet --no_mm --Oorig
mkdir -p melodic_autoDim
mv tmp.ica/melodic_IC.nii.gz melodic_autoDim/melodic_IC.nii.gz
mv tmp.ica/melodic_FTmix tmp.ica/melodic_mix melodic_autoDim/
rm -rf tmp.ica
else
melodic -i ${rest}_filt.nii.gz --outdir=tmp_${num_ic}.ica --mask=${func_dir}/${rest}_gms_mask.nii.gz --dim=${num_ic} --nobet --no_mm --Oorig -v
rm -rf melodic_dim${num_ic}/
mkdir -p melodic_dim${num_ic}
mv tmp_${num_ic}.ica/melodic_IC.nii.gz melodic_dim${num_ic}/melodic_IC.nii.gz
mv tmp_${num_ic}.ica/melodic_FTmix tmp_${num_ic}.ica/melodic_mix melodic_dim${num_ic}/
rm -rf tmp_${num_ic}.ica
fi

else
	echo "melodic: input file not found, check preprocessing"
fi

