function [ new_dataset ] = splitDataset( dataset,labels,inputSize,test_portion )
%splitDataset
%

% e.g. dataset : 8100 x 164, labels : 164 x 1
% test_portion = 0.1 --> testset : 8100x17 
% trainingset : 8100 x 147

n = size(dataset, 2);
n_test = ceil(n * test_portion);

new_dataset.testset = dataset(:,1:n_test);
new_dataset.testlabels = labels(1:n_test,:);
new_dataset.trainingset = dataset(:,n_test+1:end);
new_dataset.traininglabels = labels(n_test+1:end,:);
new_dataset.inputSize = inputSize;

end

