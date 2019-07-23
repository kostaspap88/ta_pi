% Template Attacks and Perceived Information for estimation and assumption
% error calculation

% Author: Kostas Papagiannopoulos -- kostaspap88@gmail.com
% Based on papers: "How to certify the leakage of a chip?, Durvaux et al.",
% "Template Attacks, Chari", "Efficient Template Attacks, Choudary et al.",
% "A formal study of power variability issues and side-channel attaks in 
% nanoscale devices, Renauld et al."

%DELETING CAROLINE...GOODBYE CAROLINE
clear all;
close all;


% number of classes to distinguish
no_classes = 9;
% number of samples used in simulation
no_samples = 5;
% number of traces used in simulation per class
no_traces = [100 120 80 90 100 110 85 95 101];
% number of traces used in every attack
traces_per_attack_vector = 1:2;
% POIs used in template building
no_poi_vector = 1:3;

% Dataset simulation
data = cell(no_classes,1);
%e.g. Simulate train data from multivariate normal distribution
for i=1:no_classes
    sim_mean=repmat(i-1,1,no_samples); % mean = 0, 1, 2, 3, etc.
    sim_C = 0.5*eye(no_samples); % variance = 0.5
    data{i} = mvnrnd(sim_mean,sim_C,no_traces(i));
end




% Train-Test set partitioning, Model building and k-fold Cross-validation


% cross-validation factor
cv = 10; % 10-fold cross validation

% initialize matrices
train = cell(no_classes,1);
test = cell(no_classes,1);
me = cell(no_classes,1);
C = cell(no_classes,1);
test_red = cell(no_classes,1);
SR = cell(no_classes,1);
PI = cell(no_classes,1);
mSR = zeros(length(traces_per_attack_vector), length(no_poi_vector));
stdSR = zeros(length(traces_per_attack_vector), length(no_poi_vector));
mPI = zeros(length(traces_per_attack_vector), length(no_poi_vector));
stdPI = zeros(length(traces_per_attack_vector), length(no_poi_vector));

% compute the mean, covariance, success rate for every fold of the cross
% validation, for every choice of number of POIs and for every number of
% traces per attack
c1 = 1;
for traces_per_attack = traces_per_attack_vector
    c2 = 1;
    for no_poi = no_poi_vector
        for k=1:cv
            % split to 10 disjoint train/test sets
            for class=1:no_classes
                interval = linspace(1,no_traces(class), cv+1);
                interval = floor(interval);
                test_index = interval(k):interval(k+1);
                test{class} = data{class}(test_index,:);
                train_index = setdiff(1:no_traces(class), test_index);
                train{class} = data{class}(train_index,:); 
            end
            % perform PCA-based dimensionality reduction
            [me{k}, C{k}, test_red{k}] = dimensionality_reduction(train,test,no_classes,no_samples,no_poi);
            % compute the success rate
            SR{k} = success_rate(me{k}, C{k}, test_red{k}, traces_per_attack);
            % compute the perceived information
            PI{k} = perceived_information(me{k}, C{k}, test_red{k}, no_poi);
        end
        
        % keep the mean SR and PI for every choice 
        mSR(c1, c2) = mean(cell2mat(SR));
        stdSR(c1, c2) = std(cell2mat(SR));  
        
        mPI(c1, c2)=mean(cell2mat(PI));
        stdPI(c1, c2)=std(cell2mat(PI));
        c2 = c2 + 1;
    end
    c1 = c1 + 1;
end

figure;
heatmap(mSR);
figure;
heatmap(mPI);


           





 
                
