for i in `ls /home/data/Projects/workingMemory/data/DPARSF_analysis/noGSR/FunImgARCWF68sub_fwhm8`; do
    3dcalc -a /home/data/Projects/workingMemory/data/DPARSF_analysis/noGSR/Masks/${i}_CsfMask_07_91x109x91.nii -b /home/data/Projects/workingMemory/data/DPARSF_analysis/noGSR/Masks/${i}_WhiteMask_09_91x109x91.nii -expr 'a+b' -prefix /home/data/Projects/workingMemory/data/DPARSF_analysis/noGSR/Masks/${i}_CsfWhiteMask_91x109x91.nii;
    echo "The WMCSFmask has been created for sub${i}";
done
