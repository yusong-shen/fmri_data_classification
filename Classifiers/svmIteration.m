function [ predict_label, accuracy, dec_values, model_lin ] = svmIteration( dataPath , kfold)
%svmIteration Iterate k times for fMRI data by SVM 
% return the model and prediction result

% variable called new_dataset
load(dataPath);


for i = 1:kfold
    s_dataset = shuffleFMRIDataset( new_dataset, kfold);
    % data :  #samples x # features
    % labels : #samples x 1
    inputSize = s_dataset.inputSize;
    train_data = s_dataset.trainingset';
    train_label = s_dataset.traininglabels;
    test_data = s_dataset.testset';
    test_label = s_dataset.testlabels;

    % -t kernel_type : set type of kernel function (default 2)
    % 	0 -- linear: u'*v
    % 	1 -- polynomial: (gamma*u'*v + coef0)^degree
    % 	2 -- radial basis function: exp(-gamma*|u-v|^2)
    % 	3 -- sigmoid: tanh(gamma*u'*v + coef0)

    % % linear kernel
    model_lin = svmtrain(train_label, train_data, '-t 0');
    [train_predict, train_accu, train_dec_values] = ...
        svmpredict(train_label, train_data, model_lin);

    [predict_label, accuracy, dec_values] = ...
        svmpredict(test_label, test_data, model_lin);
    
end

end

