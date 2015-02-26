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