%% Data Cleaning

datatype_list = {'corr','fmri','half','co42'};
[ dataset,labels, inputSize] = loadFMRIDataset( dirpath,datatype);

new_dataset = splitDataset( dataset,labels,inputSize,test_portion );


%% save the dataset to ./data folder

