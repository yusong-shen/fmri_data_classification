%% transform the orginal fmri data to correlation matrix
% origin : 90x130
% correlation matrix : 90x90

% example
% brain_data = zeros(90,90);
% brain_data_corr = corr(AAL019_S_4477_1');
% brain_data_corr1 = brain_data_corr-eye(size(brain_data_corr)); 


trainingFolderAD = dir('../trainingData100/AD_LMCI/*.mat');
trainingFolderNorm = dir('../trainingData100/Norm/*.mat');
testFolderAD = dir('../testData50/AD_LMCI/*.mat');
testFolderNorm = dir('../testData50/Norm/*.mat');

%% training set
% training_corr_matrix : 8100x99
% labels : 99x1  AD-1,Normal-0
% Todo - reduce the redundant code
trainingPathAD = '../trainingData100/AD_LMCI';
training_corr_matrix1 = zeros(90*90, length(trainingFolderAD)); 
for i = 1:length(trainingFolderAD)
    filename = fullfile(trainingPathAD, trainingFolderAD(i).name);
    fmri_data = load(filename); % struct
    brain_data = zeros(90,90);
    variables = fieldnames(fmri_data); % lists of key
    data = fmri_data.(variables{1});
    brain_data_corr = corr(data');
    brain_data_corr = (brain_data_corr-eye(size(brain_data_corr)));
    brain_data_corr = brain_data_corr(:) ; % column vector
    training_corr_matrix1(:,i) = brain_data_corr;
    
end

trainingPathNorm = '../trainingData100/Norm';
training_corr_matrix2 = zeros(90*90, length(trainingFolderNorm)); 
for i = 1:length(trainingFolderNorm)
    filename = fullfile(trainingPathNorm, trainingFolderNorm(i).name);
    fmri_data = load(filename); % struct
    brain_data = zeros(90,90);
    variables = fieldnames(fmri_data); % lists of key
    data = fmri_data.(variables{1});
    brain_data_corr = corr(data');
    brain_data_corr = (brain_data_corr-eye(size(brain_data_corr)));
    brain_data_corr = brain_data_corr(:) ; % column vector
    training_corr_matrix2(:,i) = brain_data_corr;
    
end

training_corr_matrix = [training_corr_matrix1, training_corr_matrix2];
save('training_corr_dataset','training_corr_matrix');
num_ad = length(trainingFolderAD);
num_norm = length(trainingFolderNorm);
trainingLabels = [ones(num_ad,1);zeros(num_norm,1)];
save('trainingLabels.mat','trainingLabels');

%% test set

testPathAD = '../testData50/AD_LMCI';
test_corr_matrix1 = zeros(90*90, length(testFolderAD)); 
for i = 1:length(testFolderAD)
    filename = fullfile(testPathAD,testFolderAD(i).name);
    fmri_data = load(filename); % struct
    brain_data = zeros(90,90);
    variables = fieldnames(fmri_data); % lists of key
    data = fmri_data.(variables{1});
    brain_data_corr = corr(data');
    brain_data_corr = (brain_data_corr-eye(size(brain_data_corr)));
    brain_data_corr = brain_data_corr(:) ; % column vector
    test_corr_matrix1(:,i) = brain_data_corr;
    
end

testPathNorm = '../testData50/Norm';
test_corr_matrix2 = zeros(90*90, length(testFolderNorm)); 
for i = 1:length(testFolderNorm)
    filename = fullfile(testPathNorm, testFolderNorm(i).name);
    fmri_data = load(filename); % struct
    brain_data = zeros(90,90);
    variables = fieldnames(fmri_data); % lists of key
    data = fmri_data.(variables{1});
    brain_data_corr = corr(data');
    brain_data_corr = (brain_data_corr-eye(size(brain_data_corr)));
    brain_data_corr = brain_data_corr(:) ; % column vector
    test_corr_matrix2(:,i) = brain_data_corr;
    
end

test_corr_matrix = [test_corr_matrix1, test_corr_matrix2];
save('test_corr_dataset.mat','test_corr_matrix');
testLabels = [ones(30,1);zeros(20,1)];
save('testLabels.mat','testLabels');
 
