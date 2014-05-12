function [ A ] = readcsvFile( csvFile )
%input a csv file with path. e.g csvFile=['/home2/data/Projects/workingMemory/data/CWAS23Adoles_BTNP.csv']
% output a cell array
fid = fopen(csvFile, 'r');
tline = fgetl(fid);

% Split header
A(1,:) = regexp(tline, '\,', 'split');

% Parse and read rest of file
ctr = 1;
while(~feof(fid))
if ischar(tline) 
ctr = ctr + 1;
tline = fgetl(fid); 
A(ctr,:) = regexp(tline, '\,', 'split'); 
else
break; 
end
end
fclose(fid);

end

