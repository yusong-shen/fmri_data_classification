# select ADNI Data folder that meet the requirement

# 0) the ADNI data path is C:\aalprocessing\ADNI\ADNI
# 1) the folder name should begin with 'Resting_State_fMRI'
# 	e.g C:\aalprocessing\ADNI\ADNI\006_S_4150\Resting_State_fMRI__4150
# 2) check if this folder has more than 3 subfolders in next layer
# 3) if so rename it to format like 'Resting_State_fMRI_002_S_0729'
# 4) copy it to C:\aalprocessing\ADNI\ADNI_selected_data

import os
import shutil

def fcount(path):
	"""
	return the number of subfolder in next layer
	"""
    # listdir return all the file and directory
	dir_list = [d for d in os.listdir(path) 
	if os.path.isdir(os.path.join(path, d))]
    # print dir_list[0] # 002_S_0295
	return len(dir_list)


def list_dirpath(path):
	dir_list = [d for d in os.listdir(path)	
	if os.path.isdir(os.path.join(path, d))]
	return [os.path.join(path, d) for d in dir_list]

def select_adni(path):
	"""
	return a list of suitable data folders
	"""
	# "C:/aalprocessing/ADNI/ADNI"
	dir_list = list_dirpath(path)
	count = 0
	result = []
	for d in dir_list:
		# 'C:/aalprocessing/ADNI/ADNI/002_S_0295'
		subdir_list = list_dirpath(d)
		# only has one folder , it must be Resting_State_fMRI
		# and fcount(subdir_list[0])>=3, has more than 3 experiments
		if len(subdir_list) == 1 and fcount(subdir_list[0])>=3:
			count += 1
			# print subdir_list
			sp_list = subdir_list[0].split('\\')
			# ['C:', 'aalprocessing', 'ADNI', 'ADNI', '130_S_5059', 'Resting_State_fMRI']
			# print sp_list
			new_name =  'Resting_State_fMRI_' + sp_list[4] 
			# print new_name
			# print sp_list[5]
			# print os.getcwd()
			# os.rename(subdir_list[0], os.path.join(d,new_name))
			# print os.getcwd()
			result.append(os.path.join(d,new_name))
	return result

def copy_files(selected_data, dst_path):
	count = 0
	for src in selected_data:
		sp_list = src.split('\\')
		# print sp_list
		dst = os.path.join(dst_path, sp_list[5])
		print 'dst',dst
		print 'src',src
		# shutil.copytree(src, dst)
		shutil.move(src, dst)
		count +=1
		print 'done :%d \n'%(count)
	

path = "C:\\aalprocessing\\ADNI\\ADNI"
# print fcount(path)
# print select_adni(path)
selected_data = select_adni(path)
# print selected_data[0].split('\\')
# print selected_data
dst_path = 'C:\\aalprocessing\\ADNI\\ADNI_selected_data'
copy_files(selected_data, dst_path)