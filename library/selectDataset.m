function [ inputSize, training_data, training_labels, test_data, test_labels] = selectDataset( datasetnum )
%selectDataset Summary of this function goes here
%   Detailed explanation goes here

if datasetnum == 1
    % 90x130 original fmri dataset
    fprintf('90x130 original fmri dataset\n');
    inputSize = 90*130;
    training_data = loadFMRIData('../data/training_fmri_dataset.mat');
    training_labels = loadFMRIData('../data/training_fmri_labels.mat');
    test_data = loadFMRIData('../data/test_fmri_dataset.mat');
    test_labels = loadFMRIData('../data/test_fmri_labels.mat');
elseif datasetnum == 2
    % 90x90 correlation dataset
    fprintf('90x90 correlation dataset\n');
    inputSize = 90*90;
    training_data = loadFMRIData('../data/training_corr_dataset.mat');
    training_labels = loadFMRIData('../data/trainingLabels.mat');
    test_data = loadFMRIData('../data/test_corr_dataset.mat');
    test_labels = loadFMRIData('../data/testLabels.mat');
elseif datasetnum == 3
    % 91x45 correlation dataset by deleting symmetry term
    fprintf('91x45 correlation dataset by deleting symmetry term\n');
    inputSize = 91*45;
    training_data = loadFMRIData('../data/training_halfcorr_dataset.mat');
    training_labels = loadFMRIData('../data/training_halfcorr_labels.mat');
    test_data = loadFMRIData('../data/test_halfcorr_dataset.mat');
    test_labels = loadFMRIData('../data/test_halfcorr_labels.mat');  
elseif datasetnum == 4
    % 90x90 correlation dataset
    fprintf('43x21 correlation dataset\n');
    inputSize = 43*21;
    training_data = loadFMRIData('../data/training_corr42_dataset.mat');
    training_labels = loadFMRIData('../data/training_corr42_labels.mat');
    test_data = loadFMRIData('../data/test_corr42_dataset.mat');
    test_labels = loadFMRIData('../data/test_corr42_labels.mat');
end
training_labels(training_labels==0) = 2; % Remap 0 to 2
test_labels(test_labels==0) = 2; % Remap 0 to 2

end

