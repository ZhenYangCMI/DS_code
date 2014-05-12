#subject=$1

## full/path/to/site
analysisdirectory=/home2/data/Projects/workingMemory/data/gRAICAR_analysis/wave1

## full/path/to/site/subject_list
subList=/home2/data/Projects/workingMemory/data/gRAICAR_analysis/wave1/scripts/subjectList_Num_sub45.txt

## name of resting-state scan (no extension)
rest=rest_gms

## name of rest directory
func_dir_name=FunImg

## name of anat directory
anat_dir_name=T1Img

standard_template=/home2/data/Projects/workingMemory/mask/MNI152_T1_2mm_brain.nii.gz
standard_template_3mm=/home2/data/Projects/workingMemory/mask/MNI152_T1_3mm_brain.nii.gz
##############################################################
## compute the transformation matrix and norm the ICA componets
##############################################################
#subject=test_9006154
for subject in `cat $subList`; do

#for realization in `seq 2 30`
#do
## directory setup
dir=${analysisdirectory}
func_dir=${dir}/${subject}/${func_dir_name}
func_reg_dir=${func_dir}/reg
anat_dir=${dir}/${subject}/${anat_dir_name}
anat_reg_dir=${anat_dir}/reg
ICA_dir=${func_dir}/ICA

echo --------------------------
echo running subject ${subject}
echo --------------------------

# regist T1 to standard
flirt -ref ${standard_template} -in ${anat_reg_dir}/highres_rpi.nii.gz -out ${anat_dir}/reg/anat2MNI152 -omat ${anat_dir}/reg/anat2MNI152.mat -cost corratio -dof 12 -interp trilinear #here should use highres_rpi

cd ${anat_reg_dir}
fnirt --aff=anat2MNI152.mat --config=$FSLDIR/etc/flirtsch/T1_2_MNI152_2mm.cnf --cout=highres2MNI152_warp --in=highres_rpi.nii.gz --jout=highres2MNI152_jacobian --logout=highres2MNI152_log.txt --ref=${standard_template} --iout=highres2MNI152

# T1 image tissue segmentation
fast -t 1 -o segment -p -g -S 1 highres_rpi.nii.gz

# register func to T1 using BBR
cd ${func_dir}
fslroi ${rest}.nii.gz example_func.nii.gz 7 1
	fslmaths example_func.nii.gz -mas ${rest}_mask.nii.gz tmpbrain.nii.gz
flirt -in tmpbrain.nii.gz -ref ${anat_reg_dir}/highres_rpi.nii.gz -out ${func_reg_dir}/example_func2highresBBR.nii.gz -omat ${func_reg_dir}/example_func2highresBBR.mat  -cost bbr -wmseg ${anat_reg_dir}/segment_seg_2.nii.gz -dof 6 -init ${func_reg_dir}/example_func2highres4mask.mat -schedule /usr/share/fsl/5.0/etc/flirtsch/bbr.sch

cd ${ICA_dir}
input_dir=melodic_autoDim
## check if the input file exist
if [ -e ${input_dir}/melodic_IC.nii.gz ];then
       applywarp --ref=${standard_template_3mm} --in=${input_dir}/melodic_IC.nii.gz --out=${input_dir}/melodic_IC_mni152_3mm.nii.gz --warp=${anat_reg_dir}/highres2MNI152_warp.nii.gz --premat=${func_reg_dir}/example_func2highresBBR.mat
else
    echo "${input_dir}/medlodic_IC.nii.gz not found"
fi

done


