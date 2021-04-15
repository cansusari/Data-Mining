%Cansu Sari
clear
clc
dta = xlsread('Wisconsin Diagnostic Breast Cancer');
l = length(dta);
rng(10);
n = randperm(l);
for i = 1:l
    for k = 1:11
        sdta(i,k) = dta(n(i),k);  %shuffled data
    end
end
for i = 1:l
    for j = 1:11
        mdta(i,j) = (sdta(i,j)- min(sdta(:,j))) / range(sdta(:,j));    %mapped data between 0 and 1
    end
end
trainnum = ceil(l*0.8);
vldnum = l-trainnum;
trdta = mdta(1:trainnum,:);         %partition
vlddta = mdta(trainnum+1:l,:);
vlddtatest = vlddta(:,1:10);
vlddtaresp = vlddta(:,11);
att = trdta(:, 1:10); %attribute
lbl = trdta(:,11);    %label

bestk = 0;
minerror = 1000;
for i=1:100
    KNN = fitcknn(att,lbl,'NumNeighbors',i); 
    label = predict(KNN,vlddtatest);   
    label2 = predict(KNN, att);
    
    wrng = 0;
    for j = 1:vldnum
        if label(j) ~= vlddtaresp(j)
            wrng = wrng+1;
        end
    end
    error(i) = wrng/vldnum*100;
    if error(i) < minerror
        minerror = error(i);
        bestk = i;
    end
    
    wrng = 0;
    for j = 1:trainnum
        if label2(j) ~= lbl(j)
            wrng = wrng+1;
        end
    end
    error2(i) = wrng/trainnum*100; 
            
end

plot(error);
hold on
plot(error2);
title("k Values vs. Error Rates");