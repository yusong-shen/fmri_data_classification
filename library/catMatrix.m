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