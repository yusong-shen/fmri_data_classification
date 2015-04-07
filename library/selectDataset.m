function dataset = selectDataset( datasetnum )
%selectDataset - load the dataset of specific fmri data formatted
% 
%   
% Input :
% datasetnum
% Number of feature
% 1 - 90x130 = 11700
% 2 - 90x90 = 8100
% 3 - 81x45 = 4005 
% 4 - 41x21 = 861
% Dataset 1 : the original data , 90 rows stand for 90 different brain areas,
%     130 columns stand for 130 sample at different moment, the sampling period is about 10+ms 
% Dataset 2: compute the correlation matrix from the dataset 1, Aij belongs 
%     to [-1,1], which means the correlation coefficient between ith area and jth area. 
%     If Aij close to 1, it means when  area iís blood-oxygen-level dependent(BOLD) increase, 
%     the area jís BOLD also tend to increase with linear relation with area iís.   
% Dataset 3 : Since the correlation matrix is a symmetric matrix, I delete
%     the duplicated symmetry entry from dataset 2, which reduce inputís dimension.
% Dataset 4 : Select 43 sub-area in whole brain network to reduce inputís dimension. 
% 

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

