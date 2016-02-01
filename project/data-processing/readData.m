function readData()
%Alexandre de Figueiredo
%28January2016
%
% Description: script to read and parse UK house data "chunk by chunk". 
% Create a dataframe object containing 
% 1. houseprice                     [integer]
% 2. date of purchase               [datetime]
% 3. full postcode                  [string]
% 4. type of house                  [categorical]
% 5. freehold/leasehold             [categorical]
% 6. postcode beginning             [string]
% 7. distance to central london     [double] (to be added)

chunkSize  = 1000000; 
priceMax   = 1000000;
londonPC   = cellfun(@(x) strtok(x,':'),importdata('../ldnpostcodes.txt'), ...
                                                   'UniformOutput', false);
fileID     = fopen('../pp-complete.csv','r');
formatSpec = '%*q %q %D %q %C %*q %C %*q %*q %*q %*q %*q %*q %*q %*q %*q';

%read in house data chunk-wise
k = 0;
while ~feof(fileID)  
    k = k+1;
    disp(k)
    C = textscan(fileID, formatSpec, chunkSize, 'Delimiter', ',');
    C{1} = cellfun(@str2num, C{1});           %convert house prices to ints   
    idxPC = cellfun(@isempty,C{3});               %indices without postcode
    Ctemp = C{3};
    C{3}(~idxPC) = strtrim(cellfun(@(x) x(1:4), C{3}(~idxPC), 'UniformOutput', false));
    
    idxLondon = ismember(C{3},londonPC);             %find london postcodes
    C{6} = C{3};                     %create new column with postcode start
    C{3} = Ctemp;
    idxPrice  = C{1} < priceMax;                     %filter on house price
    dataToSelect = idxLondon & idxPrice;                  %filtered indices
    for i = 1:size(C,2)
        C{i}(~dataToSelect) = [];                   %remove non-London data
    end
    %save chunks to .mat file
    eval(['C',num2str(k),'=C;']);
    s = ['C',num2str(k)];
    if k == 1
        save('data_prov.mat',s);
    else
        save('data_prov.mat',s,'-append');
    end
    clear idxPC idxLondon idxPrice dataToSelect C Ctemp    %clear variables
    eval(['clear C',num2str(k)]);
end

% save data to struct
load('data_prov.mat')
nChunks = k;
dataframe.price = []; dataframe.date = []; dataframe.postcode = []; 
dataframe.type = []; dataframe.lease = []; dataframe.district = [];

for i = 1:nChunks
    eval(['dataframe.price    = [dataframe.price; C',num2str(i),'{1}];']);
    eval(['dataframe.date     = [dataframe.date; C',num2str(i),'{2}];']);
    eval(['dataframe.postcode = [dataframe.postcode; C',num2str(i),'{3}];']);
    eval(['dataframe.type     = [dataframe.type; C',num2str(i),'{4}];']);
    eval(['dataframe.lease    = [dataframe.lease; C',num2str(i),'{5}];']);
    eval(['dataframe.district = [dataframe.district; C',num2str(i),'{6}];']);
end

save('data.mat','dataframe')
clear all; delete('data_prov.mat');
