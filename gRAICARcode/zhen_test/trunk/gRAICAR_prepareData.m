function obj = gRAICAR_prepareData (obj, sub)

if nargin < 2
	sub = 1:obj.setup.subNum;
end

% dwt on mask
szmsk = size (obj.result.mask);
%dsmpMsk = my_dwt3D (double(obj.result.mask));
%dsmpMsk (dsmpMsk < 0) = 0;
dsmpMsk = obj.result.mask;

% checking the prepared data
for sb = sub
    fprintf ('subject %d: checking data\n', sb);
	trTab = find (obj.result.trialTab(:, 2) == sb);
    trials = length (trTab);
        
    for tr = 1:trials;			
        fn = sprintf ('%s/bin_%s%d.mat', cell2mat (obj.setup.subDir(sb)), obj.setup.ICAprefix, tr);
        if exist (fn, 'file')
            fprintf ('file %s exist, will not overwrite it\n', fn);
            try
               load (fn);
               obj.result.trialTab(trTab(tr), 3) = size (comp, 1);
            catch exception
                error ('!!!!!! failed to load file %s\n',  fn);
            end
            % save nii header info
            ext = getExtension (obj.setup.ICAprefix);
            if strcmp (ext, '.gz')
                if trials == 1
                    fn = sprintf ('%s/%s', cell2mat (obj.setup.subDir(sb)), obj.setup.ICAprefix);
                elseif trials > 1
                    fn = sprintf ('%s%d/%s', cell2mat (obj.setup.subDir(sb)), tr, obj.setup.ICAprefix);
                end
            end
            if sb == 1 && tr == 1
                tmp_fn = gunzip(fn);
                tmp_nii = load_nii (cell2mat(tmp_fn));
                obj.setup.niihdr = tmp_nii.hdr;
                delete (cell2mat(tmp_fn));
                clear tmp_nii;
            end
        else
            fprintf ('transforming trial %d of subject %d\n', tr, sb);
            tic,
            ext = getExtension (obj.setup.ICAprefix);
            if strcmp (ext, '.gz')
                if trials == 1
                    fn = sprintf ('%s/%s', cell2mat (obj.setup.subDir(sb)), obj.setup.ICAprefix);
                elseif trials > 1
                    fn = sprintf ('%s%d/%s', cell2mat (obj.setup.subDir(sb)), tr, obj.setup.ICAprefix);
                end
                [nii, dim] = read_avw(fn);
				% save nii header info
				if sb == 1 && tr == 1
					tmp_fn = gunzip(fn);
					tmp_nii = load_nii (cell2mat(tmp_fn));
					obj.setup.niihdr = tmp_nii.hdr;
					delete (cell2mat(tmp_fn));
					clear tmp_nii;
				end
                icasig = reshape (nii, dim(1)*dim(2)*dim(3), dim(4));
                icasig (obj.result.mask==0, :) = [];
                icasig = icasig';
            elseif isempty (ext)
                if trials == 1
                    fn = sprintf ('%s%s.mat', cell2mat (obj.setup.subDir(sb)), obj.setup.ICAprefix);
                elseif trials > 1
                    fn = sprintf ('%s%s%d.mat', cell2mat (obj.setup.subDir(sb)), obj.setup.ICAprefix, tr);
                end
                try
                    load (fn);
                catch exception2
                    error ('failed to load file %s\n',  fn);
                end
            end
   
			%%%%%%%%% filter data %%%%%%%
            if ~isempty (obj.setup.candidates)
                select = cell2mat (obj.setup.candidates{tr, sb});
                comp = icasig(select, :);
			else
				comp = icasig;
			end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            clear icasig A W nii;

            % bin the data
            [numComp, numVx] = size (comp);
            ncellx=ceil(numVx^(1/3));
            for cp = 1:numComp
                comp(cp, :) = NMI_binData (comp(cp, :), numVx, ncellx);
            end
            fn = sprintf ('%s/bin_%s%d.mat', cell2mat (obj.setup.subDir(sb)), ...
            obj.setup.ICAprefix, tr);
            save (fn, 'comp');
			obj.result.trialTab(trTab(tr), 3) = size (comp, 1);
			fprintf ('num of IC = %d\n',size (comp, 1));
            toc,
       end
    end
end
inFn = sprintf ('%s_configFile.mat',obj.setup.outPrefix);
save (inFn, 'obj');
fprintf ('subject %d: done\n', sb);
