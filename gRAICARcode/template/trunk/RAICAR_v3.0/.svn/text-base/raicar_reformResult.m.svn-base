function [subj] = raicar_reformResult (subj)

%
% function [subj] = raicar_reformResult (subj)
%
% Author: Zhi Yang
% Version: 2.0
% Last change: June 28, 2007
% 
% Purpose: 
%   Z-normalize the component maps and corresponding mixing matrix, 
%   and then reshape it to 4D matrix (x, y, z, numComp)
%
% Input:
%   subj: subject object. The following input field will affect this
%   function:
%       subj.result.aveMap     : averaged component maps (2D matrix,
%           numComp*numVx)
%       subj.result.aveTc      : averaged component time courses (2D
%           matrix, numPt*numComp)
%       subj.result.coordTable : the lookup table for the location of the
%           voxels
%
% Output:
%   subj: subject object. The following input field will be add/modified  in this
%   function:
%       subj.result.aveMap    : averaged component maps (Z-normalized, 4D matrix);
%       subj.result.aveTc     : averaged component time courses (Z-normalized, 2D);
%
%

% initialize
msksz = subj.result.info.dime.dim(2:4);
sz = size (subj.result.aveMap);

% normalize the map
for i = 1:sz(1)
    subj.result.aveMap(i, :) = (subj.result.aveMap(i, :)-mean (subj.result.aveMap(i, :))) ...
        /std (subj.result.aveMap(i, :));
end

% normalize the time course
for i = 1:sz(1)
    subj.result.aveTc(:, i) = (subj.result.aveTc(:, i)-mean (subj.result.aveTc(:, i))) ...
        /std (subj.result.aveTc(:, i));
end

% reshape map to 4D
subj.result.aveMap = raicar_2Dto4D (subj.result.aveMap, msksz, subj.result.coordTable);
