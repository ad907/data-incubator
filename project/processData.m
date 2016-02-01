%processData
addpath data-processing/jsonlab data-processing

%% create data frame of data from Land Registry
addpath data-processing
centralLondon = [51.5152, 0.1416]; %Oxford Circus
readData();
load('data.mat');
[dataframe.arclength, dataframe.lat, dataframe.long] = computeDistances(dataframe, centralLondon);
dataframe.bedrooms = inferBedrooms(dataframe, 4);

save('data.mat','dataframe');

%%
%create dataframe of 
jsonfiles = {'chelsea.json','hounslow.json','stockwell.json'};
dfpred = convertJSONtoDataFrame(jsonfiles,centralLondon);
save('data-processing/nestoriadata.mat','dfpred');