%Cansu Sari
clear
clc
%part a, making necessary changes before using the fitctree function
[num,text,dat] = xlsread('FlightDelays');
l = length(num);
data = zeros(l,1);
for i = 1:l
    data(i,1) = fix(num(i,1)/100)*60+(num(i,1)-fix(num(i,1)));  %converting into minutes
    if text(i+1,13) == "ontime"  %preparing the label
        lbl(i,1)= 0;
    else
        lbl(i,1) =1;
    end
end
a = dummyvar(categorical(text(2:2202,2)));  %dummy variables for the categorical data
b = dummyvar(categorical(text(2:2202,4)));
c = dummyvar(categorical(text(2:2202,8)));
d = dummyvar(categorical(num(1:2201,10)));
e = dummyvar(categorical(num(1:2201,11)));
data = [data a b num(:,5) c num(:,10) d e lbl];  %building the whole data
[l,r] = size(data);
rng(10);
n = randperm(l);
for i = 1:l
    for k = 1:r
        sdata(i,k) = data(n(i),k);  %shuffling the data
    end
end
trainnum = ceil(l*0.8);
vldnum = l-trainnum;
traindata = sdata(1:trainnum,:);         %partition
validdata = sdata(trainnum+1:l,:);
trainlabel = traindata(:,r);
validlabel = validdata(:,r);
traindata(:,end) = [];
validdata(:,end) = [];

%part b, building the tree
tree = fitctree(traindata,trainlabel,'ClassNames', [0;1]);
view(tree, 'Mode','Graph');
[label,~,~,~] = predict(tree,validdata); 

errornum = 0;
for i=1:length(label)
    if label(i) ~= validlabel(i)
        errornum = errornum+1;
    end
end
error_partb = errornum/length(label)*100;  %misclassification error

pl = max(tree.PruneList);  %prune
pruneerror = zeros(pl,1);
for i = 1:pl
    prunedtree = prune(tree, 'Level', i);
    [plabel,pscore,pnode,pcnum] = predict(prunedtree,validdata);
    errornum = 0;
    for j=1:length(plabel)
        if plabel(j) ~= validlabel(j)
            errornum = errornum+1;
        end
    end
    pruneerror(i,1) = errornum/length(plabel)*100;
end

[min_error, best_prune] = min(pruneerror);
prunedtree = prune(tree, 'Level', best_prune);
view(prunedtree, 'Mode','Graph');
figure
plot(pruneerror);
title("Prune level vs Error rate for part b");

% errornumc1 = 0;             
% for i=1:length(label)
%     if label(i) ~= validlabel(i)
%         if label(i) == 0;
%             errornumc1 = errornumc1+1;
%         end
%     end
% end
% error_partd_c1 = errornumc1/length(label)*100; 
% 
% errornumc0 = 0;            
% for i=1:length(label)
%     if label(i) ~= validlabel(i)
%         if label(i) == 1;
%             errornumc0 = errornumc0+1;
%         end
%     end
% end
% error_partd_c0 = errornumc0/length(label)*100;  

% cost2 = 0;   %cost calculation        %can be calculated and compared with part d
% for i=1:length(label)
%     if label(i) ~= validlabel(i)
%         if label(i) == 0
%             cost2 = cost2+50;
%         else
%             cost2 = cost2+5;
%         end
%     end
% end
%part c
tree2 = fitctree(traindata,trainlabel,'ClassNames', [0;1], 'SplitCriterion','deviance');
view(tree2, 'Mode','Graph');
[label2,~,~,~] = predict(tree2,validdata); 

errornum = 0;
for i=1:length(label2)
    if label2(i) ~= validlabel(i)
        errornum = errornum+1;
    end
end
error_partc = errornum/length(label)*100;  %misclassification error

pl = max(tree2.PruneList);  %prune
pruneerror2 = zeros(pl,1);
for i = 1:pl
    prunedtree = prune(tree2, 'Level', i);
    [plabel,pscore,pnode,pcnum] = predict(prunedtree,validdata);
    errornum = 0;
    for j=1:length(plabel)
        if plabel(j) ~= validlabel(j)
            errornum = errornum+1;
        end
    end
    pruneerror2(i,1) = errornum/length(plabel)*100;
end

[min_error2, best_prune2] = min(pruneerror2);
prunedtree2 = prune(tree2, 'Level', best_prune2);
view(prunedtree2, 'Mode','Graph');
figure
plot(pruneerror2);
title("Prune level vs Error rate for part c");

%part d
tree3 = fitctree(traindata,trainlabel,'ClassNames', [0;1],'Cost',[0 5;50 0]);
[label3,~,~,~] = predict(tree3,validdata); 

% errornum = 0;             %can be calculated and compared with part b
% for i=1:length(label3)
%     if label3(i) ~= validlabel(i)
%         errornum = errornum+1;
%     end
% end
% error_partd = errornum/length(label3)*100;  
% 
% errornumc1 = 0;             
% for i=1:length(label3)
%     if label3(i) ~= validlabel(i)
%         if label3(i) == 0;
%             errornumc1 = errornumc1+1;
%         end
%     end
% end
% error_partd_c1 = errornumc1/length(label3)*100; 
% 
% errornumc0 = 0;            
% for i=1:length(label3)
%     if label3(i) ~= validlabel(i)
%         if label3(i) == 1;
%             errornumc0 = errornumc0+1;
%         end
%     end
% end
% error_partd_c0 = errornumc0/length(label3)*100;  

cost = 0;   %cost calculation
for i=1:length(label3)
    if label3(i) ~= validlabel(i)
        if label3(i) == 0
            cost = cost+50;
        else
            cost = cost+5;
        end
    end
end