%% save the ADNI FMRI AAL matrix

% data_path = 'C:\ADNI_AALTC_data';
cd 'C:\aalprocessing\result';
data_list = dir('*.mat'); 
n = length(data_list);
for j = 1:n
    % e.g '002_S_4219_1_AALTC.mat'
    file_name = data_list(j).name;  
    load(file_name);
    data_name = strcat('AAL',file_name(1:end-10));
    % e.g. 'AAL_002_S_4219_1 = zeros(90,130);
    command_str1 = strcat(data_name,' = transpose(',data_name,');' );
    eval(command_str1);


save_path = strcat('C:/aalprocessing/result/saves/',file_name);
save(save_path, data_name);

end