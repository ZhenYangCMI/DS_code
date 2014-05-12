function [v,idx] = calcPagerank (obj,m)

% function [v,idx] = calcPagerank (obj)
% purpose: calculate pagerank for each IC, and sort them in a descending
% order
% input:   
%           obj: with result.trialTab
%           m:   a connection matrix generated by normByRow.m
% output: 
%           v: vector, sorted pagerank values
%           idx: vector, the indices of the ICs, corresponding to v


% m = obj.result.MICM;
% m = m-min(m(:));

rangeTable2 = cumsum (obj.result.trialTab(:, 3));
rangeTable1 = [0; rangeTable2];
rangeTable1(end) = [];

for j = 1:length(rangeTable1)
    m(rangeTable1(j)+1:rangeTable2(j),rangeTable1(j)+1:rangeTable2(j)) = 0;
end

P = normout(m);
r = inoutpr(P,1);

[v,idx] =sort(r, 'descend');