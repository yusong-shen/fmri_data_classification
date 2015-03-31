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
    corr_matrix = zeros(89*45, num);
else
    corr_matrix = zeros((m-1)*m/2, num);
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