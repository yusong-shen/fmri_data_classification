function [ output_args ] = shuffleDataForSoftmax2( lambda, range ,datasetnum, nfold, itr )
% shuffle data for FMRI softmax regression
%
%

% % choose dataset
% datasetnum = 2;
% nfold = 5;
% lambda = 1e-4; % Weight decay parameter
% range = 0.005; % initial weight magnitude
% itr = 10;  
% trainacc_list = zeros(itr,1);
% testacc_list = zeros(itr,1);

for i =1:itr    
    [trainacc, testacc] = shuffleSoftmaxFMRI2( lambda, range ,datasetnum, nfold);
    trainacc_list(i) = trainacc;
    testacc_list(i) = testacc;
end

trainacc = 1/itr*sum(trainacc_list(:));
testacc = 1/itr*sum(testacc_list(:));
end

