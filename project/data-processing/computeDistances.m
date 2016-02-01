function [dist,lat,long] = computeDistances(dataframe,centralLondon)
%compute_distances.m
%Alexandre de Figueiredo
%29January2016
%
% Description: convert house postcode to distance from central London by
% converting postcode to lat/long and then calculating distance between two
% coordinates (see http://www.movable-type.co.uk/scripts/latlong.html)

postcodeData = importdata('../ldn_pc_latlong.csv');
coords       = postcodeData.data;
pc_london    = postcodeData.textdata;

clear postcodeData

n = numel(dataframe.postcode);
[~,loc] = ismember(dataframe.postcode,pc_london);          %match postcodes
idxzero = (loc == 0);                                   %find zero elements
loc(idxzero) = [];                                    %remove zero elements
dlat  = coords(loc,1);                                         %get latitude
dlong = -coords(loc,2);                     %get longitude (default is west)
d = distance(dlat,dlong,centralLondon(1),centralLondon(2)); %find arc-length
dist = NaN*ones(n,1); lat = NaN*ones(n,1); long = NaN*ones(n,1);
dist(~idxzero) = d; lat(~idxzero) = dlat; long(~idxzero) = dlong;









