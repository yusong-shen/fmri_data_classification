function [ dataset,labels ] = loadFMRIDataset( dirpath,datatype,ADfolder,Normfolder )
%loading FMRI dataset from a directory
%   Detailed explanation goes here

% set default arguments
if (nargin<2) || isempty(datatype)
    datatype = 'corr';
end

if (nargin<3) || isempty(ADfolder)
    ADfolder = 'AD_LMCI';
end

if (nargin<4) || isempty(Normfolder)
    Normfolder = 'Norm';
end

%% transform the orginal fmri data to correlation matrix
% origin : 90x130
% correlation matrix : 90x90

% example
% brain_data = zeros(90,90);
% brain_data_corr = corr(AAL019_S_4477_1');
% brain_data_corr1 = brain_data_corr-eye(size(brain_data_corr)); 



folderADname = strcat(dirpath,'/',ADfolder);
folderNormname = strcat(dirpath,'/',Normfolder);


% training_corr_matrix : 8100x99
% labels : 99x1  AD-1,Normal-0
% Todo - reduce the redundant code
if datatype == 'corr'
    matrix1 = computeCorrMatrix(folderADname);
    matrix2 = computeCorrMatrix(folderNormname);
    fprintf('compute 90x90 corr dataset successfully\n');
elseif datatype == 'fmri'
    matrix1 = catMatrix(folderADname);
    matrix2 = catMatrix(folderNormname);
    fprintf('compute 90x130 fmri dataset successfully\n');
elseif datatype == 'half'
    matrix1 = computeHalfCorrMatrix(folderADname);
    matrix2 = computeHalfCorrMatrix(folderNormname);   
    fprintf('compute 91x45 corr half dataset successfully\n');
elseif datatype == 'co42'
    smallarea = true;
    matrix1 = computeHalfCorrMatrix(folderADname,smallarea);
    matrix2 = computeHalfCorrMatrix(folderNormname,smallarea);
    fprintf('compute 43x21 corr half sub dataset successfully\n');
end

dataset = [matrix1, matrix2];
num_ad = size(matrix1,2);
num_norm = size(matrix2,2);
labels = [ones(num_ad,1);zeros(num_norm,1)];


end

function corr_matrix = computeCorrMatrix(folderpath)
% Compute a set of correlation matrix
% 

folder = dir(strcat(folderpath,'/*.mat'));
num = length(folder);

    
for i = 1:num
    filename = fullfile(folderpath, folder(i).name);
    fmri_data = load(filename); % struct
    brain_data = zeros(90,90);
    variables = fieldnames(fmri_data); % lists of key
    data = fmri_data.(variables{1});
    brain_data_corr = corr(data');
    brain_data_corr = (brain_data_corr-eye(size(brain_data_corr)));
    brain_data_corr = brain_data_corr(:) ; % column vector
    corr_matrix(:,i) = brain_data_corr;
   
    
end

end

function dataset = catMatrix(folderpath)
% Concatenate a set of brain network matrix
% 
folder = dir(strcat(folderpath,'/*.mat'));
num = length(folder);
dataset = zeros(90*130, num); 
for i = 1:num
    filename = fullfile(folderpath, folder(i).name);
    fmri_data = load(filename); % struct
    variables = fieldnames(fmri_data); % lists of key
    data = fmri_data.(variables{1}); % 90x130 
    dataset(:,i) = data(:); % column vector
   
end

end

function corr_matrix = computeHalfCorrMatrix(folderpath, smallarea)
% Compute a set of correlation matrix and delete sysmetry entry
% smallarea should be a bool value, true--> 42*42

% set default arguments
if (nargin<2) || isempty(smallarea)
    smallarea = false;
end
% Todo : loading 42 area per brain only
AD_ROI_index = [3,4,7,8,23,24,25,26,27,28,31,32, 59,60,61,62,67,68,35,36, ...
    49,50,51,52,53,54, 81,82,83,84,85,86,87,88,89,90,55,56,37,38,39,40];
m = size(AD_ROI_index,2);

folder = dir(strcat(folderpath,'/*.mat'));
num = length(folder);
if smallarea == false
    corr_matrix = zeros(91*45, num);
else
    corr_matrix = zeros((m+1)*m/2, num);
end

for i = 1:num
    filename = fullfile(folderpath, folder(i).name);
    fmri_data = load(filename); % struct
    variables = fieldnames(fmri_data); % lists of key
    data = fmri_data.(variables{1});
    if smallarea == true
        data = data(AD_ROI_index,:);
    end
    brain_data_corr = corr(data');
    brain_data_corr = (brain_data_corr-eye(size(brain_data_corr)));
    % Todo -- change symmetry matrix to vector which don't contain
    % duplicate term
    brain_data_corr_half = deleteSymmetry(brain_data_corr) ; % column vector
    corr_matrix(:,i) = brain_data_corr_half;
   
    
end

end


