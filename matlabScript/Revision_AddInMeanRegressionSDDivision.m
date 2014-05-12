


%%%%%%
%%%%
%Group Analysis initialization
%InitGroup


%%%
%Get the design matrix

load('/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/SubID_SexAge_All18Sites_895Sub.mat');


Age=double(Age_AllSites);

Sex=zeros(length(SexFM_AllSites),1);
for i=1:length(SexFM_AllSites)
    if strcmpi(SexFM_AllSites{i},'f')
        Sex(i)=-1;
    elseif strcmpi(SexFM_AllSites{i},'m')
        Sex(i)=1;
    end
end

EyeStatus = double(EyeColosed_AllSites);
EyeStatus(find(EyeStatus==0)) = -1; %EC: 1; EO: -1.

TeslaStatus = double(Tesla15T_AllSites);
TeslaStatus(find(TeslaStatus==1)) = -1; %3T: 1; 1.5T: -1.
TeslaStatus(find(TeslaStatus==0)) = 1;  %3T: 1; 1.5T: -1.

Site=SiteID_AllSites;
%Note: NewYork_a, NewYork_b are two different sites now.
%Leiden_2180, Leiden_2200 are two different sites now.

SubID=SubID_AllSites;


%%%1. Deal With Age
AgeRange = [1 100];
%AgeRange = [7 14];

AgeTemp = (Age>=AgeRange(1)) .* (Age<=AgeRange(2));


%%%2. Deal with head motion
MeanFD = MeanFDJenkinson_AllSites;

MeanFDTemp = MeanFD<(mean(MeanFD)+2*std(MeanFD));

WantedSubMatrix = AgeTemp.*MeanFDTemp;



%%%3. Deal with bad coverage

CoverageTemp = VoxelPercentOverlapWithMask_90>(mean(VoxelPercentOverlapWithMask_90)-2*std(VoxelPercentOverlapWithMask_90));

WantedSubMatrix=WantedSubMatrix.*CoverageTemp';

% 
% %%%4. Exclude Sites
% NoBadSite=ones(length(SubID),1);
% NoBadSite(Site==12)=0;%Pitt 2
% NoBadSite(Site==3)=0;%Caltech
% 
% WantedSubMatrix=WantedSubMatrix.*NoBadSite;
% 



WantedSubIndex = find(WantedSubMatrix);

%Select subjects
SubID=SubID(WantedSubIndex);

Age=Age(WantedSubIndex);
Sex=Sex(WantedSubIndex);
MeanFD=MeanFD(WantedSubIndex);

EyeStatus=EyeStatus(WantedSubIndex);
TeslaStatus=TeslaStatus(WantedSubIndex);

Site=Site(WantedSubIndex);
SiteName_AllSites = SiteName_AllSites(WantedSubIndex);
SiteID_AllSites = SiteID_AllSites(WantedSubIndex);

SiteCov=[];
SiteIndex = unique(Site);
for i=1:length(SiteIndex)-1
    SiteCov(:,i) = Site==SiteIndex(i);
end

%Model 1:
%AllCov = [ones(length(SubID),1), Age,Sex,MeanFD,EyeStatus,TeslaStatus,SiteCov];

%Model 2: don't need EyeStatus, TeslaStatus. Rank deficit
AllCov = [ones(length(SubID),1), Age,Sex,MeanFD,SiteCov];

%Centering: Let the first column (constant) have the mean effect.
AllCov(:,2:end) = (AllCov(:,2:end)-repmat(mean(AllCov(:,2:end)),size(AllCov(:,2:end),1),1));

%Set the contrast for site effects
SiteEffectContrast = zeros(1,size(AllCov,2));
SiteEffectContrast(end - size(SiteCov,2) + 1 : end) = 1; 









%%%
%Mean Regression + SD Division
%%%

%First init group covs

BrainMaskFile = ['/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures/GroupMask/GroupMask90Percent.nii'];

%BrainMaskFile = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllData/SymmetricGroupT1MeanTemplate/GroupGrayMatterMeanTemplate_61x73x61_33percent_ConjuctWithGroupMask90Percent.nii';
%GroupAnalysisOutDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/Sub828_Model2_GreyMatterMask';


GroupAnalysisOutDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/Sub828_Model2_WholeBrain';
MeanSTDIQR_Dir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/MeanSTDIQR_WholeBrain';


DataDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures_TransformedWholeBrain';


DataDir_QuantileNormalized = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures_TransformedWholeBrain/Sub828_QuantileNormalized';


ConditionSuffix='';

ConditionList_ALFFfALFFSCA={'FunImgARC','FunImgARglobalC','FunImgARgraymatterC'};

