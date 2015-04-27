# 

# C:\aalprocessing\Analysis\FunRaw\010_S_4442\0501_Resting State fMRI


# ADNI_010_S_4442_MR_Resting_State_fMRI_br_raw_20120210174448087_102_S140480_I283913

# ADNI_010_S_4442_MR_Resting_State_fMRI_br_raw_20120727145200356_5226_S158730_I319211

# ADNI_010_S_4442_MR_Resting_State_fMRI_br_raw_20121210160206778_2096_S176967_I350450

# ADNI_010_S_4442_MR_Resting_State_fMRI_br_raw_20130522154243932_4289_S190298_I373523

# each folder should contain one patient one experiment's 6720 files
# folders name should be sorted by their time

# 010_S_4442_1_AALTC  20120210

# 010_S_4442_2_AALTC  20120727

# 010_S_4442_3_AALTC  20121210

# 010_S_4442_4_AALTC  20130521

# PS C:\Deep Learning\fmri_classification_clean\fmri_data_classification> python .\seperate_dcm_files.py
# C:\aalprocessing\Analysis\FunRaw
# C:\aalprocessing\Analysis\FunRaw\010_S_4442
# C:\aalprocessing\Analysis\FunRaw\010_S_4442\0501_Resting State fMRI
# dcm!
# 26880
# ['ADNI_010_S_4442_MR_Resting_State_fMRI_br_raw_20120210174448087_102_S140480_I283913.dcm', 'ADNI_010_S_4442_MR_Resting_S
# tate_fMRI_br_raw_20120210174448888_101_S140480_I283913.dcm', 'ADNI_010_S_4442_MR_Resting_State_fMRI_br_raw_2012021017444
# 8963_106_S140480_I283913.dcm', 'ADNI_010_S_4442_MR_Resting_State_fMRI_br_raw_20120210174449019_105_S140480_I283913.dcm',
#  'ADNI_010_S_4442_MR_Resting_State_fMRI_br_raw_20120210174449071_104_S140480_I283913.dcm', 'ADNI_010_S_4442_MR_Resting_S
# tate_fMRI_br_raw_20120210174449124_103_S140480_I283913.dcm', 'ADNI_010_S_4442_MR_Resting_State_fMRI_br_raw_2012021017444
# 9175_4383_S140480_I283913.dcm', 'ADNI_010_S_4442_MR_Resting_State_fMRI_br_raw_20120210174449224_98_S140480_I283913.dcm',
#  'ADNI_010_S_4442_MR_Resting_State_fMRI_br_raw_20120210174449276_4382_S140480_I283913.dcm', 'ADNI_010_S_4442_MR_Resting_
# State_fMRI_br_raw_20120210174449327_99_S140480_I283913.dcm']
# C:\aalprocessing\Analysis\FunRaw\013_S_4579
# C:\aalprocessing\Analysis\FunRaw\013_S_4579\0501_Resting State fMRI
# dcm!

import os
import shutil

def list_dirpath(path):
	dir_list = [d for d in os.listdir(path)	
	if os.path.isdir(os.path.join(path, d))]
	return [os.path.join(path, d) for d in dir_list]

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

def seperate_files(fileList , dirPath):
	num = len(fileList)/6720.
	if num == 0:
		return []
	elif num%1 == 0:
		# 0 - 0:6719  1 - 6720:2*6720-1
		dir_list = []
		# dir_list = ( '010_S_4442_0' , [fileList ... 6720] , 'C:\\...')
		for i in range(int(num)):
			sp_files = fileList[6720*i:6720*(i+1)] 
			sp_dirName = sp_files[0].split('_')
			time = sp_dirName[10][:8]
			dirName = sp_dirName[1]+'_'+sp_dirName[2]+'_'+sp_dirName[3]+'_'+time
			dir_tuple = (dirName, sp_files, dirPath)
			dir_list.append(dir_tuple)

		return dir_list

def explore_dir(path):
	# use os.walk to travese all the dir and files
	dir_list = []
	for dirPath, subdirList, fileList in os.walk(path):
		print dirPath
		if fileList != []:
			# Todo : the root folder may contain more than two subfolder
			sp_list =  seperate_files(fileList, dirPath)
			for tuple in sp_list:
				dir_list.append(tuple)
			# filePaths = [os.path.join(dirName,tuple[1]) for tuple in dir_List]
	return dir_list

def move_files(dir_list,dst_path):
	# dir_list[0] = ( '010_S_4442_0' , [fileList ... 6720] , 'C:\\...')
	# move 6720 files from original to dstination
	# original = os.path.join(dir_list[i][2], file)
	# dst = dst_path + '\\' + dir_list[i][0]
	dst_lists = []
	for dir_tuple in dir_list:
		dst = dst_path + '\\' + dir_tuple[0]
		dst_lists.append(dst)
		# print 'dst:',dst
		if not os.path.exists(dst):
			os.makedirs(dst)
		for file in dir_tuple[1]:
			# dst = os.path.join(dst, file)
			src = os.path.join(dir_tuple[2], file)
			# print 'dst:',dst			
			# print 'src:',src
			shutil.copy(src, dst)
			# os.rename(src,dst)
	return sorted(dst_lists)


def seperate_dcm(src_path, dst_path):
	dir_paths = list_dirpath(src_path)
	for dir_path in dir_paths:
		dir_list = explore_dir(dir_path)
		dst_lists = move_files(dir_list, dst_path)	
		# Todo : Rename folder
		# 013_S_4917_20120910  - 013_S_4917_1
		# 013_S_4917_20121126 - 013_S_4917_2
		# print dst_lists
		for i in range(len(dst_lists)):
			new_path = dst_lists[i][:-8]+str(i)
			os.rename(dst_lists[i], new_path)







src_path = "C:\\aalprocessing\\adnicorrect"
dst_path = "C:\\aalprocessing\\adnicorrect\\FunRaw"
test_path = "C:\\aalprocessing\\Analysis\\FunRaw\\013_S_4917"

# dir_list = explore_dir(test_path)

# Just for test and debug
# print sp_files
# print len(sp_files)

# for files in sp_files:
# 	print 'len : files[0] %d'%(len(files[0]))
# 	print files[0]
# 	print len(files[1])
# 	print files[2]

# dir_lists = move_files(dir_list,dst_path)
# for i in range(len(dir_lists)):
# 	new_path = dir_lists[i][:-8]+str(i)
# 	os.rename(dir_lists[i], new_path)

seperate_dcm(src_path, dst_path)

