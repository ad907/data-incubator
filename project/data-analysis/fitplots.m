%compute_model 


load('../data-processing/finaldata.mat');
%%
[mdl,ytest,tblTest] = computeModel(dataframe);
%% 
load('data-processing/nestoriadata.mat');

tblNestoria = table(dfpred.price', ...
                dfpred.date',...
                dfpred.arclength',...
                dfpred.bedrooms',...
                dfpred.type',...
                dfpred.lease',...
                dfpred.location',...
                'VariableNames',{'price';'year';'arcl';'rooms';'type';'lease';'location'});
idxout = tblNestoria.price > 1000000;
tblNestoria(idxout,:) = [];
ytestpred = predict(mdl,tblNestoria);

%%
figure(1)
subplot(1,2,1)
hold on
locations = unique(dfpred.location);
nLocation = numel(locations);
p = dfpred.price'; 
for i = 1:nLocation
    idxloc = strcmp(tblNestoria.location,locations(i));
    plot(ytestpred(idxloc),tblNestoria.price(idxloc),'o')
end
legend(locations)
plot([0,500000],[0,500000],'r')
set(gca,'FontSize',16)
xlabel('"market price" (£)')
ylabel('listed value (£)')

subplot(1,2,2)
hold on
for i = 1:nLocation
    idxloc = strcmp(tblNestoria.location,locations(i));
    plot((tblNestoria.price(idxloc)-ytestpred(idxloc))./ytestpred(idxloc),'o')
end
plot([0,60],[0,0],'r')
ylabel('IO (high = bad, low = good)')
xlabel('index')
set(gca,'FontSize',16)

%% plot predicted v observed houseprices under our linear model mdl

figure(1)
hold on
n = numel(ytest);
r = randsample(n,10000);
plot(ytest(r),tblTest.price(r),'.')
xx = [0,1000000];
plot(xx,xx,'r')

title('model validation on test data: R2 = 0.685');
xlabel('observed house price (£)');
ylabel('predicted house price (£)');
set(gca,'FontSize', 16)

%%
nanidx = ~(isnan(ytest) | isnan(tblTest.price));
corr(ytest(nanidx),tblTest.price(nanidx))^2

