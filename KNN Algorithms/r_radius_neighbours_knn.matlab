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
    
    %Use of the training data
    
att = trdta(:, 1:10); 
lbl = trdta(:,11);    
distt = zeros(trainnum,trainnum);

for i = 1:trainnum 
    for j = 1:trainnum 
        for m = 1:10
            distt(i,j) = distt(i,j) + (trdta(i,m)-trdta(j,m))^2;     %euclidean distance is used
        end
    end
end
distt = sqrt(distt);

[distancest, indicest] = sort(distt,2);

%for validation data
class = zeros(vldnum);
for r = 0.1:0.1:max(max(distances))
    errornum = 0;
    for i = 1:vldnum
        count0 = 0;
        count1 = 0;
        j = 1;
            while distances(i,j) <= r && j <= trainnum-1
                if trdta(indices(i,j),11) == 1
                    count1 = count1+1;
                else
                    count0 = count0+1;
                end
                j = j+1;
            end
            if count1 >= count0
                class(i) = 1;
            else
                class(i) = 0;
            end
            if min(distances(i,:)) > r 
                if sum(trdta(:,11))> trainnum/2
                    class(i) = 1;
                else     
                    class(i) = 0;  %from naive rule
                end
            end           
            if class(i) ~= vlddta(i,11)
            errornum = errornum+1;
            end
    end
    c=fix(r*10);
    error_radius(c) = errornum/vldnum*100;
end
[minerrorradius, bestrvalue] = min(error_radius);
bestrvalue = bestrvalue/10;
 
%for training data
class = zeros(trainnum);
for r = 0.1:0.1:max(max(distancest))
    errornum = 0;
    for i = 1:trainnum
        count0 = 0;
        count1 = 0;
        j = 1;
            while distancest(i,j) <= r && j <= trainnum-1
                if trdta(indicest(i,j),11) == 1
                    count1 = count1+1;
                else
                    count0 = count0+1;
                end
                j = j+1;
            end
            if count1 >= count0
                class(i) = 1;
            else
                class(i) = 0;
            end
            if min(distancest(i,:)) > r 
                if sum(trdta(:,11))> trainnum/2
                    class(i) = 1;
                else     
                    class(i) = 0;  %from naive rule
                end
            end           
            if class(i) ~= trdta(i,11)
            errornum = errornum+1;
            end
    end
    c=fix(r*10);
    error_radius_t(c) = errornum/trainnum*100;
end

 figure
 plot(error_radius);
 hold on
 plot(error_radius_t);
 title("r Values vs. Error Rates for r Radius Neighbors KNN");