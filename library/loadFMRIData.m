function data = loadFMRIData(filename)
% Load FMRI data as variable 
%   Detailed explanation goes here
data_struct = load(filename);
variables = fieldnames(data_struct);
data = data_struct.(variables{1});

end

