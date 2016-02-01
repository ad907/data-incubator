%get_london_postcodes
%Alexandre de Figueiredo
%29January2016
%
% Description: script to obtain latitude and longitude of London postcodes
% from file ukpostcodes.csv (Accessed from ******) [id,pc,lat,long]

fileID     = fopen('ukpostcodes.csv','r');
formatSpec = '%f %s %32f %32f';
londonPC   = cellfun(@(x) strtok(x,':'),importdata('ldnpostcodes.txt'), ...
                                                   'UniformOutput', false);

D = textscan(fileID, formatSpec, 'Delimiter', ',');
E = cellfun(@(x) x(1:3), D{2}, 'UniformOutput', false);
idxLondon = find(ismember(E,londonPC));              %find london postcodes

% write data to file
nRows     = numel(D{2}(idxLondon));
fileIDOut = fopen('ldn_pc_latlong.csv','w');

for i = 1:nRows
    fprintf(fileIDOut,'%s%.6f%s%.6f\n',[D{2}{idxLondon(i)},','],...
                        D{3}(idxLondon(i)),',',D{4}(idxLondon(i)));
end                 

fclose(fileIDOut);
