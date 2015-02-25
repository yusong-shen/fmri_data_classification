%% CS294A/CS294W Softmax Exercise

%  Instructions
%  ------------
%
%  This file contains code that helps you get started on the
%  softmax exercise. You will need to write the softmax cost function
%  in softmaxCost.m and the softmax prediction function in softmaxPred.m.
%  For this exercise, you will not need to change any code in this file,
%  or any other files other than those mentioned above.
%  (However, you may be required to do so in later exercises)

addpath '../library/'

%%======================================================================
%% STEP 0: Initialise constants and parameters
%
%  Here we define and initialise some constants which allow your code
%  to be used more generally on any arbitrary input.
%  We also initialise some parameters used for tuning the model.

% choose dataset
datasetnum = 4;

if datasetnum == 1
    % 90x130 original fmri dataset
    fprintf('90x130 original fmri dataset');
    inputSize = 90*130;
    training_data = loadFMRIData('../data/training_fmri_dataset.mat');
    training_labels = loadFMRIData('../data/training_fmri_labels.mat');
    test_data = loadFMRIData('../data/test_fmri_dataset.mat');
    test_labels = loadFMRIData('../data/test_fmri_labels.mat');
elseif datasetnum == 2
    % 90x90 correlation dataset
    fprintf('90x90 correlation dataset');
    inputSize = 90*90;
    training_data = loadFMRIData('../data/training_corr_dataset.mat');
    training_labels = loadFMRIData('../data/trainingLabels.mat');
    test_data = loadFMRIData('../data/test_corr_dataset.mat');
    test_labels = loadFMRIData('../data/testLabels.mat');
elseif datasetnum == 3
    % 91x45 correlation dataset by deleting symmetry term
    fprintf('91x45 correlation dataset by deleting symmetry term');
    inputSize = 91*45;
    training_data = loadFMRIData('../data/training_halfcorr_dataset.mat');
    training_labels = loadFMRIData('../data/training_halfcorr_labels.mat');
    test_data = loadFMRIData('../data/test_halfcorr_dataset.mat');
    test_labels = loadFMRIData('../data/test_halfcorr_labels.mat');  
elseif datasetnum == 4
    % 90x90 correlation dataset
    fprintf('43x21 correlation dataset');
    inputSize = 43*21;
    training_data = loadFMRIData('../data/training_corr42_dataset.mat');
    training_labels = loadFMRIData('../data/training_corr42_labels.mat');
    test_data = loadFMRIData('../data/test_corr42_dataset.mat');
    test_labels = loadFMRIData('../data/test_corr42_labels.mat');
end
training_labels(training_labels==0) = 2; % Remap 0 to 2
test_labels(test_labels==0) = 2; % Remap 0 to 2

numClasses = 2;     % Number of classes (MNIST images fall into 10 classes)

% lambda = 1e-4; % Weight decay parameter
% Todo : validation
lambda = 1e-4; % Weight decay parameter

%%======================================================================
%% STEP 1: Load data
%
%  In this section, we load the input and output data.
%  For softmax regression on MNIST pixels,
%  the input data is the images, and
%  the output data is the labels.
%

% Change the location of the files to the directory where you
% have saved them


inputData = training_data;

% For debugging purposes, you may wish to reduce the size of the input data
% in order to speed up gradient checking.
% Here, we consider only 8 pixels of the images, and only the first 100
% images.
DEBUG = false; % Set DEBUG to true when debugging.
if DEBUG
    inputSize = 8;
    % only 100 datapoints
    inputData = inputData(:, 1:100);
    [nop, i] = sort(var(inputData, 0, 2), 'descend');
    indices = i(1:inputSize);
    % only top inputSize most-varying input elements (pixels)
    inputData = inputData(indices, :);
    labels = labels(1:100);
end

% Randomly initialise theta
theta = 0.005 * randn(numClasses * inputSize, 1);

%%======================================================================
%% STEP 2: Implement softmaxCost
%
%  Implement softmaxCost in softmaxCost.m.

[cost, grad] = softmaxCost(theta, numClasses, inputSize, lambda, inputData, training_labels);

% %%======================================================================
% %% STEP 3: Gradient checking
% %
% %  As with any learning algorithm, you should always check that your
% %  gradients are correct before learning the parameters.
% %
%
% numGrad = computeNumericalGradient( @(x) softmaxCost(x, numClasses, ...
%                                     inputSize, lambda, inputData, labels), theta);
%
% % Use this to visually compare the gradients side by side
% disp([numGrad grad]);
%
% % Compare numerically computed gradients with those computed analytically
% diff = norm(numGrad-grad)/norm(numGrad+grad);
% disp(diff);
% % The difference should be small.
% % In our implementation, these values are usually less than 1e-7.
%
% % When your gradients are correct, congratulations!

%%======================================================================
%% STEP 4: Learning parameters
%
%  Once you have verified that your gradients are correct,
%  you can start training your softmax regression code using softmaxTrain
%  (which uses minFunc).

options.maxIter = 100;
softmaxModel = softmaxTrain(inputSize, numClasses, lambda, ...
                            inputData, training_labels, options);

% Although we only use 100 iterations here to train a classifier for the
% MNIST data set, in practice, training for more iterations is usually
% beneficial.

% Training Accuracy
% You will have to implement softmaxPredict in softmaxPredict.m
[pred] = softmaxPredict(softmaxModel, inputData);

acc = mean(training_labels(:) == pred(:));
fprintf('Training Accuracy: %0.3f%%\n', acc * 100);

%%======================================================================
%% STEP 5: Testing
%
%  You should now test your model against the test images.
%  To do this, you will first need to write softmaxPredict
%  (in softmaxPredict.m), which should return predictions
%  given a softmax model and the input data.





inputData = test_data;

% You will have to implement softmaxPredict in softmaxPredict.m
[pred] = softmaxPredict(softmaxModel, inputData);

acc = mean(test_labels(:) == pred(:));
fprintf('Test Accuracy: %0.3f%%\n', acc * 100);

% Accuracy is the proportion of correctly classified images
% After 100 iterations, the results for our implementation were:
%
% Accuracy: 92.200%
%
% If your values are too low (accuracy less than 0.91), you should check
% your code for errors, and make sure you are training on the
% entire data set of 60000 28x28 training images
% (unless you modified the loading code, this should be the case)
