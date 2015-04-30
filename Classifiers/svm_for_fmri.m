%% svm for fMRI data classification


%% data
datasetnum = 2;
kfold = 5;
dataset = selectDataset( datasetnum );

for i = 1:kfold
    s_dataset = shuffleFMRIDataset( dataset, kfold);
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
    % model_linear = svmtrain(train_label, train_data, '-t 0');
    % [predict_label, accuracy, dec_values_L] = ...
    %     svmpredict(test_label, test_data, model_linear);

    % radius kernel
    model_rad = svmtrain(train_label, train_data, '-t 0');
    [train_predict, train_accu, train_dec_values] = ...
        svmpredict(train_label, train_data, model_rad);

    [predict_label, accuracy, dec_values] = ...
        svmpredict(test_label, test_data, model_rad);
    
end
