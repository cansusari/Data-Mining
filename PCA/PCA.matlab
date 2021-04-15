% Cansu Sari
clear
clc

%part 1
d = xlsread('DataForPCA'); %d keeps the dataset
x = d(:,3:10); %x takes the data of attributes 3 to 10
figure(1)
plotmatrix(x);
%When plotting x, the diagonal gives directly the histogram of each
%attribute. The other scatterplots gives the pairwise relations between the
%attributes. 
%When the pairs includes the second and the third attributes are examined
%clusters can be seen in their plots. 
%Other than that, positive corrolation between the pairs can be observed in
%some of the plots.

%part2
[coeff, trdata, vr, t, perc]   = pca(d);
%using pca, principle component coefficients are kept in the coeff, and the
%transformed data set is kept in trdata.

%part3
%using the pca function, the variance of each variable in the transformed
%data set is already calculated in part 2 and kept in vr. 
%Moreover, the percentage of the variences of the variables are kept in 
%perc.
n=1;
b=perc(n);
while b <= 90
b = b+perc(n+1);
n=n+1;
end
sdata = trdata(:,1:n);
% As the attributes are aligned in a decreasing order according to
%their variences, in other words the information they held, the first n 
%attributes until the sum of their variences reach 90 are selected and kept 
%in sdata.   

%part4
figure(2)
scatter(trdata(:,1),trdata(:,2));
%When the two most informative attributes are plotted, three main clusters
%can be observed.

%part 5
%as can be observed from figure 2, the data includes 3 clusters, i.e. 3 
%groups with more similar characteristics. 
%The reason for this clusters stems from the characteristic of the data
%itself. Our analysis only make it more visible and spottable, but the
%information that is used does not change.
%In figure 1 some clusters were 
%also visible, but it was hard to define the number of clusters and the
%relations between them. Moreover, in figure 1 not all of the data was 
%used. By using the whole original data and pca over it, the observation 
%and further analysis may be eased. 