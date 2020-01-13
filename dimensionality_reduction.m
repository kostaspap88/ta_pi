function [me, C, test_red] = dimensionality_reduction(train,test, no_classes, no_samples,m)

% Dimensionality reduction using PCA

% mean/covariance computation for every class
me_class = zeros(no_samples,no_classes);
for i=1:no_classes
    me_class(:,i)=mean(train{i});
end   
% mean of all classes
mean_total= mean(me_class,2);

% compute matrix B
B_temp=zeros(size(mean_total,1));
for i=1:no_classes
    B_temp = B_temp+(me_class(:,i)-mean_total)*(me_class(:,i)-mean_total)';
end
B = (1/no_classes)*B_temp; 

% singular value decomposition
[U,S,V] = svd(B);
Ur = U(:,1:m);

% Reduce the dimension of train dataset and estimate the mean
% vector and the covariance matrix  
train_red = cell(no_classes,1);
me = zeros(m,no_classes);
C = zeros(m, m, no_classes);
for i=1:no_classes
    train_red{i}=train{i}*Ur;
    me(:,i)=mean(train_red{i});
    C(:,:,i)=cov(train_red{i}); 
end

% Reduce the dimension of the test set
test_red = cell(no_classes,1);
for i=1:no_classes
    test_red{i}=test{i}*Ur;
end
 

end