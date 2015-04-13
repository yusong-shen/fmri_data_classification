function data = loadFMRIData(filename)
%loadFMRIData : Load FMRI data as variable 
%   
data_struct = load(filename);
variables = fieldnames(data_struct);
data = data_struct.(variables{1});

end

