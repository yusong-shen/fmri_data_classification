%% Data Cleaning

% Todo

dirpath = '/Users/yusong/Code/ADNI_AALTC_DATA_60';
datatype_list = {'corr','fmri','half','co42'};
test_portion = 0.1;
for i = 1:2
    % convert cell to string by using char()
    datatype = char(datatype_list(i));
    [ dataset,labels, inputSize] = loadFMRIDataset( dirpath,datatype);

    new_dataset = splitDataset( dataset,labels,inputSize,test_portion );

%% save the dataset to ./data folder
% Todo
    file_name = strcat('../data/',datatype, '_60.mat');
    save(file_name, 'new_dataset');

end
