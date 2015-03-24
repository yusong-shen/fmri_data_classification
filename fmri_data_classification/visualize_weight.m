%%

addpath '/saves/'
addpath '../library/'
inputSize = 90*90;
hiddenSizeL1 = 200;
hiddenSizeL2 = 200;
numClasses = 2;

% load('saeweights_datasetnum2_1itr.mat')  % ?
%% Visualize the weight of first layer
% for i = 1:10
% data_name = sprintf('C:\\Deep Learning\\fmri_data_classification\\fmri_data_classification\\saves\\saeweights_datasetnum2_%ditr.mat',i);
% load(data_name);
% W1 = reshape(thetas.sae1OptTheta(1:hiddenSizeL1 * inputSize), hiddenSizeL1, inputSize);
% W1_norm = sum(abs(W1).^2).^(1/2);
% W1_norm2 = reshape(W1_norm, 90, 90);
% figure(i);
% imagesc(W1_norm2);
% colorbar
% fig_name = sprintf('w1_%ditr.fig',i);
% savefig(fig_name);
% W1_norm3 = sum(W1_norm2);
% W1_norms(i,:) = W1_norm3; 
% [sorted_val, sorted_ind] = sort(W1_norm3,'descend');
% W1_sorteds(i,:) = sorted_ind;
% % bar(W1_norm3);
% % [val, ind] = max(W1_norm3);
% end

%% Visualize the weight of second layer
for i = 1:10
data_name = sprintf('C:\\Deep Learning\\fmri_data_classification\\fmri_data_classification\\saves\\saeweights_datasetnum2_%ditr.mat',i);
load(data_name);
W11 = reshape(thetas.sae1OptTheta(1:hiddenSizeL1 * inputSize), hiddenSizeL1, inputSize);
W12 = reshape(thetas.sae2OptTheta(1:hiddenSizeL2 * hiddenSizeL1), hiddenSizeL2, hiddenSizeL1);
W2 = (W11'*W12)'; % transpose
W2_norm = sum(abs(W2).^2).^(1/2);
W2_norm2 = reshape(W2_norm, 90, 90);
figure(i);
imagesc(W2_norm2);
colorbar
fig_name = sprintf('w2_%ditr.fig',i);
savefig(fig_name);
W2_norm3 = sum(W2_norm2);
W2_norms(i,:) = W2_norm3; 
[sorted_val, sorted_ind] = sort(W2_norm3,'descend');
W2_sorteds(i,:) = sorted_ind;
% bar(W1_norm3);
% [val, ind] = max(W1_norm3);
end
