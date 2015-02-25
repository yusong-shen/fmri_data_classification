%% transform the orginal fmri data to correlation matrix
% version 2 , reduce the redudant code
% origin : 90x130
% correlation matrix : 90x90

% example
% brain_data = zeros(90,90);
% brain_data_corr = corr(AAL019_S_4477_1');
% brain_data_corr1 = brain_data_corr-eye(size(brain_data_corr)); 

%% initialization
clear all; close all;clc

addpath '../library/'

trainingdirpath = 'D:\miniProject\fmri_data_classification\trainingData100';
testdirpath = 'D:\miniProject\fmri_data_classification\testData50';

%% training set
% training_corr_matrix : 8100x99
% labels : 99x1  AD-1,Normal-0
% Todo - reduce the redundant code
% [training_corr_matrix, training_labels] = loadFMRIDataset(trainingdirpath);
% 
% save('training_corr_dataset','training_corr_matrix');
% save('trainingLabels.mat','training_labels');

% [training_matrix, training_labels] = loadFMRIDataset(trainingdirpath, 'fmri');

% save('training_fmri_dataset.mat','training_matrix');
% save('training_fmri_labels.mat','training_labels');

% [training_corr_matrix, training_labels] = loadFMRIDataset(trainingdirpath, 'half');
% 
% save('training_halfcorr_dataset','training_corr_matrix');
% save('training_halfcorr_labels.mat','training_labels');

% 42x42 corr matrix -> 43x21
[training_corr_matrix, training_labels] = loadFMRIDataset(trainingdirpath, 'co42');

save('training_corr42_dataset','training_corr_matrix');
save('training_corr42_labels.mat','training_labels');
%% test set
% [test_corr_matrix, test_labels] = loadFMRIDataset(testdirpath);
% save('test_corr_dataset.mat','test_corr_matrix');
% save('testLabels.mat','test_labels');



% [test_matrix, test_labels] = loadFMRIDataset(testdirpath, 'fmri');

% save('test_fmri_dataset.mat','test_matrix');
% save('test_fmri_labels.mat','test_labels');

% [test_corr_matrix, test_labels] = loadFMRIDataset(testdirpath, 'half');
% 
% save('test_halfcorr_dataset','test_corr_matrix');
% save('test_halfcorr_labels.mat','test_labels');

% 42x42 corr matrix -> 43x21
[test_corr_matrix, test_labels] = loadFMRIDataset(testdirpath, 'co42');

save('test_corr42_dataset','test_corr_matrix');
save('test_corr42_labels.mat','test_labels');