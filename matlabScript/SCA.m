clear
clc

ROImaskGroup='adoles' % can be 'child' or 'adoles'
dataDir='/home/data/Projects/workingMemory/data/DPARSF_analysis/';
subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_46sub.txt']);
numSub=length(subList);

taskList={'BT'}

MaskData='/home/data/Projects/workingMemory/mask/CWAS_newMask/stdMask_46sub_100percent.nii'


for j=1:length(taskList)
    task=char(taskList{j})
    mkdir(['/home/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followUp/CWAS', ROImaskGroup, '_', task])
    outputDir= ['/home/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/followUp/CWAS', ROImaskGroup, '_', task, '/'];
    for i=1:numSub
        sub=num2str(subList(i))
        AllVolume=[dataDir, 'FunImgARCWFresample/', sub, '/Filtered_4DVolume_4mm_fwhm6_masked.nii'];
        
        ROIDef={['/home/data/Projects/workingMemory/groupAnalysis/CWAS/46sub/CWAS', ROImaskGroup, '/', task, '.mdmr/cluster_mask_', task, '.nii.gz']}
        OutputName=[outputDir, ROImaskGroup, '_', task, '_', sub];
        IsMultipleLabel=1;
        [FCBrain, Header] = y_SCA(AllVolume, ROIDef, OutputName, MaskData, IsMultipleLabel);
    end
end