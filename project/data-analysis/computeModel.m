function [mdl,ytestpred,tblTest] = computeModel(dataframe)
%computeModel.m
%
%compute linear model with all interaction terms included by backwards-BIC
%selection. Train on a 60% random partition. Test on the remaining 40%.


trainpct = 0.6;
testpct  = 0.4;

n = numel(dataframe.price);
shuffledVector = randsample(n,n);

idxTrain = shuffledVector(1:ceil(n*0.6));                     %training set
idxTest  = shuffledVector(idxTrain(end):n);                       %test set

VarNames = {'price';'year';'arcl';'rooms';'type';'lease'};

tblTest = table(dataframe.price(idxTest), ...
                year(dataframe.date(idxTest)),...
                dataframe.arclength(idxTest),...
                dataframe.bedrooms(idxTest),...
                dataframe.type(idxTest),...
                dataframe.lease(idxTest),...
                'VariableNames',VarNames);
            
tblTrain = table(dataframe.price(idxTrain), ...
                year(dataframe.date(idxTrain)),...
                dataframe.arclength(idxTrain),...
                dataframe.bedrooms(idxTrain),...
                dataframe.type(idxTrain),...
                dataframe.lease(idxTrain),...
                'VariableNames',VarNames);
      
mdl = fitlm(tblTrain,'price ~ rooms + arcl + year + type + arcl:rooms + rooms:type',...
                    'ResponseVar','price',...
                    'PredictorVars',VarNames(2:end),...
                    'CategoricalVar',{'year','rooms','type','lease'});
                %{
                    'Criterion','bic',...
                    'NSteps',20,...
                    'Upper','interactions',...
                    'Verbose',1); 
 %}

ytestpred = predict(mdl,tblTest);
ytestpred(ytestpred<0) = 10000;
save('fullmodel','mdl');
