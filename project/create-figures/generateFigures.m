
%% gaussian mixture fitting

postcode = 'SW17';
yr       = 1996;
type     = 'F';

idx = strcmp(dataframe.district,postcode) & ...
      ismember(dataframe.type,type) & ...
      ismember(year(dataframe.date),yr);
centres = linspace(40000,200000,40);
price = dataframe.price(idx);
gmfit = fitgmdist(price,4);
rooms = cluster(gmfit,price);

hold on
for i = 1:4
    histogram(price(rooms==i),centres);
end
xlabel('house price (£)')
ylabel('frequency')
legend({'1 bed','2 bed', '3 bed', '4 bed'})
title(['distribution of house prices in ', postcode, ', ', num2str(yr)])
set(gca,'FontSize',15)

%% house price with distance
yr    = 2015;
type  = {'F','S','D','T'};
rooms = 2;

ctr = 1;
for yr = [2000,2015]
    subplot(1,2,ctr)
    hold on
    for i = 1:4
        idx = ismember(dataframe.type,type{i}) & ...
              ismember(year(dataframe.date),yr) & ...
              dataframe.bedrooms == rooms;

        plot(dataframe.arclength(idx),dataframe.price(idx),'.','MarkerSize',5);    
    end
    legend({'flat','semi-detached','detached','terraced'})
    xlabel('distance from centre of London (arclength)');
    ylabel('price (£)');
    title(['4 bed properties: ', num2str(yr)])
    set(gca,'FontSize',16)
    ctr = ctr + 1;
end






