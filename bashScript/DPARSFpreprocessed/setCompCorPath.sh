
sublistFile=/home/data/Projects/workingMemory/data/DPARSF_analysis/compCorTS.txt
subList="/home2/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt" 
for i in `cat $subList`; do
echo "/home/data/Projects/workingMemory/data/DPARSF_analysis/compCorPC/${i}_5componets.txt" >> $sublistFile
done

addpath /home/data/Projects/microstate/Soft/DPARSF_V2.3_130615/
addpath /home/data/Projects/microstate/Soft/REST_V1.8_130615/
 addpath(genpath('/home/data/HeadMotion_YCG/YAN_Program/spm8'))
