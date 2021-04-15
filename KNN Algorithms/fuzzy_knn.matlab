%Cansu Sari
clear
clc
dta = xlsread('Wisconsin Diagnostic Breast Cancer');
l = length(dta);
fold_l = ceil(l/5);

    for i = 1:l
        for j = 1:11
            mdta(i,j) = (dta(i,j)- min(dta(:,j))) / range(dta(:,j));    %mapped data between 0 and 1
        end
    end
    
rng(10);
n = randperm(l);
for i = 1:l
    for k = 1:11
        sdta(i,k) = mdta(n(i),k);  %shuffled data
    end
end

error_fuzzy = zeros(5,50);
for b = 1:5
    if b ~= 5
        from = (b-1)*fold_l+1;
        to = b*fold_l;
    else
        from = (b-1)*fold_l+1;
        to = l;
    end

    vlddta = sdta(from:to,:);         %partition
    trdta = sdta;
    trdta(from:to,:) = [];

    vldnum = length(vlddta);
    trainnum = length(trdta);

    dist = zeros(vldnum,trainnum);
    for i = 1:vldnum 
        for j = 1:trainnum 
            for m = 1:10
                dist(i,j) = dist(i,j) + (vlddta(i,m)-trdta(j,m))^2;     %euclidean distance is used
            end
        end
    end
    dist = sqrt(dist);
    [distances, indices] = sort(dist,2);  %indices are kept while sorting

    memofneighbors = zeros(trainnum,2);
    for i = 1:trainnum
        if trdta(i,11)== 1
            memofneighbors(i,1) = 1;        %membership scores of neighbors to classes
        else
            memofneighbors(i,2) = 1;
        end
    end
    memscore = zeros(vldnum,2);
    for k = 1:50 %k values
        error_num = 0;
        for i = 1:vldnum
            for j = 1:2 %classes    
                nominator = 0;
                denominator = 0;
                for m = 1:k
                    nominator = nominator + memofneighbors(indices(i,m),j)*(1/distances(i,indices(i,m))^2);  %assumption: m value is equal to 2, therefore 2/(m-1) = 2
                    denominator = denominator + 1/distances(i,indices(i,m))^2;
                end
                memscore(i,j) = nominator/denominator;
            end
            label_validation = zeros(vldnum);

                if memscore(i,1)> memscore(i,2)
                    label_validation(i) = 1;
                else
                    label_validation(i) = 0;
                end

            if label_validation(i) ~= vlddta(i,11)
                error_num = error_num +1;
            end
        end
        error_fuzzy(b,k) = error_num/vldnum*100;  %errors are kept
    end
end

avg_errors = mean(error_fuzzy);
[minerror,bestk_fuzzy] = min(avg_errors);         
                
plot(avg_errors);
title("Average value of errors vs k values");