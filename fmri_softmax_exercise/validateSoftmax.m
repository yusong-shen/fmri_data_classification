%% validation for softmax
%
% update : delete the range list
%

clear all;close all;clc;



% model selection by validating
lambda_list = [1,1e-2,1e-3,1e-4,1e-5,1e-6];
% range_list = [5e-4,0.001,0.005,0.01,0.05,0.1];
range = 0.005;
n_lambda = size(lambda_list,2);
% n_range = size(range_list,2);
arg_list = zeros(n_lambda,1);
trainacc_list = zeros(n_lambda,1);
valacc_list = zeros(n_lambda,1);
datasetnum = 2;
[ inputSize, training_data, training_labels, test_data, test_labels] = ...
    selectDataset( datasetnum );
numSample = size(training_data,2);
kfold = 10;

% Todo
% 1. use crossvalind() function to split the trainingset to new trainingset
% and validation set
% 2. modify this function's structure, make the selectdataset part out of
% function - Done
trainacc_k = zeros(kfold,1);
valacc_k = zeros(kfold,1);
for i = 1:n_lambda
    for k = 1:kfold
        indices = crossvalind('Kfold',numSample,kfold);
        val_set_index = (indices == 1);
        train_set_index = ~val_set_index;
        lambda = lambda_list(i);
        [trainacc, valacc] = softmaxFMRI( lambda, range ,inputSize, ...
            training_data(:,train_set_index), training_labels(train_set_index,:), ...
            training_data(:,val_set_index), training_labels(val_set_index,:));
        trainacc_k(k) = trainacc;
        valacc_k(k) = valacc;
    end
    trainacc_list(i,1) = 1/kfold*sum(trainacc_k(:));
    valacc_list(i,1) = 1/kfold*sum(valacc_k(:));
end

[bestacc, bestind ] = max(valacc_list(:));
[besti, bestj] = ind2sub(size(valacc_list),bestind);
bestlambda = lambda_list(besti);
% bestrange = range_list(bestj);

[trainacc, testacc] = softmaxFMRI( bestlambda, range ,inputSize, ...
    training_data, training_labels, ...
    test_data, test_labels);
fprintf('Train Accuracy by best validation prameter: %0.3f\n', trainacc);
fprintf('Test Accuracy by best validation prameter: %0.3f\n', testacc);


%% plot
figure;
semilogx(lambda_list,max(valacc_list,[],2)','-.or','MarkerFaceColor','g');
str = sprintf('validation accuracy with different lambda,datasetnum:%d, %d-fold',datasetnum,kfold);
title(str);
xlabel('lambada');
ylabel('validation accuracy');
