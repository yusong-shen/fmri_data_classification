function [ dataset,labels, inputSize ] = loadFMRIDataset( dirpath,datatype,ADfolder,Normfolder )
%loadFMRIDataset : loading FMRI dataset from 
%
%

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
    inputSize = 90*90;
    fprintf('compute 90x90 corr dataset successfully\n');
elseif datatype == 'fmri'
    matrix1 = catMatrix(folderADname);
    matrix2 = catMatrix(folderNormname);
    inputSize = 90*130;
    fprintf('compute 90x130 fmri dataset successfully\n');
elseif datatype == 'half'
    matrix1 = computeHalfCorrMatrix(folderADname);
    matrix2 = computeHalfCorrMatrix(folderNormname);
    inputSize = 89*45;
    fprintf('compute 89x45 corr half dataset successfully\n');
elseif datatype == 'co42'
    smallarea = true;
    matrix1 = computeHalfCorrMatrix(folderADname,smallarea);
    matrix2 = computeHalfCorrMatrix(folderNormname,smallarea);
    inputSize = 41*21;
    fprintf('compute 41x21 corr half sub dataset successfully\n');
end

dataset = [matrix1, matrix2];
num_ad = size(matrix1,2);
num_norm = size(matrix2,2);
labels = [ones(num_ad,1);zeros(num_norm,1)];


end




