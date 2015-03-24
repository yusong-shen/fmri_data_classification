function  [bestlambda, bestbeta, valacc]  = validateSAE( lambda_list,beta_list, ...
    inputSize, training_data, training_labels, kfold )
% validation for Stacked Autoencoder
% for two hyperparameters: weight decay-lambda, weight of sparse penalty term- beta 
% assuming that we know the network structure

% update by 11th Mar,2015: modified from validateSoftmax
%

%% model selection by validating
% initialize parameter
parameters.numClasses = 2;
parameters.hiddenSizeL1 = 200;    % Layer 1 Hidden Size
parameters.hiddenSizeL2 = 200;    % Layer 2 Hidden Size
parameters.sparsityParam = 0.1;   % desired average activation of the hidden units.
                       % (This was denoted by the Greek alphabet rho, which looks like a lower-case "p",
		               %  in the lecture notes).
% parameters.lambda = 3e-3;         % weight decay parameter
% parameters.beta = 3;              % weight of sparsity penalty term
parameters.inputSize = inputSize;
n_lambda = size(lambda_list,2);
arg_list = zeros(n_lambda,1);
trainacc_list = zeros(n_lambda,1);
valacc_list = zeros(n_lambda,1);
numSample = size(training_data,2);
% kfold = 10;


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
valacc = 1/kfold*sum(valacc_k(:));
% trainacc = 1/kfold/lambda*sum(trainacc_list(:));

% [trainacc, testacc] = softmaxFMRI( bestlambda, range ,inputSize, ...
%     training_data, training_labels, ...
%     test_data, test_labels);
% fprintf('Train Accuracy by best validation prameter: %0.3f\n', trainacc);
% fprintf('Test Accuracy by best validation prameter: %0.3f\n', testacc);


% %% plot
% figure;
% semilogx(lambda_list,max(valacc_list,[],2)','-.or','MarkerFaceColor','g');
% str = sprintf('validation accuracy with different lambda,datasetnum:%d, %d-fold',datasetnum,kfold);
% title(str);
% xlabel('lambada');
% ylabel('validation accuracy');
end

