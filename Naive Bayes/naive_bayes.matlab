%Cansu Sari
clear
clc
data = xlsread('UniversalBank','Data');
data(:,1) = [];
data(:,4) = [];
l = length(data);
  
%preparation of data
errors = zeros(1,81);
count3 = 1;
for a = 3:7
    for b = 3:7
        for c = 3:7
            for d = 3:7
                new_data = zeros(l,12);  
                age = sort(data(:,1)); % age: when the plot is observed, age distribution of the data is close to symmetric
                for i = 1:a         % transformation of age
                divide_age(i) = age(floor(l*(i)/a));
                end
                for i = 1:l
                    for j = 1:a
                        if new_data(i,1) == 0 && data(i,1) <= divide_age(j)
                            new_data(i,1) = j;
                        end
                    end
                end

                for i = 1:l             % as negative experience values exist in data, it is assumed as there is a typo and corrected by taking the absolute value.
                    if data(i,3) < 0
                        data(i,3) = -data(i,3);
                    end
                end
                exp = sort(data(:,2)); % experience: close to symmetric
                for i = 1:b            %transformation of experience
                divide_exp(i) = exp(floor(l*(i)/b));
                end
                for i = 1:l
                    for j = 1:b
                        if new_data(i,2) == 0 && data(i,2) <= divide_exp(j)
                            new_data(i,2) = j;
                        end
                    end
                end

                inc = sort(data(:,3)); % income: left skewed
                for i = 1:c             % transformation of income
                divide_inc(i) = inc(floor(l*(i)/c));
                end
                for i = 1:l
                    for j = 1:c
                        if new_data(i,3) == 0 && data(i,3) <= divide_inc(j)
                            new_data(i,3) = j;
                        end
                    end
                end

                spcc = sort(data(:,5)); % spending on credit card: left skewed
                for i=1:d               %transformation of spending on credit card
                divide_spcc(i) = spcc(floor(l*(i)/d));
                end
                for i = 1:l
                    for j = 1:d
                        if new_data(i,5) == 0 && data(i,5) <= divide_spcc(j)
                            new_data(i,5) = j;
                        end
                    end
                end

                for i = 1:l
                   if data(i,7) ~= 0       % mortage data is dominated by 0's. Therefore, the numerical adata is converted into categorical by if the customer has mortgage => 1, 0 otherwise 
                        new_data(i,7) = 1;
                    end
                end
                for i = 1:l         % categorical data is kept the same, but the personal loan is made the last column
                    new_data(i,4) = data(i,4);
                    new_data(i,6) = data(i,6);
                    new_data(i,8) = data(i,12);
                    new_data(i,9) = data(i,9);
                    new_data(i,10) = data(i,10);
                    new_data(i,11) = data(i,11);
                    new_data(i,12) = data(i,8);
                end

                %data is prepared, beginning of the naive bayes part

                rng(10);
                n = randperm(l);
                for i = 1:l
                    for k = 1:12
                        shuff_data(i,k) = new_data(n(i),k);  %shuffled data
                    end
                end

                trainnum = floor(l*0.8);
                validnum = l-trainnum;
                train_data = shuff_data(1:trainnum,:);         %partition
                valid_data = shuff_data(trainnum+1:l,:);

                count1=1;
                count2=1;
                for i = 1:trainnum
                    if train_data(i,12) == 1
                        for k = 1:12
                            class1_data(count1,k) = train_data(i,k);           % training data is divided into two parts according to personal loan information
                        end
                        count1 = count1+1;
                    else
                        for k = 1:12
                            class2_data(count2,k) = train_data(i,k);
                        end
                        count2 = count2+1;
                    end
                end

                l1 = length(class1_data);
                l2 = length(class2_data);

                prob1 = l1/(l1+l2); %probabilities of each class
                prob2 = l2/(l1+l2);
                predict = zeros(1,validnum);

                for i = 1:validnum          %prediction using naive bayes
                    p1 = zeros(1,11);
                    p2 = zeros(1,11);
                    for j = 1:11
                        p1(1,j) = sum(class1_data(:,j) == valid_data(i,j))/l1;
                        p2(1,j) = sum(class2_data(:,j) == valid_data(i,j))/l2;
                    end
                    pr1 = prod(p1)*prob1;
                    pr2 = prod(p2)*prob2;

                    if pr1 > pr2 
                        predict(1,i) = 1;
                    else 
                        predict(1,i) = 0;
                    end
                end

                errornum = 0;
                for i = 1:validnum 
                    if predict(1,i) ~= valid_data(i,12)
                        errornum = errornum+1;
                    end
                end
                errorrate = errornum*100/validnum;
                
                errors(1,count3) = errorrate;
                errors(2,count3) = a;
                errors(3,count3) = b;
                errors(4,count3) = c;
                errors(5,count3) = d;
                count3 = count3+1;

                
            end
        end
    end
end

[minerror,location] = min(errors(1,:));
besta = errors(2,location);
bestb = errors(3,location);
bestc = errors(4,location);
bestd = errors(5,location);
     
%naive rule
if l1>l2
    predict_naive = ones(1,validnum);
else
    predict_naive = zeros(1,validnum);
end

errornum2 = 0;
for i = 1:validnum 
    if predict_naive(1,i) ~= valid_data(i,12)
        errornum2 = errornum2+1;
    end
end
errorrate2 = errornum2*100/validnum;