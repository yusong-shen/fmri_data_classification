function [ s_trainingset,s_traininglabels,s_testset,s_testlabels ] = shuffleFMRIDataset( trainingset,traininglabels,testset,testlabels,nfold )
%shuffleFMRIdataset : shuffle the trainingset and testset
%   In order to exam if there is unbalance in the data

if (nargin<5) || isempty(nfold)
    nfold = 2;
end


% Todo
% add a argument that control the portion between training set and test set 
% the dataset structure as follows - n x m
% where n is the number of feature per sample, m is the number of samples
% the labels structure as follows - m x 1

% randperm(n)?
dataset = [trainingset, testset];
labels = [traininglabels; testlabels];
n_feat = size(dataset,1);
m = size(dataset,2);
m2 = floor(m/nfold);

rand_ind = randperm(m);
s_testset = dataset(:,rand_ind(1:m2));
s_testlabels = labels(rand_ind(1:m2),:);
s_trainingset = dataset(:,rand_ind(m2+1:m));
s_traininglabels = labels(rand_ind(m2+1:m),:);

end

