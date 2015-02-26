%% validation for softmax
%
clear all;close all;clc;


% model selection by validating
lambda_list = [1,1e-1,1e-2,1e-3,1e-4,1e-5];
range_list = [5e-4,0.001,0.005,0.01,0.05,0.1,0.5,1];
n_lambda = size(lambda_list,2);
n_range = size(range_list,2);
arg_list = zeros(n_lambda,n_range);
trainacc_list = zeros(n_lambda,n_range);
testacc_list = zeros(n_lambda,n_range);
datasetnum = 4;

for i = 1:n_lambda
    for j = 1:n_range
        lambda = lambda_list(i);
        range = range_list(j);
        [trainacc, testacc] = softmaxFMRI( lambda, range, datasetnum);
        trainacc_list(i,j) = trainacc;
        testacc_list(i,j) = testacc;
    end
end

[bestacc, bestind ] = max(testacc_list(:));
[besti, bestj] = ind2sub(size(testacc_list),bestind);
bestlambda = lambda_list(besti);
bestrange = range_list(bestj);

%% plot
figure;
plot(lambda_list,max(testacc_list,[],2)');
title('test acc with different lambda');
figure;
plot(range_list,max(testacc_list,[],1));
title('test acc with different initial range');
