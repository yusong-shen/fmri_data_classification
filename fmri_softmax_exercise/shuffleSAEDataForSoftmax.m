%% shuffle data for FMRI softmax regression
%
% initilize
close all;clear all;clc

% choose dataset
% use the exact same dataset in SAE to Softmax regression
% 
addpath '..\library'
addpath '..\library\minFunc'

for datasetnum = 2:2
kfold = 10;
% lambda_list = [1e-2,1e-3,1e-4,1e-5];
lambda_list = [1,1e-2,1e-3,1e-4,1e-5,1e-6]; % Weight decay parameter
range = 0.005; % initial weight magnitude
trainacc_list = zeros(kfold,1);
testacc_list = zeros(kfold,1);
valacc_list = zeros(kfold,1);
bestlambda_list = zeros(kfold,1);

% choose dataset
% [ inputSize, trainingset, traininglabels, testset, testlabels] = ...
inputSize = selectDataset( datasetnum ); 

    % validation
    % choose the best lambda
    for i =1:kfold    
        % randomly partition the dataset to 10 subsets,
        % 9 for training, 1 for testing
        data_name = sprintf('dataset_%d_%ditr.mat',datasetnum,i);
        load(strcat('../data/dataset2/',data_name));
%         [ s_trainingset,s_traininglabels,s_testset,s_testlabels,s_ind1,s_ind2 ] = ...
%         shuffleFMRIDataset( trainingset,traininglabels,testset,testlabels, kfold);
%         data_order = sprintf('saves/data_order_dataset%d_%ditr.mat',datasetnum, i);
%         save(data_order, 's_ind1', 's_ind2');
        % validateSoftmax2 will further randomly partition the training set
        % to 10 subset, 9 for training , 1 for validating
        % choose the bestlambda by average 10 accuracy
        [bestlambda,valacc]  = validateSoftmax2( lambda_list, inputSize, ...
            s_trainingset, s_traininglabels, kfold );
        valacc_list(i) = valacc;
        bestlambda_list(i) = bestlambda;

        % testing
        % why is testing accuracy higher than validation accuracy ?  -_-
        %
        [trainacc, testacc, softmaxModel] = softmaxFMRI( bestlambda, range ,inputSize, ...
        s_trainingset, s_traininglabels, ...
        s_testset, s_testlabels);
        trainacc_list(i) = trainacc;
        testacc_list(i) = testacc;
        filename = sprintf('saves/softmaxModel_datasetnum%d_%ditr.mat',datasetnum,i);
        save(filename,'softmaxModel');

    end

%% average the k times' test accuracy to reduce the bias 
valacc = 1/kfold*sum(valacc_list(:));
trainacc = 1/kfold*sum(trainacc_list(:));
testacc = 1/kfold*sum(testacc_list(:));

acc_file = sprintf('saves/accuracy_dataset_%d.mat',datasetnum);
save(acc_file,'valacc', 'valacc_list', 'trainacc', 'trainacc_list', 'testacc', ...
    'testacc_list');


%% plot
% Todo 
figure;
subplot(2,1,1);
h1 = plot(1:kfold,trainacc_list,'-.or','MarkerFaceColor','g');
hold all
h2 = plot(1:kfold,valacc_list,'-.og','MarkerFaceColor','r');
h3 = plot(1:kfold,testacc_list,'-.oy','MarkerFaceColor','b');
h4 = plot(1:kfold,repmat(testacc,kfold,1));
h5 = plot(1:kfold,repmat(valacc,kfold,1),'Color','k');
hold off
legend([h1,h2,h3,h4,h5],'training accuracy','validation accuracy','testing accuracy',...
    'average testing accuracy','average validation accuracy');
str = sprintf('training,validation and testing accuracy,datasetnum:%d, %d-fold',datasetnum,kfold);
title(str);
xlabel('the nth time of iteration');
ylabel(' accuracy');

subplot(2,1,2);
% figure;
semilogy(1:kfold,bestlambda_list,'-.or','MarkerFaceColor','g');
str = sprintf('best lambda,datasetnum:%d, %d-fold',datasetnum,kfold);
title(str);
xlabel('the nth time of iteration');
ylabel('lambda');
figname = sprintf('saves/test_result_dataset_%d.fig',datasetnum);
savefig(figname);
end



