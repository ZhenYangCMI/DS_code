

clear
clc
close all

% define path and variables
subList=load(['/home/data/Projects/workingMemory/mask/subjectList_Num_68sub.txt']);
numSub=length(subList)
metric='CWAS' %'DegreeCentrality'
resultDir=['/home/data/Projects/workingMemory/results/CPAC_12_16_13/groupAnalysis/compCor/CWAS3mm/followUpFC_meanRegress/groupAnalysis/'];

figDir=['/home/data/Projects/workingMemory/figs/paper_figs/CWASFolloup/'];
[NUM,TXT,RAW]=xlsread(['/home/data/Projects/workingMemory/data/regressionModelCPACNewAnalysisAgeDemeanByDSDemean.xls']);

%if task=DB, T=T5 B=b5; if task=DF T=T4 B=b4; if task Tot T=T3 B=b3
taskList={'FT', 'BT', 'Tot'}; % DF, DB, Tot
signList={'pos', 'neg'};
for k=1:length(taskList)
    task=char(taskList{k})
    
    for t=1:length(signList)
        sign=char(signList{t})
        close all
        if strcmp(task, 'FT')
            T='T4'
            numBeta=5
            maskFile=[resultDir, '/easythresh/cluster_mask_fullModel_ageByFTdemean_ROI1_', T, '_Z_', sign, '.nii.gz']
        elseif strcmp(task, 'BT')
            T='T5'
            numBeta=5
            maskFile=[resultDir, '/easythresh/cluster_mask_fullModel_ageByBTdemean_ROI1_', T, '_Z_', sign, '.nii.gz']
        elseif strcmp(task, 'Tot')
            T='T3'
            numBeta=3
            maskFile=[resultDir, '/easythresh/cluster_mask_TotTSep_ageByTotTdemean_ROI1_', T, '_Z_', sign, '.nii.gz']
        end
        
        % read in the mask and reshape to 1D
        [OutdataMask,VoxDimMask,HeaderMask]=rest_readfile(maskFile);
        [nDim1Mask nDim2Mask nDim3Mask]=size(OutdataMask);
        maskImg1D=reshape(OutdataMask, [], 1);
        numClust=length(unique(maskImg1D(find(maskImg1D~=0))))
        
        age=NUM(:, 14);
        FT=NUM(:, 15);
        BT=NUM(:, 16);
        Tot=NUM(:,17);
        IQ=NUM(:, 21);
        FD=NUM(:, 22);
        hand=NUM(:, 23);
        
        
        x1 = linspace(min(age)-1, max(age)+1,100);
        x2 = linspace(min(FT)-1, max(FT)+1, 100);
        x3 = linspace(min(BT)-1, max(BT)+1, 100);
        x4 = linspace(min(Tot)-1, max(Tot)+1, 100);
        
        %x4 = linspace(min(IQ)-1, max(IQ)+1,100);
        %x5 = linspace(min(FD)-1, max(FD)+1, 100);
        %x6 = linspace(min(hand)-1, max(hand)+1, 100);
        
        x11=repmat(x1, 100,1);
        x22=repmat(x2', 1,100);
        x33=repmat(x3', 1,100);
        x44=repmat(x4', 1,100);
        %x55=repmat(x5, 100,1);
        %x66=repmat(x6,100,1);
        
        % exatract the ROI mean beta
        
        clustBeta=zeros(numBeta, numClust);
        yfit=zeros(100, 100, numClust);
        
        for i=1:numClust
            clust=num2str(i);
            for j=1:numBeta
                beta=num2str(j);
                if strcmp(task, 'Tot')
                    FileName=[resultDir, 'TotTSep_ageByTotTdemean_ROI1_b', beta, '.nii' ];
                else
                    FileName=[resultDir, 'fullModel_ageBy', task, 'demean_ROI1_b', beta, '.nii' ];
                end
                [Outdata,VoxDim,Header]=rest_readfile(FileName);
                [nDim1 nDim2 nDim3]=size(Outdata);
                img1D=reshape(Outdata, [], 1);
                img1DROI=img1D(find(maskImg1D==i));
                avg=mean(img1DROI);
                clustBeta(j, i)=avg;
            end
            
            % linespace the beta values
            
            for j=1:numBeta
                betaMatrix(:, :, j, i)=repmat(clustBeta(j,i), 100, 100);
            end
            
            % compute the interation term
            
            for m=1:100
                for n=1:100
                    ageByFT(n,m, i)=x1(m)*x2(n);
                    ageByBT(n,m, i)=x1(m)*x3(n);
                    ageByTot(n,m,i)=x1(m)*x4(n);
                    
                end
            end
            
            %yfit=betaMatrix(:,:,1,i).*x11+betaMatrix(:,:,2,i).*x22+betaMatrix(:,:,3,i).*x33+betaMatrix(:,:,4,i).*ageByFT(:,:,i)+betaMatrix(:,:,5,i).*ageByBT(:,:,i);
            
            figure(i)
            if strcmp(task, 'FT')
                yfit=betaMatrix(:,:,1,i).*x11+betaMatrix(:,:,2,i).*x22+betaMatrix(:,:,4,i).*ageByFT(:,:,i);
                pcolor(x1, x2, yfit); shading flat, shading interp;
                hold on
                scatter(age, FT, 'b')
            elseif strcmp(task, 'BT')
                yfit=betaMatrix(:,:,1,i).*x11+betaMatrix(:,:,3,i).*x33+betaMatrix(:,:,5,i).*ageByBT(:,:,i);
                pcolor(x1, x3, yfit); shading flat, shading interp;
                hold on
                scatter(age, BT, 'b')
            elseif strcmp(task, 'Tot')
                yfit=betaMatrix(:,:,1,i).*x11+betaMatrix(:,:,2,i).*x44+betaMatrix(:,:,3,i).*ageByTot(:,:,i);
                pcolor(x1, x4, yfit); shading flat, shading interp;
                hold on
                scatter(age, Tot, 'b')
            end
            %             xlabel('Demeaned Age')
            %             ylabel(['Demeaned Digit Span Score'])
            %             title([metric, task, sign, 'cluster', num2str(i)])
            hcb=colorbar
            
            if strcmp(metric, 'DegreeCentrality')
                caxis([-10000 10000])
                set(hcb,'YTick',[-10000,-5000, 0, 5000, 10000])
            elseif strcmp(metric, 'ReHo') || strcmp(metric, 'fALFF')
                caxis([-0.05 0.05])
                set(hcb,'YTick',[-0.05,-0.025, 0, 0.025, 0.05])
            elseif strcmp(metric, 'VMHC')
                caxis([-0.3 0.3])
                %set(hcb,'YTick',[-0.05,-0.025, 0, 0.025, 0.05])
                
            elseif strcmp(metric, 'CWAS')
                      caxis([-0.4 0.4])
                       set(hcb,'YTick',[-0.4,-0.2, 0, 0.2, 0.4])
                 end
            saveas(figure(i), [figDir, metric, '_ageBy', task, '_ROI1',  sign, '_cluster', num2str(i),'.png'])
        end
    end
end




