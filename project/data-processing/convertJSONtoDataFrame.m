function dfpred = convertJSONtoDataFrame(jsonfiles,centralLondon)

%convertJSONtoDataFrame
addpath jsonlab

% initialise dataframe
dfpred.price     = [];
dfpred.date      = [];
dfpred.type      = [];
dfpred.lease     = [];
dfpred.arclength = [];
dfpred.lat       = [];
dfpred.long      = [];
dfpred.bedrooms  = [];
dfpred.location  = [];
nFiles = numel(jsonfiles);                            %number of json files
ctr = 1;                                      %initialise dataframe counter

for i = 1:nFiles
    data = loadjson(jsonfiles{i});                          %read json data
    listings  = data.response.listings;                       %get listings
    nListings = numel(listings);
    for j = 1:nListings
        if ~isfield(listings{j},'longitude') | ~isfield(listings{j},'latitude')
            continue;
        end
        dfpred.price(ctr)     = listings{j}.price;         %fill data frame
        dfpred.date(ctr)      = 2015;
        dfpred.type{ctr}      = 'F';
        dfpred.lease{ctr}     = 'L';
        dfpred.lat(ctr)  = listings{j}.latitude;
        dfpred.long(ctr) = listings{j}.longitude;
        dfpred.arclength(ctr) = distance(listings{j}.latitude,listings{j}.longitude,...
                                         centralLondon(1),centralLondon(2)); 
        dfpred.bedrooms(ctr)  = 1;
        dfpred.location{ctr} = jsonfiles{i};
        ctr = ctr + 1;
    end
end