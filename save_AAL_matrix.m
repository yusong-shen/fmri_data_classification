%% save the ADNI FMRI AAL matrix

% data_path = 'C:\ADNI_AALTC_data';
% cd 'C:\ADNI_AALTC_data';
cd '/Users/yusong/Code/AALTC_raw_166/MCI/'
data_list = dir('*.mat'); 
n = length(data_list);
for j = 1:n
    % e.g '002_S_4219_1_AALTC.mat'
    file_name = data_list(j).name;  
    load(file_name);
    data_name = strcat('AAL',file_name(1:end-10));
    % e.g. 'AAL_002_S_4219_1 = zeros(90,130);
    command_str1 = strcat(data_name,' = zeros(90,130);');
    eval(command_str1);
    for i = 1:9
        % AAl01TC
        var_name = sprintf('AAL0%dTC',i);
        % 'AAL_002_S_4219_1(:,i) = AAL01TC'
        % AAL01TC : 130x1
        command_str2 = strcat(data_name, '(i,:) =  ',var_name,';');
        eval(command_str2);
    end

    for i = 10:90
        % AAL11TC
        var_name = sprintf('AAL%dTC',i);
        command_str2 = strcat(data_name, '(i,:) = ',var_name,';');
        eval(command_str2);
    end 

dirpath = '/Users/yusong/Code/AALTC_new_data_166/MCI/';
mkdir_if_not_exist(dirpath)
save_path = strcat(dirpath, file_name);
save(save_path, data_name);

end