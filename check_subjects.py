# check subjects

import os

from os.path import isfile, join


def show_subjects(dir_path):
	"""
	return the subjects id in a folder
	"""
	data_dir = os.listdir(dir_path)
	return data_dir

dir_path = 'C:/Deep Learning/fmri_classification_clean/fmri_data_classification/fmri_whole_data/final_result_ver1.1'

dir_path_ad = dir_path + '/AD_LMCI'
dir_path_norm = dir_path + '/Norm'

sub_ad = show_subjects(dir_path_ad)
sub_norm = show_subjects(dir_path_norm)


# sub_list = sub_ad + sub_norm
sub_ad_result = []
for data in sub_ad:
	sub_char = data.split('_')
	sub_id = sub_char[2]
	sub_ad_result.append(sub_id)


# print sub_result
print len(sub_ad_result)
print len(set(sub_ad_result))	

sub_norm_result = []
for data in sub_norm:
	sub_char = data.split('_')
	sub_id = sub_char[2]
	sub_norm_result.append(sub_id)

print len(sub_norm_result)
print len(set(sub_norm_result))