ConditionList_ReHo={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_DC={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_VMHC={'FunImgARCWSsym','FunImgARglobalCWSsym','FunImgARgraymatterCWSsym'};

MeasureDirSet = {'ALFF_Detrend_BAND_01_1','fALFF_Detrend_BAND_01_1','ReHo_Detrend_Filter01_1','VMHC_NormalizeSmoothed4point5First_SYM_Detrend_Filter01_1','AndrewsHannaROI_zFCMap_ROIInMNI_FCInOriginalSpace_Detrend_Filter01_1','DegreeCentrality_Detrend_Filter01_1'};

MeasureSet = {'ALFF','fALFF','ReHo','VMHC','PCCFC','DC'};

%TransformSet = {'0_Raw_','1_MeanDivide_','2_MeanSubtract_','3_MedianDivide_','4_MedianSubtract_','5_z_','6_IQR_'};

TransformSet = {'0_Raw_'};


parfor iMeasure=1:length(MeasureDirSet)
    
    if strcmpi(MeasureSet{iMeasure},'ALFF') || strcmpi(MeasureSet{iMeasure},'fALFF') || strcmpi(MeasureSet{iMeasure},'PCCFC')
        ConditionList = ConditionList_ALFFfALFFSCA;
    elseif strcmpi(MeasureSet{iMeasure},'ReHo')
        ConditionList = ConditionList_ReHo;
    elseif strcmpi(MeasureSet{iMeasure},'DC')
        ConditionList = ConditionList_DC;
    elseif strcmpi(MeasureSet{iMeasure},'VMHC')
        ConditionList = ConditionList_VMHC;
    end
    
    for iCondition=1:length(ConditionList)

        for iTransform=1:length(TransformSet)
             
            %%%%%%%
            
            %Test if all the subjects exist
            FileNameSet=[];
            for i=1:length(SubID)
                
                FileName = [DataDir,filesep,SiteName_AllSites{i},filesep,'ResultsWS',filesep,MeasureDirSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},SubID{i},'.nii'];
                
                if ~exist(FileName,'file')
                    disp(SubID{i})
                else
                    FileNameSet{i,1}=FileName;
                end
            end

            
            [AllVolume,vsize,theImgFileList, Header,nVolumn] =rest_to4d(FileNameSet);
            
            [nDim1 nDim2 nDim3 nDimTimePoints]=size(AllVolume);
            
            
            %Set Mask
            if ~isempty(BrainMaskFile)
                [MaskData,MaskVox,MaskHead]=rest_readfile(BrainMaskFile);
            else
                MaskData=ones(nDim1,nDim2,nDim3);
            end
            
            
            % Convert into 2D. NOTE: here the first dimension is voxels,
            % and the second dimension is subjects. This is different from
            % the way used in y_bandpass.
            %AllVolume=reshape(AllVolume,[],nDimTimePoints)';
            AllVolume=reshape(AllVolume,[],nDimTimePoints);
            
            MaskDataOneDim=reshape(MaskData,[],1);
            MaskIndex = find(MaskDataOneDim);
            nVoxels = length(MaskIndex);
            %AllVolume=AllVolume(:,MaskIndex);
            AllVolume=AllVolume(MaskIndex,:);
            
            AllVolumeBAK = AllVolume;
            
            
%             mkdir(['/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/MeanSTDIQR/MeanSTDIQR_WholeBrain',filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix]);
%             OutputName=['/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/MeanSTDIQR/MeanSTDIQR_WholeBrain',filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,MeasureSet{iMeasure}];
% 
            Mean_AllSub = mean(AllVolume)';
            Std_AllSub = std(AllVolume)';
            Prctile_25_75 = prctile(AllVolume,[25 50 75]);
            
            Median_AllSub = Prctile_25_75(2,:)';
            IQR_AllSub = (Prctile_25_75(3,:) - Prctile_25_75(1,:))';

            
            Mat = [];
            Mat.Mean_AllSub = Mean_AllSub;
            Mat.Std_AllSub = Std_AllSub;
            
%             
%             save([OutputName,'_MeanSTDIQR.mat'],'Mean_AllSub','Std_AllSub','Prctile_25_75','Median_AllSub','IQR_AllSub');

            
            
            Cov = Mat.Mean_AllSub;
            
            
            %Mean centering
            Cov = (Cov - mean(Cov))/std(Cov);

            AllVolumeMean = mean(AllVolume,2);
            AllVolume = (AllVolume-repmat(AllVolumeMean,1,size(AllVolume,2)));

            %AllVolume = (eye(size(Cov,1)) - Cov*inv(Cov'*Cov)*Cov')*AllVolume; %If the time series are columns
            AllVolume = AllVolume*(eye(size(Cov,1)) - Cov*inv(Cov'*Cov)*Cov')';  %If the time series are rows
            %AllVolume = AllVolume + repmat(AllVolumeMean,1,size(AllVolume,2));
           
           
            %%%%%Divide by the STD
            STD_2D = repmat(Mat.Std_AllSub', [size(AllVolume,1), 1]);
            
            AllVolume = AllVolume./STD_2D;
            

            
            %Back construct to 4D
            
            OutputDir_QN = [DataDir_QuantileNormalized,filesep,'ResultsWS',filesep,MeasureDirSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix];
            mkdir(OutputDir_QN);
            
            
            %AllVolumeBrain = single(zeros(nDim1*nDim2*nDim3, nDimTimePoints));
            AllVolumeBrain = (zeros(nDim1*nDim2*nDim3, nDimTimePoints));
            AllVolumeBrain(MaskIndex,:) = AllVolume;
            
            AllVolumeBrain=reshape(AllVolumeBrain,[nDim1, nDim2, nDim3, nDimTimePoints]);

           
            Header_Out = Header;
            Header_Out.pinfo = [1;0;0];
            Header_Out.dt    =[16,0];
            
            
            y_Write4DNIfTI(AllVolumeBrain,Header_Out,[OutputDir_QN,filesep,'16_MeanRegressionSDDivision_',MeasureSet{iMeasure},'.nii']);
            
            
            %%Regression Analysis with F test of site effects
            OutputStatsName=[GroupAnalysisOutDir,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,'16_MeanRegressionSDDivision_',filesep,MeasureSet{iMeasure}];
            mkdir([GroupAnalysisOutDir,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,'16_MeanRegressionSDDivision_']);
            
            Header_Out.dim = Header_Out.dim(1:3);
            y_GroupAnalysis_Image(AllVolumeBrain,AllCov,OutputStatsName,BrainMaskFile,SiteEffectContrast,'F',0,Header_Out);
                

        end
    end
end







%%%GRF correction
%%%%%
%Corrected to Z>2.3, P<0.05 One tailed.

VoxelPThreshold = 0.0214;
IsTwoTailed = 1;
ClusterPThreshold = 0.1;



BrainMaskFile = ['/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures/GroupMask/GroupMask90Percent.nii'];

GroupAnalysisOutDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/Sub828_Model2_WholeBrain';
GroupAnalysisOutDir_GRFCorrected = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/Sub828_Model2_WholeBrain_GRFCorrected';




%BrainMaskFile = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllData/SymmetricGroupT1MeanTemplate/GroupGrayMatterMeanTemplate_61x73x61_33percent_ConjuctWithGroupMask90Percent.nii';
%GroupAnalysisOutDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/Sub828_Model2_GreyMatterMask';
%GroupAnalysisOutDir_GRFCorrected = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/Sub828_Model2_GreyMatterMask_GRFCorrected';



ConditionSuffix='';

ConditionList_ALFFfALFFSCA={'FunImgARC','FunImgARglobalC','FunImgARgraymatterC'};

ConditionList_ReHo={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_DC={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_VMHC={'FunImgARCWSsym','FunImgARglobalCWSsym','FunImgARgraymatterCWSsym'};

MeasureDirSet = {'ALFF_Detrend_BAND_01_1','fALFF_Detrend_BAND_01_1','ReHo_Detrend_Filter01_1','VMHC_NormalizeSmoothed4point5First_SYM_Detrend_Filter01_1','AndrewsHannaROI_zFCMap_ROIInMNI_FCInOriginalSpace_Detrend_Filter01_1','DegreeCentrality_Detrend_Filter01_1'};

MeasureSet = {'ALFF','fALFF','ReHo','VMHC','PCCFC','DC'};

TransformSet = {'16_MeanRegressionSDDivision_'};



parfor iMeasure=1:length(MeasureSet)
    
    if strcmpi(MeasureSet{iMeasure},'ALFF') || strcmpi(MeasureSet{iMeasure},'fALFF') || strcmpi(MeasureSet{iMeasure},'PCCFC')
        ConditionList = ConditionList_ALFFfALFFSCA;
    elseif strcmpi(MeasureSet{iMeasure},'ReHo')
        ConditionList = ConditionList_ReHo;
    elseif strcmpi(MeasureSet{iMeasure},'DC')
        ConditionList = ConditionList_DC;
    elseif strcmpi(MeasureSet{iMeasure},'VMHC')
        ConditionList = ConditionList_VMHC;
    end
    
    for iCondition=1:length(ConditionList)

        for iTransform=1:length(TransformSet)
             
            %%%%%%%
            
            mkdir([GroupAnalysisOutDir_GRFCorrected,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform}]);
            
            
            DirImg = dir([GroupAnalysisOutDir,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,MeasureSet{iMeasure},'*T1.nii']);
            InputName = [GroupAnalysisOutDir,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name];
            OutputName = [GroupAnalysisOutDir_GRFCorrected,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name];
            rest_GRF_Threshold(InputName,VoxelPThreshold,IsTwoTailed,ClusterPThreshold,OutputName,BrainMaskFile);
            
            DirImg = dir([GroupAnalysisOutDir,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,MeasureSet{iMeasure},'*T2.nii']);
            InputName = [GroupAnalysisOutDir,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name];
            OutputName = [GroupAnalysisOutDir_GRFCorrected,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name];
            rest_GRF_Threshold(InputName,VoxelPThreshold,IsTwoTailed,ClusterPThreshold,OutputName,BrainMaskFile);
            
            DirImg = dir([GroupAnalysisOutDir,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,MeasureSet{iMeasure},'*T3.nii']);
            InputName = [GroupAnalysisOutDir,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name];
            OutputName = [GroupAnalysisOutDir_GRFCorrected,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name];
            rest_GRF_Threshold(InputName,VoxelPThreshold,IsTwoTailed,ClusterPThreshold,OutputName,BrainMaskFile);
            
            DirImg = dir([GroupAnalysisOutDir,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,MeasureSet{iMeasure},'*T4.nii']);
            InputName = [GroupAnalysisOutDir,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name];
            OutputName = [GroupAnalysisOutDir_GRFCorrected,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name];
            rest_GRF_Threshold(InputName,VoxelPThreshold,IsTwoTailed,ClusterPThreshold,OutputName,BrainMaskFile);
            
            DirImg = dir([GroupAnalysisOutDir,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,MeasureSet{iMeasure},'*F_ForContrast.nii']);
            InputName = [GroupAnalysisOutDir,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name];
            OutputName = [GroupAnalysisOutDir_GRFCorrected,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name];
            rest_GRF_Threshold(InputName,VoxelPThreshold/2,0,ClusterPThreshold/2,OutputName,BrainMaskFile);
            
        end
    end
end










%%%%
%%%Get the Surface maps

Prefix='Z_ClusterThresholded_';

NMin=-2.3;PMin=2.3;
NMax=-6     ;PMax=6;
ClusterSize=0;
SurfaceMapSuffix='_SurfaceMap.jpg';
ConnectivityCriterion=18;
[BrainNetViewerPath, fileN, extn] = fileparts(which('BrainNet.m'));
SurfFileName=[BrainNetViewerPath,filesep,'Data',filesep,'SurfTemplate',filesep,'BrainMesh_ICBM152.nv'];
viewtype='MediumView';
ColorMap=jet(100);



GroupAnalysisOutDir_GRFCorrected = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/Sub828_Model2_WholeBrain_GRFCorrected';
GroupAnalysisOutDir_SurfaceMap = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/Sub828_Model2_WholeBrain_GRFCorrected/SurfaceMap_Corrected';

%GroupAnalysisOutDir_GRFCorrected = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/Sub828_Model2_GreyMatterMask_GRFCorrected';
%GroupAnalysisOutDir_SurfaceMap = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/Sub828_Model2_GreyMatterMask_GRFCorrected/SurfaceMap_Corrected';


ConditionSuffix='';

ConditionList_ALFFfALFFSCA={'FunImgARC','FunImgARglobalC','FunImgARgraymatterC'};

ConditionList_ReHo={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_DC={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_VMHC={'FunImgARCWSsym','FunImgARglobalCWSsym','FunImgARgraymatterCWSsym'};

MeasureDirSet = {'ALFF_Detrend_BAND_01_1','fALFF_Detrend_BAND_01_1','ReHo_Detrend_Filter01_1','VMHC_NormalizeSmoothed4point5First_SYM_Detrend_Filter01_1','AndrewsHannaROI_zFCMap_ROIInMNI_FCInOriginalSpace_Detrend_Filter01_1','DegreeCentrality_Detrend_Filter01_1'};

MeasureSet = {'ALFF','fALFF','ReHo','VMHC','PCCFC','DC'};

TransformSet = {'16_MeanRegressionSDDivision_'};


for iMeasure=1:length(MeasureSet)
    
    if strcmpi(MeasureSet{iMeasure},'ALFF') || strcmpi(MeasureSet{iMeasure},'fALFF') || strcmpi(MeasureSet{iMeasure},'PCCFC')
        ConditionList = ConditionList_ALFFfALFFSCA;
    elseif strcmpi(MeasureSet{iMeasure},'ReHo')
        ConditionList = ConditionList_ReHo;
    elseif strcmpi(MeasureSet{iMeasure},'DC')
        ConditionList = ConditionList_DC;
    elseif strcmpi(MeasureSet{iMeasure},'VMHC')
        ConditionList = ConditionList_VMHC;
    end
    
    for iCondition=1:length(ConditionList)

        for iTransform=1:length(TransformSet)
             
            %%%%%%%
            
            mkdir([GroupAnalysisOutDir_SurfaceMap,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform}]);
            
            NMax=-15     ;PMax=15;
            DirImg = dir([GroupAnalysisOutDir_GRFCorrected,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,Prefix,'*T1.nii']);
            InputName = [GroupAnalysisOutDir_GRFCorrected,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name];
            OutputName = [GroupAnalysisOutDir_SurfaceMap,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name(1:end-4),SurfaceMapSuffix];
            H_BrainNet = rest_CallBrainNetViewer(InputName,NMin,PMin,ClusterSize,ConnectivityCriterion,SurfFileName,viewtype,ColorMap,NMax,PMax);
            eval(['print -r300 -djpeg -noui ''',OutputName,''';']);
            
            NMax=-6     ;PMax=6;
            DirImg = dir([GroupAnalysisOutDir_GRFCorrected,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,Prefix,'*T2.nii']);
            InputName = [GroupAnalysisOutDir_GRFCorrected,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name];
            OutputName = [GroupAnalysisOutDir_SurfaceMap,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name(1:end-4),SurfaceMapSuffix];
            H_BrainNet = rest_CallBrainNetViewer(InputName,NMin,PMin,ClusterSize,ConnectivityCriterion,SurfFileName,viewtype,ColorMap,NMax,PMax);
            eval(['print -r300 -djpeg -noui ''',OutputName,''';']);
            
            NMax=-6     ;PMax=6;
            DirImg = dir([GroupAnalysisOutDir_GRFCorrected,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,Prefix,'*T3.nii']);
            InputName = [GroupAnalysisOutDir_GRFCorrected,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name];
            OutputName = [GroupAnalysisOutDir_SurfaceMap,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name(1:end-4),SurfaceMapSuffix];
            H_BrainNet = rest_CallBrainNetViewer(InputName,NMin,PMin,ClusterSize,ConnectivityCriterion,SurfFileName,viewtype,ColorMap,NMax,PMax);
            eval(['print -r300 -djpeg -noui ''',OutputName,''';']);
            
            NMax=-6     ;PMax=6;
            DirImg = dir([GroupAnalysisOutDir_GRFCorrected,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,Prefix,'*T4.nii']);
            InputName = [GroupAnalysisOutDir_GRFCorrected,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name];
            OutputName = [GroupAnalysisOutDir_SurfaceMap,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name(1:end-4),SurfaceMapSuffix];
            H_BrainNet = rest_CallBrainNetViewer(InputName,NMin,PMin,ClusterSize,ConnectivityCriterion,SurfFileName,viewtype,ColorMap,NMax,PMax);
            eval(['print -r300 -djpeg -noui ''',OutputName,''';']);
            
            NMax=-10     ;PMax=10;
            DirImg = dir([GroupAnalysisOutDir_GRFCorrected,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,Prefix,'*F_ForContrast.nii']);
            InputName = [GroupAnalysisOutDir_GRFCorrected,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name];
            OutputName = [GroupAnalysisOutDir_SurfaceMap,filesep,MeasureSet{iMeasure},filesep,ConditionList{iCondition},ConditionSuffix,filesep,TransformSet{iTransform},filesep,DirImg(1).name(1:end-4),SurfaceMapSuffix];
            H_BrainNet = rest_CallBrainNetViewer(InputName,NMin,PMin,ClusterSize,ConnectivityCriterion,SurfFileName,viewtype,ColorMap,NMax,PMax);
            eval(['print -r300 -djpeg -noui ''',OutputName,''';']);
            
        end
    end
end








%%%
%Violin plots for Site effects
BrainMaskFile = ['/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures/GroupMask/GroupMask90Percent.nii'];
%BrainMaskFile = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllData/SymmetricGroupT1MeanTemplate/GroupGrayMatterMeanTemplate_61x73x61_33percent_ConjuctWithGroupMask90Percent.nii';

GroupAnalysisViolinFigOutDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/Revision/ViolinFig_SiteEffects';

GroupAnalysisOutDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/Sub828_Model2_WholeBrain';

DataDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures_TransformedWholeBrain';
%DataDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures_TransformedGreyMatterMask';

ConditionSuffix='';

ConditionList_ALFFfALFFSCA={'FunImgARC','FunImgARglobalC','FunImgARgraymatterC'};

ConditionList_ReHo={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_DC={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_VMHC={'FunImgARCWSsym','FunImgARglobalCWSsym','FunImgARgraymatterCWSsym'};

MeasureDirSet = {'ALFF_Detrend_BAND_01_1','fALFF_Detrend_BAND_01_1','ReHo_Detrend_Filter01_1','VMHC_NormalizeSmoothed4point5First_SYM_Detrend_Filter01_1','AndrewsHannaROI_zFCMap_ROIInMNI_FCInOriginalSpace_Detrend_Filter01_1','DegreeCentrality_Detrend_Filter01_1'};

MeasureSet = {'ALFF','fALFF','ReHo','VMHC','PCCFC','DC'};


%TransformSet = {'0_Raw_','GSR_Raw','1_MeanDivide_','2_MeanSubtract_','5_z_','6_IQR_','9_GFN_','8_Rank_','10_GlobalCov_','7_QN_'};

%TransformSet = {'0_Raw_','GSR_Raw','2_MeanSubtract_','13_GlobalCovNoMean_','1_MeanDivide_','15_STDLogAbsCov_','14_GlobalMeanSTDLogAbsCov_','5_z_','6_IQR_','9_GFN_','8_Rank_','7_QN_'};

TransformSet = {'0_Raw_','GSR_Raw','2_MeanSubtract_','13_GlobalCovNoMean_','1_MeanDivide_','5_z_','16_MeanRegressionSDDivision_','14_GlobalMeanSTDLogAbsCov_'};



[BrainMask]=rest_readfile(BrainMaskFile);
BrainMaskIndex=find(BrainMask);

DataSet=[];
for iMeasure=1:length(MeasureDirSet)
    
    if strcmpi(MeasureSet{iMeasure},'ALFF') || strcmpi(MeasureSet{iMeasure},'fALFF') || strcmpi(MeasureSet{iMeasure},'PCCFC')
        ConditionList = ConditionList_ALFFfALFFSCA;
    elseif strcmpi(MeasureSet{iMeasure},'ReHo')
        ConditionList = ConditionList_ReHo;
    elseif strcmpi(MeasureSet{iMeasure},'DC')
        ConditionList = ConditionList_DC;
    elseif strcmpi(MeasureSet{iMeasure},'VMHC')
        ConditionList = ConditionList_VMHC;
    end
    
    for iCondition=1:1 %length(ConditionList)

        for iTransform=1:length(TransformSet)
             
            %%%%%%%
            
            if strcmpi(TransformSet{iTransform},'GSR_Raw')
                StatsName=[GroupAnalysisOutDir,filesep,MeasureSet{iMeasure},filesep,ConditionList{2},ConditionSuffix,filesep,'0_Raw_',filesep,MeasureSet{iMeasure},'_F_ForContrast.nii'];
            else
                StatsName=[GroupAnalysisOutDir,filesep,MeasureSet{iMeasure},filesep,ConditionList{1},ConditionSuffix,filesep,TransformSet{iTransform},filesep,MeasureSet{iMeasure},'_F_ForContrast.nii'];
            end
                       
            [Data Vox Head]=rest_readfile(StatsName);
            
            DataSet{iTransform}=Data(BrainMaskIndex);
           
        end

    end
    
    
    DataMat=cell2mat(DataSet);
    
    %DataMat=DataMat(:,[1,7,2,8,3,9,4,10,5,11,6,12]);
    
    subplot(length(MeasureDirSet),1,iMeasure)
    
    G=[.2 .8 .2];
    B=[0 168 200]/255;
    ColorSet={G,B,G,B,G,B,G,B,G,B,G,B};
    

    distributionPlot(DataMat,'color',G,'showMM',2); %Green
    %distributionPlot(DataMat,'color',ColorSet,'showMM',2); %Green
    
end

mkdir(GroupAnalysisViolinFigOutDir);
OutName=[GroupAnalysisViolinFigOutDir,filesep,'SiteEffects.fig'];
saveas(gca,OutName,'fig')












%%%%%%%
% Auto Draw on a panel, FOR MOTION!!! Re-structure into ONE ROW!!!

LeftMaskFile = '/home/data/HeadMotion_YCG/YAN_Scripts/HeadMotion/Parts/Left2FigureMask_BrainNetViewerMediumView.jpg';

DataUpDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/Sub828_Model2_WholeBrain_GRFCorrected/SurfaceMap_Corrected';

OutputUpDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/Revision/Sub828_Model2_WholeBrain_GRFCorrected/SurfaceMap_Corrected_Motion';


SurfaceMapSuffix='_SurfaceMap.jpg';


MeasureSet = {'ALFF','fALFF','ReHo','VMHC','PCCFC','DC'};

%TransformSet = {'0_Raw_','1_MeanDivide_','2_MeanSubtract_','3_MedianDivide_','4_MedianSubtract_','5_z_','6_IQR_','7_QN_','8_Rank_'};
%TransformSet = {'0_Raw_','1_MeanDivide_','2_MeanSubtract_','5_z_','6_IQR_','7_QN_','8_Rank_','9_GFN_'};
%TransformSet = {'0_Raw_','GSR_Raw','1_MeanDivide_','2_MeanSubtract_','5_z_','6_IQR_','7_QN_','8_Rank_','9_GFN_'};
%TransformSet = {'0_Raw_','GSR_Raw','1_MeanDivide_','2_MeanSubtract_','10_GlobalCov_','5_z_','6_IQR_','9_GFN_','8_Rank_','7_QN_'};

%TransformSet = {'0_Raw_','GSR_Raw','2_MeanSubtract_','10_GlobalCov_','1_MeanDivide_','12_STDLogCov_','11_GlobalMeanSTDLogCov_','5_z_','6_IQR_','9_GFN_','8_Rank_','7_QN_'};

%TransformSet = {'0_Raw_','GSR_Raw','2_MeanSubtract_','13_GlobalCovNoMean_','1_MeanDivide_','15_STDLogAbsCov_','14_GlobalMeanSTDLogAbsCov_','5_z_','6_IQR_','9_GFN_','8_Rank_','7_QN_'};

TransformSet = {'0_Raw_','GSR_Raw','2_MeanSubtract_','13_GlobalCovNoMean_','1_MeanDivide_','5_z_','14_GlobalMeanSTDLogAbsCov_'};

TransformSet = {'0_Raw_','GSR_Raw','2_MeanSubtract_','13_GlobalCovNoMean_','1_MeanDivide_','5_z_','16_MeanRegressionSDDivision_','14_GlobalMeanSTDLogAbsCov_'};

ContrastSet = {'T4'};
%ContrastSet = {'T1','F_ForContrast','T4','T2','T3'};

ConditionSuffix='';

ConditionList_ALFFfALFFSCA={'FunImgARC','FunImgARglobalC','FunImgARgraymatterC'};

ConditionList_ReHo={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_DC={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_VMHC={'FunImgARCWSsym','FunImgARglobalCWSsym','FunImgARgraymatterCWSsym'};

UnitRow = 1044;
UnitColumn = 1531;
BackGroundColor = uint8([255*ones(1,1,3)]);
%imdata_All = 255*ones(UnitRow*length(MeasureSet),UnitColumn*length(ConditionList),3);
imdata_All = repmat(BackGroundColor,[UnitRow*length(TransformSet),UnitColumn*length(MeasureSet)*2,1]);
LeftMask = imread(LeftMaskFile);

mkdir([OutputUpDir]);

for iMeasure=1:length(MeasureSet)
    
    if strcmpi(MeasureSet{iMeasure},'ALFF') || strcmpi(MeasureSet{iMeasure},'fALFF') || strcmpi(MeasureSet{iMeasure},'PCCFC')
        ConditionList = ConditionList_ALFFfALFFSCA;
    elseif strcmpi(MeasureSet{iMeasure},'ReHo')
        ConditionList = ConditionList_ReHo;
    elseif strcmpi(MeasureSet{iMeasure},'DC')
        ConditionList = ConditionList_DC;
    elseif strcmpi(MeasureSet{iMeasure},'VMHC')
        ConditionList = ConditionList_VMHC;
    end
    
    
    
    for iTransform=1:length(TransformSet)
        
        if strcmpi(TransformSet{iTransform},'GSR_Raw')
            cd([DataUpDir,filesep,MeasureSet{iMeasure},filesep,ConditionList{2},ConditionSuffix,filesep,'0_Raw_']);
        else
            cd([DataUpDir,filesep,MeasureSet{iMeasure},filesep,ConditionList{1},ConditionSuffix,filesep,TransformSet{iTransform}]);
        end
        
        
        for iContrast=1:length(ContrastSet)
            DirJPG = dir(['*',ContrastSet{iContrast},SurfaceMapSuffix]);
            if ~isempty(DirJPG)
                imdata = imread(DirJPG(end).name); 
                imdata(LeftMask==255) = 255;
                imdata = imdata(1:end-80,120:1650,:);
                imdata_All (((iTransform-1)*UnitRow + 1):iTransform*UnitRow,((iMeasure-1)*2*UnitColumn + 1):(iMeasure*2-1)*UnitColumn,:) = imdata(1:UnitRow,1:UnitColumn,:);
                imdata_All (((iTransform-1)*UnitRow + 1 +30):iTransform*UnitRow,((iMeasure*2-1)*UnitColumn + 1)-120:(iMeasure*2)*UnitColumn-120,:) = imdata(UnitRow+1:UnitRow*2-30,1:UnitColumn,:);

            end
        end
        disp(iMeasure)
    end
    
end

figure
image(imdata_All)
axis off          % Remove axis ticks and numbers
axis image        % Set aspect ratio to obtain square pixels

OutJPGName=[OutputUpDir,filesep,MeasureSet{iMeasure},'All.jpg'];
eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);










%%%%%
%FC with the whole brain mean


BrainMaskFile = ['/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures/GroupMask/GroupMask90Percent.nii'];

GroupAnalysisOutDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/CorrelationWithWholeBrainMean';

DataDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures_TransformedWholeBrain';

DataDir_QuantileNormalized = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures_TransformedWholeBrain/Sub828_QuantileNormalized';

MeanSTDIQR_Dir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/MeanSTDIQR_WholeBrain';




% BrainMaskFile = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllData/SymmetricGroupT1MeanTemplate/GroupGrayMatterMeanTemplate_61x73x61_33percent_ConjuctWithGroupMask90Percent.nii';
% GroupAnalysisOutDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/KendallW_GSR_ZStand_GreyMatterMask';
% DataDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures_TransformedGreyMatterMask';



TransformSet = {'0_Raw_','GSR_Raw','2_MeanSubtract_','10_GlobalCov_','1_MeanDivide_','12_STDLogCov_','11_GlobalMeanSTDLogCov_','5_z_','6_IQR_','9_GFN_','8_Rank_','7_QN_','13_GlobalCovNoMean_','14_GlobalMeanSTDLogAbsCov_','15_STDLogAbsCov_'};

TransformSet = {'16_MeanRegressionSDDivision_'};

ConditionSuffix='';

ConditionList_ALFFfALFFSCA={'FunImgARC','FunImgARglobalC','FunImgARgraymatterC'};

ConditionList_ReHo={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_DC={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_VMHC={'FunImgARCWSsym','FunImgARglobalCWSsym','FunImgARgraymatterCWSsym'};


MeasureDirSet = {'ALFF_Detrend_BAND_01_1','fALFF_Detrend_BAND_01_1','ReHo_Detrend_Filter01_1','VMHC_NormalizeSmoothed4point5First_SYM_Detrend_Filter01_1','AndrewsHannaROI_zFCMap_ROIInMNI_FCInOriginalSpace_Detrend_Filter01_1','DegreeCentrality_Detrend_Filter01_1'};

MeasureSet = {'ALFF','fALFF','ReHo','VMHC','PCCFC','DC'};


for iMeasure=1:length(MeasureDirSet)
    
    if strcmpi(MeasureSet{iMeasure},'ALFF') || strcmpi(MeasureSet{iMeasure},'fALFF') || strcmpi(MeasureSet{iMeasure},'PCCFC')
        ConditionList = ConditionList_ALFFfALFFSCA;
    elseif strcmpi(MeasureSet{iMeasure},'ReHo')
        ConditionList = ConditionList_ReHo;
    elseif strcmpi(MeasureSet{iMeasure},'DC')
        ConditionList = ConditionList_DC;
    elseif strcmpi(MeasureSet{iMeasure},'VMHC')
        ConditionList = ConditionList_VMHC;
    end
    
    

    Raters = [];
    for iTransform=1:length(TransformSet)
        
        if strcmpi(TransformSet{iTransform},'GSR_Raw')
            
            
            FileNameSet=[];
            for i=1:length(SubID)
                FileName = [DataDir,filesep,SiteName_AllSites{i},filesep,'ResultsWS',filesep,MeasureDirSet{iMeasure},filesep,ConditionList{2},ConditionSuffix,filesep,'0_Raw_',SubID{i},'.nii'];
                FileNameSet{i,1}=FileName;
            end
            
            
        elseif strcmpi(TransformSet{iTransform},'10_GlobalCov_') || strcmpi(TransformSet{iTransform},'12_STDLogCov_') || strcmpi(TransformSet{iTransform},'11_GlobalMeanSTDLogCov_') || strcmpi(TransformSet{iTransform},'8_Rank_') || strcmpi(TransformSet{iTransform},'7_QN_') || strcmpi(TransformSet{iTransform},'13_GlobalCovNoMean_') || strcmpi(TransformSet{iTransform},'14_GlobalMeanSTDLogAbsCov_') || strcmpi(TransformSet{iTransform},'15_STDLogAbsCov_') || strcmpi(TransformSet{iTransform},'16_MeanRegressionSDDivision_')  

            OutputDir_QN = [DataDir_QuantileNormalized,filesep,'ResultsWS',filesep,MeasureDirSet{iMeasure},filesep,ConditionList{1},ConditionSuffix];
            
            FileNameSet = [OutputDir_QN,filesep,TransformSet{iTransform},MeasureSet{iMeasure},'.nii'];
            
        else
            FileNameSet=[];
            for i=1:length(SubID)
                
                FileName = [DataDir,filesep,SiteName_AllSites{i},filesep,'ResultsWS',filesep,MeasureDirSet{iMeasure},filesep,ConditionList{1},ConditionSuffix,filesep,TransformSet{iTransform},SubID{i},'.nii'];
                FileNameSet{i,1}=FileName;
            end

        end
        
        Raters{iTransform,1} = FileNameSet;
        
        
        Mean_AllSub_MatFile=[MeanSTDIQR_Dir,filesep,MeasureSet{iMeasure},filesep,ConditionList{1},ConditionSuffix,filesep,MeasureSet{iMeasure},'_MeanSTDIQR.mat'];
        Mat = load(Mean_AllSub_MatFile);
        ROIDef = {Mat.Mean_AllSub};
        
        mkdir([GroupAnalysisOutDir,filesep,MeasureSet{iMeasure}]);
        OutputName=[GroupAnalysisOutDir,filesep,MeasureSet{iMeasure},filesep,TransformSet{iTransform}];
        
        y_SCA(FileNameSet, ROIDef, OutputName, BrainMaskFile);
        

    end
    
end









%%%%%
%FC with the whole brain STD


BrainMaskFile = ['/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures/GroupMask/GroupMask90Percent.nii'];

GroupAnalysisOutDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/CorrelationWithWholeBrainSTD';

DataDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures_TransformedWholeBrain';

DataDir_QuantileNormalized = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures_TransformedWholeBrain/Sub828_QuantileNormalized';

MeanSTDIQR_Dir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/MeanSTDIQR_WholeBrain';




% BrainMaskFile = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllData/SymmetricGroupT1MeanTemplate/GroupGrayMatterMeanTemplate_61x73x61_33percent_ConjuctWithGroupMask90Percent.nii';
% GroupAnalysisOutDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/KendallW_GSR_ZStand_GreyMatterMask';
% DataDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures_TransformedGreyMatterMask';



%TransformSet = {'0_Raw_','GSR_Raw','2_MeanSubtract_','10_GlobalCov_','1_MeanDivide_','12_STDLogCov_','11_GlobalMeanSTDLogCov_','5_z_','6_IQR_','9_GFN_','8_Rank_','7_QN_','13_GlobalCovNoMean_','14_GlobalMeanSTDLogAbsCov_','15_STDLogAbsCov_'};

TransformSet = {'0_Raw_','GSR_Raw','2_MeanSubtract_','1_MeanDivide_','5_z_','13_GlobalCovNoMean_','14_GlobalMeanSTDLogAbsCov_','15_STDLogAbsCov_'};

TransformSet = {'16_MeanRegressionSDDivision_'};

ConditionSuffix='';

ConditionList_ALFFfALFFSCA={'FunImgARC','FunImgARglobalC','FunImgARgraymatterC'};

ConditionList_ReHo={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_DC={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_VMHC={'FunImgARCWSsym','FunImgARglobalCWSsym','FunImgARgraymatterCWSsym'};


MeasureDirSet = {'ALFF_Detrend_BAND_01_1','fALFF_Detrend_BAND_01_1','ReHo_Detrend_Filter01_1','VMHC_NormalizeSmoothed4point5First_SYM_Detrend_Filter01_1','AndrewsHannaROI_zFCMap_ROIInMNI_FCInOriginalSpace_Detrend_Filter01_1','DegreeCentrality_Detrend_Filter01_1'};

MeasureSet = {'ALFF','fALFF','ReHo','VMHC','PCCFC','DC'};


for iMeasure=1:length(MeasureDirSet)
    
    if strcmpi(MeasureSet{iMeasure},'ALFF') || strcmpi(MeasureSet{iMeasure},'fALFF') || strcmpi(MeasureSet{iMeasure},'PCCFC')
        ConditionList = ConditionList_ALFFfALFFSCA;
    elseif strcmpi(MeasureSet{iMeasure},'ReHo')
        ConditionList = ConditionList_ReHo;
    elseif strcmpi(MeasureSet{iMeasure},'DC')
        ConditionList = ConditionList_DC;
    elseif strcmpi(MeasureSet{iMeasure},'VMHC')
        ConditionList = ConditionList_VMHC;
    end
    

    for iTransform=1:length(TransformSet)
        
        if strcmpi(TransformSet{iTransform},'GSR_Raw')
            
            
            FileNameSet=[];
            for i=1:length(SubID)
                FileName = [DataDir,filesep,SiteName_AllSites{i},filesep,'ResultsWS',filesep,MeasureDirSet{iMeasure},filesep,ConditionList{2},ConditionSuffix,filesep,'0_Raw_',SubID{i},'.nii'];
                FileNameSet{i,1}=FileName;
            end
            
            
        elseif strcmpi(TransformSet{iTransform},'10_GlobalCov_') || strcmpi(TransformSet{iTransform},'12_STDLogCov_') || strcmpi(TransformSet{iTransform},'11_GlobalMeanSTDLogCov_') || strcmpi(TransformSet{iTransform},'8_Rank_') || strcmpi(TransformSet{iTransform},'7_QN_') || strcmpi(TransformSet{iTransform},'13_GlobalCovNoMean_') || strcmpi(TransformSet{iTransform},'14_GlobalMeanSTDLogAbsCov_') || strcmpi(TransformSet{iTransform},'15_STDLogAbsCov_') || strcmpi(TransformSet{iTransform},'16_MeanRegressionSDDivision_') 

            OutputDir_QN = [DataDir_QuantileNormalized,filesep,'ResultsWS',filesep,MeasureDirSet{iMeasure},filesep,ConditionList{1},ConditionSuffix];
            
            FileNameSet = [OutputDir_QN,filesep,TransformSet{iTransform},MeasureSet{iMeasure},'.nii'];
            
        else
            FileNameSet=[];
            for i=1:length(SubID)
                
                FileName = [DataDir,filesep,SiteName_AllSites{i},filesep,'ResultsWS',filesep,MeasureDirSet{iMeasure},filesep,ConditionList{1},ConditionSuffix,filesep,TransformSet{iTransform},SubID{i},'.nii'];
                FileNameSet{i,1}=FileName;
            end

        end
        
        Mean_AllSub_MatFile=[MeanSTDIQR_Dir,filesep,MeasureSet{iMeasure},filesep,ConditionList{1},ConditionSuffix,filesep,MeasureSet{iMeasure},'_MeanSTDIQR.mat'];
        Mat = load(Mean_AllSub_MatFile);
        ROIDef = {Mat.Std_AllSub};
        
        mkdir([GroupAnalysisOutDir,filesep,MeasureSet{iMeasure}]);
        OutputName=[GroupAnalysisOutDir,filesep,MeasureSet{iMeasure},filesep,TransformSet{iTransform}];
        
        y_SCA(FileNameSet, ROIDef, OutputName, BrainMaskFile);
        

    end
    
end











%%%%%
%Correlation PAIRWISE!!!


BrainMaskFile = ['/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures/GroupMask/GroupMask90Percent.nii'];

GroupAnalysisOutDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/Correlation_PairWise';

DataDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures_TransformedWholeBrain';

DataDir_QuantileNormalized = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures_TransformedWholeBrain/Sub828_QuantileNormalized';



% BrainMaskFile = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllData/SymmetricGroupT1MeanTemplate/GroupGrayMatterMeanTemplate_61x73x61_33percent_ConjuctWithGroupMask90Percent.nii';
% GroupAnalysisOutDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/KendallW_GSR_ZStand_GreyMatterMask';
% DataDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures_TransformedGreyMatterMask';



TransformSet = {'0_Raw_','GSR_Raw','GreySR_Raw','2_MeanSubtract_','13_GlobalCovNoMean_','1_MeanDivide_','15_STDLogAbsCov_','14_GlobalMeanSTDLogAbsCov_','5_z_','6_IQR_','9_GFN_','8_Rank_','7_QN_'};
TransformSet = {'0_Raw_','GSR_Raw','GreySR_Raw','2_MeanSubtract_','13_GlobalCovNoMean_','1_MeanDivide_','15_STDLogAbsCov_','14_GlobalMeanSTDLogAbsCov_','5_z_','6_IQR_','9_GFN_','8_Rank_','7_QN_','16_MeanRegressionSDDivision_'};



ConditionSuffix='';

ConditionList_ALFFfALFFSCA={'FunImgARC','FunImgARglobalC','FunImgARgraymatterC'};

ConditionList_ReHo={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_DC={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_VMHC={'FunImgARCWSsym','FunImgARglobalCWSsym','FunImgARgraymatterCWSsym'};


MeasureDirSet = {'ALFF_Detrend_BAND_01_1','fALFF_Detrend_BAND_01_1','ReHo_Detrend_Filter01_1','VMHC_NormalizeSmoothed4point5First_SYM_Detrend_Filter01_1','AndrewsHannaROI_zFCMap_ROIInMNI_FCInOriginalSpace_Detrend_Filter01_1','DegreeCentrality_Detrend_Filter01_1'};

MeasureSet = {'ALFF','fALFF','ReHo','VMHC','PCCFC','DC'};


for iMeasure=1:length(MeasureDirSet)
    
    if strcmpi(MeasureSet{iMeasure},'ALFF') || strcmpi(MeasureSet{iMeasure},'fALFF') || strcmpi(MeasureSet{iMeasure},'PCCFC')
        ConditionList = ConditionList_ALFFfALFFSCA;
    elseif strcmpi(MeasureSet{iMeasure},'ReHo')
        ConditionList = ConditionList_ReHo;
    elseif strcmpi(MeasureSet{iMeasure},'DC')
        ConditionList = ConditionList_DC;
    elseif strcmpi(MeasureSet{iMeasure},'VMHC')
        ConditionList = ConditionList_VMHC;
    end
    
    
    mkdir([GroupAnalysisOutDir,filesep,MeasureSet{iMeasure}]);
    
    
    
    
    for iTransform=1:length(TransformSet)
        
        if strcmpi(TransformSet{iTransform},'GSR_Raw')
            
            
            FileNameSet=[];
            for i=1:length(SubID)
                FileName = [DataDir,filesep,SiteName_AllSites{i},filesep,'ResultsWS',filesep,MeasureDirSet{iMeasure},filesep,ConditionList{2},ConditionSuffix,filesep,'0_Raw_',SubID{i},'.nii'];
                FileNameSet{i,1}=FileName;
            end
            
        elseif strcmpi(TransformSet{iTransform},'GreySR_Raw')
            
            
            FileNameSet=[];
            for i=1:length(SubID)
                FileName = [DataDir,filesep,SiteName_AllSites{i},filesep,'ResultsWS',filesep,MeasureDirSet{iMeasure},filesep,ConditionList{3},ConditionSuffix,filesep,'0_Raw_',SubID{i},'.nii'];
                FileNameSet{i,1}=FileName;
            end
            
            
        elseif strcmpi(TransformSet{iTransform},'10_GlobalCov_') || strcmpi(TransformSet{iTransform},'12_STDLogCov_') || strcmpi(TransformSet{iTransform},'11_GlobalMeanSTDLogCov_') || strcmpi(TransformSet{iTransform},'8_Rank_') || strcmpi(TransformSet{iTransform},'7_QN_') || strcmpi(TransformSet{iTransform},'13_GlobalCovNoMean_') || strcmpi(TransformSet{iTransform},'14_GlobalMeanSTDLogAbsCov_') || strcmpi(TransformSet{iTransform},'15_STDLogAbsCov_') || strcmpi(TransformSet{iTransform},'16_MeanRegressionSDDivision_')             
            OutputDir_QN = [DataDir_QuantileNormalized,filesep,'ResultsWS',filesep,MeasureDirSet{iMeasure},filesep,ConditionList{1},ConditionSuffix];
            
            FileNameSet = [OutputDir_QN,filesep,TransformSet{iTransform},MeasureSet{iMeasure},'.nii'];
            
        else
            FileNameSet=[];
            for i=1:length(SubID)
                
                FileName = [DataDir,filesep,SiteName_AllSites{i},filesep,'ResultsWS',filesep,MeasureDirSet{iMeasure},filesep,ConditionList{1},ConditionSuffix,filesep,TransformSet{iTransform},SubID{i},'.nii'];
                FileNameSet{i,1}=FileName;
            end
            
        end

        [AllVolume1,VoxelSize,theImgFileList, Header] =rest_to4d(FileNameSet);
        
        for iTransform2=length(TransformSet):length(TransformSet)
            
            if strcmpi(TransformSet{iTransform2},'GSR_Raw')
                
                
                FileNameSet=[];
                for i=1:length(SubID)
                    FileName = [DataDir,filesep,SiteName_AllSites{i},filesep,'ResultsWS',filesep,MeasureDirSet{iMeasure},filesep,ConditionList{2},ConditionSuffix,filesep,'0_Raw_',SubID{i},'.nii'];
                    FileNameSet{i,1}=FileName;
                end
                
            elseif strcmpi(TransformSet{iTransform2},'GreySR_Raw')
                
                
                FileNameSet=[];
                for i=1:length(SubID)
                    FileName = [DataDir,filesep,SiteName_AllSites{i},filesep,'ResultsWS',filesep,MeasureDirSet{iMeasure},filesep,ConditionList{3},ConditionSuffix,filesep,'0_Raw_',SubID{i},'.nii'];
                    FileNameSet{i,1}=FileName;
                end
                
                          
            elseif strcmpi(TransformSet{iTransform2},'10_GlobalCov_') || strcmpi(TransformSet{iTransform2},'12_STDLogCov_') || strcmpi(TransformSet{iTransform2},'11_GlobalMeanSTDLogCov_') || strcmpi(TransformSet{iTransform2},'8_Rank_') || strcmpi(TransformSet{iTransform2},'7_QN_') || strcmpi(TransformSet{iTransform2},'13_GlobalCovNoMean_') || strcmpi(TransformSet{iTransform2},'14_GlobalMeanSTDLogAbsCov_') || strcmpi(TransformSet{iTransform2},'15_STDLogAbsCov_') || strcmpi(TransformSet{iTransform2},'16_MeanRegressionSDDivision_')   
                OutputDir_QN = [DataDir_QuantileNormalized,filesep,'ResultsWS',filesep,MeasureDirSet{iMeasure},filesep,ConditionList{1},ConditionSuffix];
                
                FileNameSet = [OutputDir_QN,filesep,TransformSet{iTransform2},MeasureSet{iMeasure},'.nii'];
                
            else
                FileNameSet=[];
                for i=1:length(SubID)
                    
                    FileName = [DataDir,filesep,SiteName_AllSites{i},filesep,'ResultsWS',filesep,MeasureDirSet{iMeasure},filesep,ConditionList{1},ConditionSuffix,filesep,TransformSet{iTransform2},SubID{i},'.nii'];
                    FileNameSet{i,1}=FileName;
                end
                
            end
            

            OutputName=[GroupAnalysisOutDir,filesep,MeasureSet{iMeasure},filesep,TransformSet{iTransform},TransformSet{iTransform2}];
            
            [AllVolume2,VoxelSize,theImgFileList, Header] =rest_to4d(FileNameSet);
            
            
            
            %Calculate Correlation
            %%SeedVolumeFileSet Used %%
            %DataDirectory = ResidualFileSet;%%
            %OutputName=OutputName; %%
            
            %OutputDir=OutputDir;
            MaskFile=BrainMaskFile;
            
            
            %mkdir(OutputDir);
            %[AllVolume,vsize,theImgFileList, Header,nVolumn] =rest_to4d(DataDirectory);
            AllVolume = AllVolume1;
            [nDim1,nDim2,nDim3,nDimTimePoints]=size(AllVolume);
            if ~isempty(MaskFile)
                [MaskData,MaskVox,MaskHead]=rest_readfile(MaskFile);
            else
                MaskData=ones(nDim1,nDim2,nDim3);
            end
            MaskDataOneDim=reshape(MaskData,1,[]);
            %AllVolume=permute(AllVolume,[4,1,2,3]); % Change the Time Course to the first dimention
            %AllVolume=reshape(AllVolume,nDimTimePoints,[]);
            AllVolume=reshape(AllVolume,[],nDimTimePoints)';
            AllVolume=AllVolume(:,find(MaskDataOneDim));%    ResultVolumeback=zeros(size(MaskData));    ResultVolumeback(1,find(MaskDataOneDim))=Result;    ResultVolumeback=reshape(ResultVolumeback,nDim1, nDim2, nDim3);
            
            %SeedVolume=rest_to4d(SeedVolumeFileSet);
            SeedVolume = AllVolume2;
            %SeedVolume=permute(SeedVolume,[4,1,2,3]); % Change the Time Course to the first dimention
            %SeedVolume=reshape(SeedVolume,nDimTimePoints,[]);
            SeedVolume=reshape(SeedVolume,[],nDimTimePoints)';
            SeedVolume=SeedVolume(:,find(MaskDataOneDim));%    ResultVolumeback=zeros(size(MaskData));    ResultVolumeback(1,find(MaskDataOneDim))=Result;    ResultVolumeback=reshape(ResultVolumeback,nDim1, nDim2, nDim3);
            
%             %%%Regress Out Cov
%             if ~isempty(Cov)
%                 for iVoxel = 1:size(AllVolume,2)
%                     [b,r] = rest_regress_ss(AllVolume(:,iVoxel),Cov);
%                     AllVolume(:,iVoxel) = r;
%                     
%                     [b,r] = rest_regress_ss(SeedVolume(:,iVoxel),Cov);
%                     SeedVolume(:,iVoxel) = r;
%                 end
%             end
            
            AllVolume = AllVolume-repmat(mean(AllVolume),size(AllVolume,1),1);
            AllVolumeSTD= squeeze(std(AllVolume, 0, 1));
            AllVolumeSTD(find(AllVolumeSTD==0))=inf;
            
            SeedVolume = SeedVolume-repmat(mean(SeedVolume),size(SeedVolume,1),1);
            SeedVolumeSTD= squeeze(std(SeedVolume, 0, 1));
            SeedVolumeSTD(find(SeedVolumeSTD==0))=inf;
            
            FC=zeros(size(AllVolume,2),1);
            for ii=1:size(AllVolume,2)
                FCTemp=SeedVolume(:,ii)'*AllVolume(:,ii)/(nDimTimePoints-1);
                FCTemp=(FCTemp./AllVolumeSTD(ii))/SeedVolumeSTD(ii);
                FC(ii)=FCTemp;
            end
            
            FCBrain=zeros(size(MaskDataOneDim));
            FCBrain(1,find(MaskDataOneDim))=FC;
            FCBrain=reshape(FCBrain,nDim1, nDim2, nDim3);
            Header.pinfo = [1;0;0];
            Header.dt    =[16,0];
            rest_WriteNiftiImage(FCBrain,Header,[OutputName,'.nii']);

        end
        
    end

end









%130118
%%%%%
%Box Plot for corrlation with global mean

BrainMaskFile = ['/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures/GroupMask/GroupMask90Percent.nii'];
GrayMatterMaskFile = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllData/SymmetricGroupT1MeanTemplate/GroupGrayMatterMeanTemplate_61x73x61_33percent_ConjuctWithGroupMask90Percent.nii';
WhiteMatterMaskFile = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllData/SymmetricGroupT1MeanTemplate/GroupWhiteMatterMeanTemplate_61x73x61_33percent_ConjuctWithGroupMask90Percent.nii';


DataUpDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/CorrelationWithWholeBrainMean';


TransformSet = {'0_Raw_','GSR_Raw','2_MeanSubtract_','13_GlobalCovNoMean_','1_MeanDivide_','5_z_','16_MeanRegressionSDDivision_','14_GlobalMeanSTDLogAbsCov_'};


MeasureSet = {'ALFF','fALFF','ReHo','VMHC','PCCFC','DC'};

Mask = rest_readfile(BrainMaskFile);
GreyMask = rest_readfile(GrayMatterMaskFile);
WhiteMask = rest_readfile(WhiteMatterMaskFile);

ConditionSuffix='';

ConditionList_ALFFfALFFSCA={'FunImgARC','FunImgARglobalC','FunImgARgraymatterC'};

ConditionList_ReHo={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_DC={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_VMHC={'FunImgARCWSsym','FunImgARglobalCWSsym','FunImgARgraymatterCWSsym'};



for iMeasure=1:length(MeasureSet)
    
    if strcmpi(MeasureSet{iMeasure},'ALFF') || strcmpi(MeasureSet{iMeasure},'fALFF') || strcmpi(MeasureSet{iMeasure},'PCCFC')
        ConditionList = ConditionList_ALFFfALFFSCA;
    elseif strcmpi(MeasureSet{iMeasure},'ReHo')
        ConditionList = ConditionList_ReHo;
    elseif strcmpi(MeasureSet{iMeasure},'DC')
        ConditionList = ConditionList_DC;
    elseif strcmpi(MeasureSet{iMeasure},'VMHC')
        ConditionList = ConditionList_VMHC;
    end
    
    
    for iTransform=1:length(TransformSet)
        
        
        cd([DataUpDir,filesep,MeasureSet{iMeasure}]);
        
        DataFileName = [TransformSet{iTransform},'.nii'];
        

        Data = rest_readfile([DataFileName]);
        
        if strcmpi(MeasureSet{iMeasure},'VMHC')
            Data(31,:,:)=0; %Do not include the middle slice
        end
        
        Data_BrainMask = Data(find(Mask));
        Data_Gray = Data(find(GreyMask));
        Data_White = Data(find(WhiteMask));
        
        Data_GraySet (:,(iMeasure-1)*(length(TransformSet)+1)+iTransform+1) = Data_Gray;
        Data_WhiteSet (:,(iMeasure-1)*(length(TransformSet)+1)+iTransform+1) = Data_White;
        Data_BrainMaskSet (:,(iMeasure-1)*(length(TransformSet)+1)+iTransform+1) = Data_BrainMask;

        
    end
end


figure;
boxplot(Data_GraySet)


Data_GraySet_Column = Data_GraySet(:);

for i=1:size(Data_GraySet,2)
    Group((i-1)*length(find(GreyMask))+1:i*length(find(GreyMask)),1) = i*ones(length(find(GreyMask)),1);
    
    ColorGroup((i-1)*length(find(GreyMask))+1:i*length(find(GreyMask)),1) = mod(i,9)*ones(length(find(GreyMask)),1);
end

%boxplot(Data_GraySet_Column,Group,'colorgroup',ColorGroup)


Colormap = [0.5 0.5 0.5;1 1 1;0 0 1;0 0.8 0.8;0 0.8 0;0.8 0.8 0;1 0 1;1 0 0;0 0 0];
boxplot(Data_GraySet_Column,Group,'colorgroup',ColorGroup,'colors',Colormap)





figure
Data_WhiteSet_Column = Data_WhiteSet(:);

Group=[];
ColorGroup=[];
for i=1:size(Data_WhiteSet,2)
    Group((i-1)*length(find(WhiteMask))+1:i*length(find(WhiteMask)),1) = i*ones(length(find(WhiteMask)),1);
    
    ColorGroup((i-1)*length(find(WhiteMask))+1:i*length(find(WhiteMask)),1) = mod(i,9)*ones(length(find(WhiteMask)),1);
end


%boxplot(Data_WhiteSet_Column,Group,'colorgroup',ColorGroup)


Colormap = [0.5 0.5 0.5;1 1 1;0 0 1;0 0.8 0.8;0 0.8 0;0.8 0.8 0;1 0 1;1 0 0;0 0 0];

boxplot(Data_WhiteSet_Column,Group,'colorgroup',ColorGroup,'colors',Colormap)













%130118
%%%%%
%Box Plot for Age effects

BrainMaskFile = ['/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures/GroupMask/GroupMask90Percent.nii'];
GrayMatterMaskFile = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllData/SymmetricGroupT1MeanTemplate/GroupGrayMatterMeanTemplate_61x73x61_33percent_ConjuctWithGroupMask90Percent.nii';

DataUpDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/Sub828_Model2_WholeBrain_GRFCorrected';


TransformSet = {'0_Raw_','GSR_Raw','2_MeanSubtract_','13_GlobalCovNoMean_','1_MeanDivide_','5_z_','14_GlobalMeanSTDLogAbsCov_'};
TransformSet = {'0_Raw_','GSR_Raw','2_MeanSubtract_','13_GlobalCovNoMean_','1_MeanDivide_','5_z_','16_MeanRegressionSDDivision_','14_GlobalMeanSTDLogAbsCov_'};


MeasureSet = {'ALFF','fALFF','ReHo','VMHC','PCCFC','DC'};

Mask = rest_readfile(BrainMaskFile);
GreyMask = rest_readfile(GrayMatterMaskFile);


ContrastSet = {'T2'};
%ContrastSet = {'T1','F_ForContrast','T4','T2','T3'};

ConditionSuffix='';

ConditionList_ALFFfALFFSCA={'FunImgARC','FunImgARglobalC','FunImgARgraymatterC'};

ConditionList_ReHo={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_DC={'FunImgARCW','FunImgARglobalCW','FunImgARgraymatterCW'};
ConditionList_VMHC={'FunImgARCWSsym','FunImgARglobalCWSsym','FunImgARgraymatterCWSsym'};



for iMeasure=1:length(MeasureSet)
    
    if strcmpi(MeasureSet{iMeasure},'ALFF') || strcmpi(MeasureSet{iMeasure},'fALFF') || strcmpi(MeasureSet{iMeasure},'PCCFC')
        ConditionList = ConditionList_ALFFfALFFSCA;
    elseif strcmpi(MeasureSet{iMeasure},'ReHo')
        ConditionList = ConditionList_ReHo;
    elseif strcmpi(MeasureSet{iMeasure},'DC')
        ConditionList = ConditionList_DC;
    elseif strcmpi(MeasureSet{iMeasure},'VMHC')
        ConditionList = ConditionList_VMHC;
    end
    
    
    for iTransform=1:length(TransformSet)
        
        if strcmpi(TransformSet{iTransform},'GSR_Raw')
            cd([DataUpDir,filesep,MeasureSet{iMeasure},filesep,ConditionList{2},ConditionSuffix,filesep,'0_Raw_']);
        else
            cd([DataUpDir,filesep,MeasureSet{iMeasure},filesep,ConditionList{1},ConditionSuffix,filesep,TransformSet{iTransform}]);
        end
        
        
        DataFileName = ['Z_BeforeThreshold_',MeasureSet{iMeasure},'_',ContrastSet{1},'.nii'];
        
        if iTransform==1 %Only the difference from Raw
            Data = rest_readfile([DataFileName]);
            DataRaw = Data;
            
        else
            Data = rest_readfile([DataFileName]);
            Data = Data - DataRaw;
            

            if strcmpi(MeasureSet{iMeasure},'VMHC')
                
                Data(31,:,:)=0; %Do not include the middle slice
                
            end
            
            Data_BrainMask = Data(find(Mask));
            Data_Gray = Data(find(GreyMask));    
            
            Data_GraySet (:,(iMeasure-1)*(length(TransformSet))+iTransform) = Data_Gray;
            Data_BrainMaskSet (:,(iMeasure-1)*(length(TransformSet))+iTransform) = Data_BrainMask;

        end
        
    end
end


figure;
%boxplot(Data_GraySet)


Data_GraySet_Column = Data_GraySet(:);

for i=1:size(Data_GraySet,2)
    Group((i-1)*length(find(GreyMask))+1:i*length(find(GreyMask)),1) = i*ones(length(find(GreyMask)),1);
    
    ColorGroup((i-1)*length(find(GreyMask))+1:i*length(find(GreyMask)),1) = mod(i,8)*ones(length(find(GreyMask)),1);
end

%boxplot(Data_GraySet_Column,Group,'colorgroup',ColorGroup)


Colormap = [0 0 0;1 1 1;0 0.8 0.8;0 0.8 0;0.8 0.8 0;1 0 1;1 0 0];
Colormap = [0.5 0.5 0.5;1 1 1;0 0.8 0.8;0 0.8 0;0.8 0.8 0;1 0 1;1 0 0;0 0 0];
boxplot(Data_GraySet_Column,Group,'colorgroup',ColorGroup,'colors',Colormap)
xlim([1 49])
box off






%130404
%%%%%
%Distribution Plot for pairwise Correlation!!!

GroupAnalysisOutDir = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/StatisticalAnalysis/Correlation_PairWise';

BrainMaskFile = ['/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllMeasures/GroupMask/GroupMask90Percent.nii'];
GrayMatterMaskFile = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllData/SymmetricGroupT1MeanTemplate/GroupGrayMatterMeanTemplate_61x73x61_33percent_ConjuctWithGroupMask90Percent.nii';
WhiteMatterMaskFile = '/home/data/HeadMotion_YCG/YAN_Work/TransformationProject/AllData/SymmetricGroupT1MeanTemplate/GroupWhiteMatterMeanTemplate_61x73x61_33percent_ConjuctWithGroupMask90Percent.nii';


MeasureSet = {'ALFF','fALFF','ReHo','VMHC','PCCFC','DC'};

Mask = rest_readfile(BrainMaskFile);
GreyMask = rest_readfile(GrayMatterMaskFile);
WhiteMask = rest_readfile(WhiteMatterMaskFile);


TransformSet1 = {'0_Raw_','0_Raw_','0_Raw_','0_Raw_','GSR_Raw','GSR_Raw','GSR_Raw','2_MeanSubtract_','2_MeanSubtract_','1_MeanDivide_','14_GlobalMeanSTDLogAbsCov_','13_GlobalCovNoMean_'};

TransformSet2 = {'GSR_Raw','2_MeanSubtract_','13_GlobalCovNoMean_','5_z_','2_MeanSubtract_','13_GlobalCovNoMean_','5_z_','13_GlobalCovNoMean_','5_z_','5_z_','5_z_','14_GlobalMeanSTDLogAbsCov_'};


TransformSet1 = {'0_Raw_','0_Raw_','0_Raw_','0_Raw_','0_Raw_','GSR_Raw','GSR_Raw','GSR_Raw','GSR_Raw','2_MeanSubtract_','2_MeanSubtract_','2_MeanSubtract_','1_MeanDivide_','5_z_','14_GlobalMeanSTDLogAbsCov_','13_GlobalCovNoMean_','14_GlobalMeanSTDLogAbsCov_'};

TransformSet2 = {'GSR_Raw','2_MeanSubtract_','13_GlobalCovNoMean_','5_z_','16_MeanRegressionSDDivision_','2_MeanSubtract_','13_GlobalCovNoMean_','5_z_','16_MeanRegressionSDDivision_','13_GlobalCovNoMean_','5_z_','16_MeanRegressionSDDivision_','5_z_','16_MeanRegressionSDDivision_','5_z_','16_MeanRegressionSDDivision_','16_MeanRegressionSDDivision_'};

% Non-standardized - GSR, Mean subtraction, Mean regression,
% Z-standardization, Mean regression & SD division; GSR - mean subtraction,
% mean regression, z-standardization, mean regression & SD division; Mean
% subtraction - mean regression, z-standardization, mean regression & SD
% division; Z-standardization - mean division, mean regression & SD
% division, mean regression & log SD regression; mean regression & SD
% division - mean regression, mean regression + log SD regression

%Colormap = [0 0.8 0.8;0 0.8 0;0.8 0.8 0;1 0 0;0 0.8 0;0.8 0.8 0;1 0 0;0.8 0.8 0;1 0 0;1 0 1;0 0 0;0.8 0.8 0];
Colormap = [0 0.8 0.8;0 0.8 0;0.8 0.8 0;1 0 0;0 0 0;0 0.8 0;0.8 0.8 0;1 0 0;0 0 0;0.8 0.8 0;1 0 0;0 0 0;1 0 1;0 0 0;0.5 0.5 0.5;0.8 0.8 0;0.5 0.5 0.5];

for iMeasure=1:length(MeasureSet)

    cd ([GroupAnalysisOutDir,filesep,MeasureSet{iMeasure}])

    
    for iTransform=1:length(TransformSet1)
        
        DataFileName = [TransformSet1{iTransform},TransformSet2{iTransform},'.nii'];
        Data = rest_readfile([DataFileName]);
        
        if strcmpi(MeasureSet{iMeasure},'VMHC')
            Data(31,:,:)=0; %Do not include the middle slice
        end
        
                
        Data_BrainMask = Data(find(Mask));
        Data_Gray = Data(find(GreyMask));
        Data_White = Data(find(WhiteMask));
        
        Data_GraySet (:,iTransform) = Data_Gray;
        Data_WhiteSet (:,iTransform) = Data_White;
        Data_BrainMaskSet (:,iTransform) = Data_BrainMask;
        

        
    end
    
%     x = [1:length(TransformSet1)];
%     errorbar(x-0.1,MeanGraySet,StdGraySet,'bo','MarkerFaceColor','b','MarkerSize',4)
%     errorbar(x,MeanWhiteSet,StdWhiteSet,'go','MarkerFaceColor','g','MarkerSize',4)
%     errorbar(x+0.1,MeanCSFSet,StdCSFSet,'ro','MarkerFaceColor','r','MarkerSize',4)
%     ylim([0.5 1.1])
%     set(gca,'XTickLabel',{})
    

%     %Signle Color
%     subplot(3,2,iMeasure)
%     boxplot(Data_GraySet)
%     ylim([-1.1 1.1])
%     
%     
    
    subplot(3,2,iMeasure)
    Data_GraySet_Column = Data_GraySet(:);
    
    for i=1:size(Data_GraySet,2)
        Group((i-1)*length(find(GreyMask))+1:i*length(find(GreyMask)),1) = i*ones(length(find(GreyMask)),1);
        
        ColorGroup((i-1)*length(find(GreyMask))+1:i*length(find(GreyMask)),1) = i*ones(length(find(GreyMask)),1);
    end
    
    
    
    boxplot(Data_GraySet_Column,Group,'colorgroup',ColorGroup,'colors',Colormap)
    ylim([-1.1 1.1])
    
end







