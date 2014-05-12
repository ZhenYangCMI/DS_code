
## full/path/to/site
analysisdirectory=/home2/data/Projects/workingMemory/data/gRAICAR_analysis/wave1

## full/path/to/site/subject_list
subject_list=/home2/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt

## name of resting-state scan (no extension)
rest=varNorm_AllVolume_masked_fwhm4.5

## name of rest directory
func_dir_name=rest_1_FunImgARCFS

subList="/home2/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt" 
for i in `cat $subList`; do

#for realization in `seq 2 30`
#do
## directory setup
dir=${analysisdirectory}
func_dir=${dir}/sub${i}/${func_dir_name}
ICA_dir=${func_dir}/ICA_gms

echo --------------------------
echo running subject ${i}
echo --------------------------

mkdir -p ${ICA_dir} ; cd ${ICA_dir}
cp ${func_dir}/${rest}.nii ./

## 0. Make mask
rm -rf ${func_dir}/${rest}_mask.nii.gz
if [ ! -e ${func_dir}/${rest}_mask.nii.gz ]
then
3dAutomask -overwrite -prefix ${func_dir}/${rest}_mask.nii  ${func_dir}/${rest}.nii
fi

## 1. ICA

cmd="melodic -i ${rest}.nii --outdir=tmp.ica --mask=${func_dir}/${rest}_mask.nii --nobet --no_mm --Oorig"
echo $cmd
eval $cmd

rm -rf melodic_autoDim
mkdir -p melodic_autoDim
mv tmp.ica/melodic_IC.nii.gz melodic_autoDim/melodic_IC.nii.gz
mv tmp.ica/melodic_FTmix tmp.ica/melodic_mix melodic_autoDim/
#rm -rf tmp.ica
done

