clear
clc
close all

numComp=86; % use 86 when match the component in Zhi's list
mask='/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/mask/melodic_IC_mni152_90prct_zhiMultipleANTs.nii.gz'
[MaskData,VoxDim,Header]=rest_readfile(mask);
MaskDataOneDim=reshape(MaskData,[],1);
MaskIndex = find(MaskDataOneDim);

FileNameSet1=[];
FileNameSet2=[];

for i=1:numComp
    
    if i<10
        FileName1=['/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/gRAICAR_PR_autoDim_ANTs/compMaps/comp00', num2str(i), '.nii']
        FileName2=['/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/gRAICAR_PR_autoDim_Zhi_new/compMaps/comp00', num2str(i), '.nii']
    else
        FileName1=['/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/gRAICAR_PR_autoDim_ANTs/compMaps/comp0', num2str(i), '.nii']
        FileName2=['/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/gRAICAR_PR_autoDim_Zhi_new/compMaps/comp0', num2str(i), '.nii']
    end
    FileNameSet1{i,1}=FileName1;
    FileNameSet2{i,1}=FileName2;
end

% read in groupAnalysis results Zhen

if ~isnumeric(FileNameSet1)
    [AllVolume1,VoxelSize1,theImgFileList1, Header1] =rest_to4d(FileNameSet1);
    fprintf('\n\tImage Files in the Group:\n');
    for itheImgFileList=1:length(theImgFileList1)
        fprintf('\t%s%s\n',theImgFileList1{itheImgFileList});
    end
end


[nDim1_Zhen,nDim2_Zhen,nDim3_Zhen,numComp_Zhen]=size(AllVolume1);
AllVolume1=reshape(AllVolume1,[],numComp_Zhen);

% mask out the nonbrain regions
AllVolume1=AllVolume1(MaskIndex, :);
AllVolume1(find(AllVolume1==nan))=0;

% read in groupAnalysis results Zhi

if ~isnumeric(FileNameSet1)
    [AllVolume2,VoxelSize2,theImgFileList2, Header2] =rest_to4d(FileNameSet2);
    fprintf('\n\tImage Files in the Group:\n');
    for itheImgFileList=1:length(theImgFileList2)
        fprintf('\t%s%s\n',theImgFileList2{itheImgFileList});
    end
end

[nDim1_Zhi,nDim2_Zhi,nDim3_Zhi,numComp_Zhi]=size(AllVolume2);
AllVolume2=reshape(AllVolume2,[],numComp_Zhi);

% mask out the nonbrain regions
AllVolume2=AllVolume2(MaskIndex, :);
AllVolume2(find(AllVolume2==nan))=0;

% compute the correlations between all components

RHO=corr(AllVolume1, AllVolume2)

% plot the correlation matrix
imagesc(RHO)
colorbar

% the last two components are zeros, replace them and find the best match
% for those matched components
%RHO(find(RHO==NaN))=0

maxRHO=zeros(1,numComp);
for i=1:numComp
    tmp=(RHO(:,i));
    maxRHO(1,i)=find(tmp==max(tmp));
end

compListZhi=[1 2 6 20 4 29 5 17 3 9 15 13 10 30 11 34 8 12]

% find the components matched best with Zhi's comp
numCommonComp=18;
% compListZhen=zeros(1,numCommonComp);
% for j=1:numCommonComp
%     
%     compNum=maxRHO(compListZhi(j));
%     compListZhen(1,j)=compNum;
% end

compListZhen=[1 2 5 20 4 31 6 10 3 7 15 13 9 26 17 37 14 11] % AC6 is matched with 31 (orginally matched with 6), AC15 is matched with 17 (orignally matched with 2), AC 16 is matched with 37 (originally matched with 1)
%compListZhen=[10 4 27 52 25 41 54 29 12 17 18 22 33 38 4 10 29 24] % This is the list for using flirt-fnirt-BBR to do the warp
% mathced according to the spatial correlations between unthresholded maps with Zhi's complist. CA4 and 6 are matched with 52 and 41 sepeartely. Both of them are matched with 54 originally. 
% so the seond and the third largest correlations are used

% scatterplot the spatial map between each component pair
figDir = ['/home/data/Projects/workingMemory/figs/gRAICAR/'];
figure(1)
for j=1:numCommonComp
    subplot(4,5,j)
    comp1=compListZhen(1,j)
    comp2=compListZhi(1,j)
    scatter(AllVolume1(:,comp1), AllVolume2(:, comp2))
    h=lsline;
    set(h, 'LineWidth',2)
    title(['AC', num2str(j)])
end

saveas(figure(1), [figDir, 'scatter_ANTsAndZhiComp.png'])

zhen=load('/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/gRAICAR_PR_autoDim_ANTs/Rockland126sub_result.mat')
zhi=load('/home/data/Projects/workingMemory/data/gRAICAR_analysis/Rockland/gRAICAR_PR_autoDim_Zhi_new/Rockland126sub_result.mat')

numCommonComp=18
x=1:126;
figure(2)
for j=1:numCommonComp
    y1=zhen.obj.result.foundComp(compListZhen(j), :);
    y2=zhi.obj.result.foundComp(compListZhi(j), :);
    subplot(4,5,j)
    plot(x,y1)
    hold on
    plot(x, y2, 'r')
    xlim([0 130])
    title(['AC', num2str(j)])
end
saveas(figure(2), [figDir, 'foundComp_ANTsAndZhi.png'])
close all
figure(3)
for j=1:numCommonComp
    comp=compListZhen(j)
    y1=zhen.obj.result.foundRepro{comp};
    y1=y1+y1';
        subplot(5,4,j)
    imagesc(y1)
    title(['AC', num2str(j)])
    colorbar
    caxis([0 22])
    axis square
end
saveas(figure(3), [figDir, 'foundRepro_ANTs.png'])

close all
figure(4)
for j=1:numCommonComp
    comp=compListZhi(j)
    y1=zhi.obj.result.foundRepro{comp};
    y1=y1+y1';
        subplot(5,4,j)
    imagesc(y1)
    title(['AC', num2str(j)])
    colorbar
    caxis([0 22])
    axis square
end
saveas(figure(4), [figDir, 'foundRepro_Zhi.png'])

figure(5)
for j=1:numCommonComp
    y1=zhen.obj.result.foundRepro{compListZhen(j)};
    y1=reshape(triu(y1,1), [],1);
    y2=zhi.obj.result.foundRepro{compListZhi(j)};
     y2=reshape(triu(y2,1), [],1);
        subplot(5,4,j)
    scatter(y1, y2)
    h=lsline;
    set(h, 'LineWidth',2)
    title(['AC', num2str(j)])
    ylim([0 40])
    xlim([0 40])
end
saveas(figure(5), [figDir, 'scatter_foundRepro_ANTs&Zhi.png'])


