%% build the index of each person's brain network data

ADfolder = 'AD_LMCI';
Normfolder = 'Norm';
trainingdirpath = 'C:\Deep Learning\fmri_data_classification\trainingData100';
testdirpath = 'C:\Deep Learning\fmri_data_classification\testData50';

trainingfolderADname = strcat(trainingdirpath,'/',ADfolder);
trainingfolderNormname = strcat(trainingdirpath,'/',Normfolder);
testfolderADname = strcat(testdirpath,'/',ADfolder);
testfolderNormname = strcat(testdirpath,'/',Normfolder);

%% training folder
% trainingfolderAD = dir(strcat(trainingfolderADname,'/*.mat'));
% num_train_AD = length(trainingfolderAD);
% trainingfolderNorm = dir(strcat(trainingfolderADname,'/*.mat'));
% num_train_Norm = length(trainingfolderNorm);
% 
% dict_training = cell(num_train_AD+num_train_Norm,1);
% 
% for i = 1:num_train_AD
%     filename = trainingfolderAD(i).name;
%     filename = filename(1:end-4);
%     dict_training{i,1} = filename;
% end
% 
% 
% for i = 1:num_train_Norm
%     filename = trainingfolderNorm(i).name;
%     filename = filename(1:end-4);
%     dict_training{num_train_AD+i,1} = filename;
% end
% 
% save('dict_training.mat','dict_training');

%% test folder
testfolderAD = dir(strcat(testfolderADname,'/*.mat'));
num_test_AD = length(testfolderAD);
testfolderNorm = dir(strcat(testfolderNormname,'/*.mat'));
num_test_Norm = length(testfolderNorm);

dict_test = cell(num_test_AD+num_test_Norm,1);

for i = 1:num_test_AD
    filename = testfolderAD(i).name;
    filename = filename(1:end-4);
    dict_test{i,1} = filename;
end


for i = 1:num_test_Norm
    filename = testfolderNorm(i).name;
    filename = filename(1:end-4);
    dict_test{num_test_AD+i,1} = filename;
end

save('dict_test.mat','dict_test');