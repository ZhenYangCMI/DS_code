

preprocessDate='1_1_14'

for covType in compCor; do

# full/path/to/site/subject_list
subject_list=/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt

### 1. spatial normalize the derivatives
standard_template=/home2/data/Projects/workingMemory/mask/MNI152_T1_2mm_brain.nii.gz
anatDir=/home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/${covType}/T1Img

	#for measure in ReHo fALFF DualRegression skewness; do
for measure in skewness; do
	dataDir=/home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/${covType}/${measure}

		for sub in `cat $subject_list`; do

			echo --------------------------
			echo running subject ${sub}
			echo --------------------------

			# Applywarp
			cd ${dataDir}

			if [[ ${measure} = "skewness" ]]; then
			WarpTimeSeriesImageMultiTransform 4 ${measure}_${sub}.nii ${measure}_${sub}_MNI.nii -R ${standard_template} ${anatDir}/anat2MNIWarp_${sub}.nii.gz ${anatDir}/anat2MNIAffine_${sub}.txt ${anatDir}/fun2anatAffine_${sub}.txt
			else
			WarpTimeSeriesImageMultiTransform 4 ${measure}_${sub}.nii.gz ${measure}_${sub}_MNI.nii.gz -R ${standard_template} ${anatDir}/anat2MNIWarp_${sub}.nii.gz ${anatDir}/anat2MNIAffine_${sub}.txt ${anatDir}/fun2anatAffine_${sub}.txt
			fi

		done
	done


### 2. smooth the normalized derivatives

	#for measure in ReHo fALFF DualRegression DegreeCentrality skewness; do
for measure in skewness; do
	dataDir=/home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/${covType}/${measure}

		for sub in `cat $subject_list`; do

			echo --------------------------
			echo running subject ${sub}
			echo --------------------------

			cd ${dataDir}
			if [[ ${measure} = "skewness" ]]; then
			3dmerge -1blur_fwhm 6.0 -doall -prefix ${measure}_${sub}_MNI_fwhm6.nii ${measure}_${sub}_MNI.nii
			elif [[ ${measure} = "DegreeCentrality" ]]; then
			3dmerge -1blur_fwhm 6.0 -doall -prefix ${measure}_${sub}_MNI_fwhm6.nii ${measure}_${sub}.nii.gz
			else
			3dmerge -1blur_fwhm 6.0 -doall -prefix ${measure}_${sub}_MNI_fwhm6.nii ${measure}_${sub}_MNI.nii.gz
			fi

		done
	done
done

### 3. split the dual regression and reorgnize the files 
preprocessDate=1_1_14
subject_list=/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt

for covType in noGSR GSR compCor; do

dataDir=/home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/${covType}/DualRegression

	for sub in `cat $subject_list`; do

		echo --------------------------
		echo running subject ${sub}
		echo ---------------------
		cd ${dataDir}
		fslsplit DualRegression_${sub}_MNI_fwhm6.nii DualRegression_${sub}_MNI_fwhm6_

		for comp in 0 1 2 3 4 5; do
			mkdir -p /home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/${covType}/DualRegression${comp}
			3dcalc -a DualRegression_${sub}_MNI_fwhm6_000${comp}.nii.gz -expr 'a' -prefix /home/data/Projects/workingMemory/results/CPAC_${preprocessDate}/reorgnized/${covType}/DualRegression${comp}/DualRegression${comp}_${sub}_MNI_fwhm6.nii
		done
	done
done


