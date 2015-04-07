function dataset = selectDataset( datasetnum )
%selectDataset Summary of this function goes here
%   Detailed explanation goes here

if datasetnum == 1
    % 90x130 original fmri dataset
    fprintf('90x130 original fmri dataset\n');
    dataset.inputSize = 90*130;
    dataset.trainingset = loadFMRIData('../data/training_fmri_dataset.mat');
    dataset.traininglabels = loadFMRIData('../data/training_fmri_labels.mat');
    dataset.testset = loadFMRIData('../data/test_fmri_dataset.mat');
    dataset.testlabels = loadFMRIData('../data/test_fmri_labels.mat');
elseif datasetnum == 2
    % 90x90 correlation dataset
    fprintf('90x90 correlation dataset\n');
    dataset.inputSize = 90*90;
    dataset.trainingset = loadFMRIData('../data/training_corr_dataset.mat');
    dataset.traininglabels = loadFMRIData('../data/trainingLabels.mat');
    dataset.testset = loadFMRIData('../data/test_corr_dataset.mat');
    dataset.testlabels = loadFMRIData('../data/testLabels.mat');
elseif datasetnum == 3
    % 91x45 correlation dataset by deleting symmetry term
    fprintf('91x45 correlation dataset by deleting symmetry term\n');
    dataset.inputSize = 89*45;
    dataset.trainingset = loadFMRIData('../data/training_halfcorr_dataset.mat');
    dataset.traininglabels = loadFMRIData('../data/training_halfcorr_labels.mat');
    dataset.testset = loadFMRIData('../data/test_halfcorr_dataset.mat');
    dataset.testlabels = loadFMRIData('../data/test_halfcorr_labels.mat');  
elseif datasetnum == 4
    % 90x90 correlation dataset
    fprintf('43x21 correlation dataset\n');
    dataset.inputSize = 41*21;
    dataset.trainingset = loadFMRIData('../data/training_corr42_dataset.mat');
    dataset.traininglabels = loadFMRIData('../data/training_corr42_labels.mat');
    dataset.testset = loadFMRIData('../data/test_corr42_dataset.mat');
    dataset.testlabels = loadFMRIData('../data/test_corr42_labels.mat');
end
dataset.traininglabels(dataset.traininglabels==0) = 2; % Remap 0 to 2
dataset.testlabels(dataset.testlabels==0) = 2; % Remap 0 to 2

end

