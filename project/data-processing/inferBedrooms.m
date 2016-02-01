function rooms = inferBedrooms(dataframe,nBed)
%inferBedrooms.m
%Alexandre de Figueiredo
%29January2016
%
% Description: For each postal code area use a Gaussian Mixture model to
% infer the number of bedroom in each household


years     = unique(year(dataframe.date));
nYears    = numel(years);
nHouses   = numel(dataframe.price);
district  = unique(dataframe.district);
nDistrict = numel(district);
housetype = unique(dataframe.type);
nType     = numel(housetype);
rooms     = NaN*ones(nHouses,1);

for i = 1:nDistrict    %infer no of bedrooms over districts and house types
   disp(['Processing district: ', num2str(i), ' out of ', num2str(nDistrict)]);
   for j = 1:nType
       for k = 1:nYears
           nBedrooms = nBed;
           idx = find(ismember(dataframe.district, district(i)) & ...
               ismember(dataframe.type, housetype(j)) & ismember(year(dataframe.date),years(k)));
           priceij = dataframe.price(idx);     %price of district and housetype
           if numel(priceij) < 30                     %skip if low house number
               continue;
           end
           isGMFit = false;
           while(~isGMFit & nBedrooms > 1)       %catch bad covariance matrices
               try
                    gmfit = fitgmdist(priceij,nBedrooms);
                    roomsij = cluster(gmfit,priceij);
                    isGMFit = true;
               catch ME
                    nBedrooms = nBedrooms - 1;      %reduce number of gaussians
               end

           end

           if nBedrooms == 1; continue; end
            
           price = zeros(nBedrooms,1); 
           for kk = 1:nBedrooms
               price(kk) = mean(priceij(roomsij==kk));
           end
           [~,mapidx] = sort(price);
           for kk = 1:nBedrooms
               outidx = roomsij == mapidx(kk);
               rooms(idx(outidx)) = kk;
           end
           
       end
   end
end

