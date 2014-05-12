

%%%STEP
%%%%%%%%%%%
%Do Transformation (Save in a .m file)


ConditionSuffix='';

ConditionList_ALFFfALFFSCA={'FunImgARC','FunImgARglobalC','FunImgARgraymatterC'};

ConditionList_ReHo={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_DC={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_VMHC={'FunImgARCWSsym','FunImgARglobalCWSsym','FunImgARgraymatterCWSsym'};

%MeasureDirSet = {'ALFF_Detrend_BAND_01_1','fALFF_Detrend_BAND_01_1','ReHo_Detrend_Filter01_1','VMHC_NormalizeSmoothed4point5First_SYM_Detrend_Filter01_1','AndrewsHannaROI_zFCMap_ROIInMNI_FCInOriginalSpace_Detrend_Filter01_1','DegreeCentrality_Detrend_Filter01_1'};
MeasureDirSet = {'LeftMTROI_zFCMap_ROIInMNI_FCInOriginalSpace_Detrend_Filter01_1'};
%MeasureSet = {'ALFF','fALFF','ReHo','VMHC','PCCFC','DC'};
MeasureSet = {'MTFC'};
%MeasurePrefixSet = {'swALFF_','swfALFF_','sReHo_','zVMHC_','swz','sDegreeCentrality_'};
MeasurePrefixSet = {'swz'};
MeasureSuffixSet = {'.nii'};

[BrainMaskData,Vox,BrainMaskHeader] = rest_readfile(BrainMaskFile);

for iMeasure=1:length(MeasureDirSet)
    
    if strcmpi(MeasureSet{iMeasure},'ALFF') || strcmpi(MeasureSet{iMeasure},'fALFF') || strcmpi(MeasureSet{iMeasure},'PCCFC') || strcmpi(MeasureSet{iMeasure},'MTFC')
        ConditionList = ConditionList_ALFFfALFFSCA;
        ProjectDirForMeasures = ProjectDirForMeasures_NativeSpace;
    elseif strcmpi(MeasureSet{iMeasure},'ReHo')
        ConditionList = ConditionList_ReHo;
        ProjectDirForMeasures = ProjectDirForMeasures_MNISpace;
    elseif strcmpi(MeasureSet{iMeasure},'DC')
        ConditionList = ConditionList_DC;
        ProjectDirForMeasures = ProjectDirForMeasures_MNISpace;
    elseif strcmpi(MeasureSet{iMeasure},'VMHC')
        ConditionList = ConditionList_VMHC;
        ProjectDirForMeasures = ProjectDirForMeasures_MNISpace;
    end
    
    InputDir=[ProjectDirForMeasures,filesep,'ResultsWS',filesep,MeasureDirSet{iMeasure}];
    OutputDir=[ProjectDirForOutput,filesep,'ResultsWS',filesep,MeasureDirSet{iMeasure}];
    
    
    for iCondition=1:1
        mkdir([OutputDir,filesep,ConditionList{iCondition},ConditionSuffix]);
        
        parfor i=1:AutoDataProcessParameter.SubjectNum
            
            DirImg = dir([InputDir,filesep,ConditionList{iCondition},ConditionSuffix,filesep,MeasurePrefixSet{iMeasure},'*',AutoDataProcessParameter.SubjectID{i},'*',MeasureSuffixSet{iMeasure}]);
            InputFile_Temp = [InputDir,filesep,ConditionList{iCondition},ConditionSuffix,filesep,DirImg(1).name];
            
            [BrainData, Vox, Header] = rest_readfile(InputFile_Temp);
            
            
            %0. Raw
            Temp = BrainData;
            rest_WriteNiftiImage(Temp,Header,[OutputDir,filesep,ConditionList{iCondition},ConditionSuffix,filesep,'0_Raw_',AutoDataProcessParameter.SubjectID{i},'.nii']);

            
            %1. Global mean normalization (divide)
            Temp = (BrainData ./ mean(BrainData(find(BrainMaskData)))) .* (BrainMaskData~=0);
            rest_WriteNiftiImage(Temp,Header,[OutputDir,filesep,ConditionList{iCondition},ConditionSuffix,filesep,'1_MeanDivide_',AutoDataProcessParameter.SubjectID{i},'.nii']);
            
            
            
            %2. Global mean normalization (subtract)
            Temp = (BrainData - mean(BrainData(find(BrainMaskData)))) .* (BrainMaskData~=0);
            rest_WriteNiftiImage(Temp,Header,[OutputDir,filesep,ConditionList{iCondition},ConditionSuffix,filesep,'2_MeanSubtract_',AutoDataProcessParameter.SubjectID{i},'.nii']);
            
            
            %3. Global median normalization (divide)
            Temp = (BrainData ./ mean(BrainData(find(BrainMaskData)))) .* (BrainMaskData~=0);
            rest_WriteNiftiImage(Temp,Header,[OutputDir,filesep,ConditionList{iCondition},ConditionSuffix,filesep,'3_MedianDivide_',AutoDataProcessParameter.SubjectID{i},'.nii']);
            
            
            
            %4. Global median normalization (subtract)
            Temp = (BrainData - mean(BrainData(find(BrainMaskData)))) .* (BrainMaskData~=0);
            rest_WriteNiftiImage(Temp,Header,[OutputDir,filesep,ConditionList{iCondition},ConditionSuffix,filesep,'4_MedianSubtract_',AutoDataProcessParameter.SubjectID{i},'.nii']);
            
            
            
            
            %5. Variance normalization (Z score transformation)
            Temp = ((BrainData - mean(BrainData(find(BrainMaskData)))) ./ std(BrainData(find(BrainMaskData)))) .* (BrainMaskData~=0);
            rest_WriteNiftiImage(Temp,Header,[OutputDir,filesep,ConditionList{iCondition},ConditionSuffix,filesep,'5_z_',AutoDataProcessParameter.SubjectID{i},'.nii']);
            
            
            
            %6. Inter-Quartile Range normalization
            Prctile_25_75 = prctile(BrainData(find(BrainMaskData)),[25 50 75]);
            Temp = ((BrainData - Prctile_25_75(2)) / (Prctile_25_75(3) - Prctile_25_75(1)) ) .* (BrainMaskData~=0);
            rest_WriteNiftiImage(Temp,Header,[OutputDir,filesep,ConditionList{iCondition},ConditionSuffix,filesep,'6_IQR_',AutoDataProcessParameter.SubjectID{i},'.nii']);
            
            %7. Quantile normalization: See later
            %8. Rank normalization: See later
            
            %9. Gaussian function fit normalization: Lowe et al., 1998.

            [y,x]=hist(BrainData(find(BrainMaskData)),ceil(sqrt(length(find(BrainMaskData)))));

            h=0.5; %For FWHM

            %% cutting
            ymax=max(y);
            xnew=x(find(y>ymax*h));
            ynew=y(find(y>ymax*h));
            
            %% fitting to the function
            % y=A * exp( -(x-mu)^2 / (2*sigma^2) )
            % (the fitting is done by a polyfit on the log of the data)
            
            ylog=log(ynew);
            xlog=xnew;
            p=polyfit(xlog,ylog,2);
            A2=p(1);
            A1=p(2);
            A0=p(3);
            sigma=sqrt(-1/(2*A2));
            mu=A1*sigma^2;
            A=exp(A0+mu^2/(2*sigma^2));
            
            
            Temp = ((BrainData - mu) ./ sigma) .* (BrainMaskData~=0);
            rest_WriteNiftiImage(Temp,Header,[OutputDir,filesep,ConditionList{iCondition},ConditionSuffix,filesep,'9_GFN_',AutoDataProcessParameter.SubjectID{i},'.nii']);

        end
    end
    
end



