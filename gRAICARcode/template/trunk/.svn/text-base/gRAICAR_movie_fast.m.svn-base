function [allMap] = gRAICAR_movie_fast (obj, comps)


flagInit = 1;
flagFirst = ones(length(comps),1);

% reproLoad = compWeight (obj,comps);


for sb = 1:obj.setup.subNum
	for tr = 1:obj.setup.trial(sb)
		% to be replaced by more capable loading function
		fn = sprintf ('%s/%s', cell2mat (obj.setup.subDir(sb)), obj.setup.ICAprefix);
        [nii, dim] = read_avw(fn);
		icasig = reshape (nii, dim(1)*dim(2)*dim(3), dim(4));
		icasig (obj.result.mask==0, :) = [];
		icasig = icasig';
		fprintf ('loaded subject %d, trial %d\n',sb, tr);

		for id = 1:length (comps)
		cp = comps(id);
		pos = sum(obj.setup.trial(1:sb-1))+tr;
		if obj.result.foundComp(cp,pos) ~= 0
			map = icasig(obj.result.foundComp(cp, pos), :);
			%	tc = A(:,obj.result.foundComp(cp, pos));
			map = (map-mean(map))./std(map);
            map4D = singleMap_2Dto4D (map, size(obj.result.mask), obj.result.coordTable);
			%	tc = (tc-mean(tc))./std(tc);
            if flagFirst(id) == 1
                if flagInit == 1
                    szmsk = size (obj.result.mask);
                    allMap = zeros (szmsk(1),szmsk(2),szmsk(3),length (comps),size(obj.result.trialTab,1));
                    refMap = zeros(length(comps), length(map));
                    flagInit = 0;
                end
        %		aveTc = zeros (length (tc), length (comps));
        %		aveMap(id, pos, :) = reproLoad(id, pos)*map;
                allMap(:,:,:,id, pos) = map4D;
        %		aveTc(:, id) = tc;
                flagFirst(id) = 0;
                refMap(id,:) = map;
            else
                tmp = corrcoef (refMap(id,:)',map');
        %		aveMap(id, :) = aveMap(id, :)+sign (tmp(1,2))*reproLoad(id, pos)*map;
                allMap(:,:,:,id, pos) = sign (tmp(1,2))*map4D;
        %		aveTc(:,id) = aveTc(:,id)+sign (tmp(1,2))*tc;
            end
		end
		end % comp
	end % trial
end % subject

% for i=1:size(obj.result.trialTab,1)
% allMap(:,:,:,:,i) = raicar_2Dto4D (squeeze(aveMap(:,i,:)), size(obj.result.mask), obj.result.coordTable);
% end

