function generateKMLFiles(dataframe,kmlopts)
%generateKMLFiles
%Alexandre de Figueiredo
%29January2016
%
% Description: Produce kml files for google map api layering
% Input: dataframe (dataframe of final data)
%        kmlopts   (3x1 cell containing year, type, bedrooms)
%%
plotopts = {2015,'F',2};

kmlyear = plotopts{1};                                   %parse kml options
kmltype = plotopts{2};
kmlbeds = plotopts{3};

kmlidx  = year(dataframe.date) == kmlyear & ismember(dataframe.type,kmltype)...
         & dataframe.bedrooms == kmlbeds;                      %query index
npoints = sum(kmlidx);                         %number of query data points
pricebins = 10^5*[0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,7.5,10];

col = redbluecmap();                       %color palette
nCol = numel(col);

colidx = discretize(dataframe.price(kmlidx), pricebins);        %bin prices

kmllat  = dataframe.lat(kmlidx); 
kmllong = -dataframe.long(kmlidx);

nCol = 1;
iconhttp = 'http://maps.google.com/mapfiles/kml/pal2/icon15.png';
% write files for each colour
for i = 1:nCol
    filename = ['c-',num2str(kmlyear),'-',num2str(i),'-',kmltype,'-',num2str(kmlbeds),'.kml'];
    idx2file = colidx == i;
    kmlwrite(filename, kmllat(idx2file), kmllong(idx2file),kmllong(idx2file),'Icon',iconhttp, 'Color', col(i,:));
end

