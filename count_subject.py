# seperate the subject

subjects_files = open('subjects.txt')
lines = subjects_files.readlines()
# print lines
subjects_files.close()

subjects = [s[0:10] for s in lines]
subjects = sorted(list(set(subjects)))
print len(subjects)
#print subjects

# use 'w' option to create the file that doesn't exist
adni_subjects = open('adni_subjects.txt','w')
for sub in subjects:
    adni_subjects.write('%s\n'% sub)
adni_subjects.close()