function s_dataset = shuffleFMRIDataset( dataset,nfold )
%shuffleFMRIdataset : shuffle the trainingset and testset
%   In order to exam if there is unbalance in the data


if (nargin<5) || isempty(nfold)
    nfold = 2;
end


% Todo
% add some code to record the info of subjects in both training and test
% set

o_dataset = [dataset.trainingset, dataset.testset];
o_labels = [dataset.traininglabels; dataset.testlabels];
m = size(o_dataset,2);
m2 = floor(m/nfold);

rand_ind = randperm(m);
s_dataset.testset = o_dataset(:,rand_ind(1:m2));
s_dataset.testlabels = o_labels(rand_ind(1:m2),:);
s_dataset.trainingset = o_dataset(:,rand_ind(m2+1:m));
s_dataset.traininglabels = o_labels(rand_ind(m2+1:m),:);
s_dataset.inputSize = dataset.inputSize;

end

