%% svm for fMRI data classification



%% use original data
datasetnum = 1;
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


%% use new 51 data

dataPath = '../data/corr_60.mat';
[ predict_label, accuracy, dec_values, model_lin ] = svmIteration( dataPath , kfold);

%% use 5 selected features from other paper
datasetnum = 2;
kfold = 5;
dataset = selectDataset( datasetnum );
% selected features
% 5 features
% region : 1 - 90 , 90*(x-1)+y
% Decresed: (3,10) (7,10) (47,83)
% 190, 550, 4223
% Incresed: (33,64) (63,85)
% 2944, 5665
% 
% Xiaowei, Z. (n.d.). Resting-State Whole-Brain Functional Connectivity 
% Networks for MCI Classification Using L2-Regularized Logistic Regression.
features = [190, 550, 4223, 2944, 5665];

for i = 1:kfold
    s_dataset = shuffleFMRIDataset( dataset, kfold);
    % data :  #samples x # features
    % labels : #samples x 1
    inputSize = 5;
    train_data = s_dataset.trainingset';
    train_data = train_data(:,features);
    train_label = s_dataset.traininglabels;
    test_data = s_dataset.testset';
    test_data = test_data(:,features);
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


