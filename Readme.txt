=====FMRI data classification=====
This folder contain the code of exercise of ufldl(Unsupervised Feature Learning and Deep Learning)
its original repository came from
https://github.com/zellyn/deeplearning-class-2011/tree/master/ufldl

Mar 23rd, 2015
The new things:
the original data can be found on 'trainingData100, testData50, strange_data' these three folder.
all the common functions are put in 'library' folder.
the data folder contains the better formated data which is suitable for the input of algorithms.
the function that transform the original data to better formatted data can be found on library folder.

for the fmri data:
50 testset - 30 AD patients, 20 Health Normal Control
89 training set - 46 AD patients, 43 Health Normal Control

Datasetnum
Number of feature
1 - 90x130 = 11700
2 - 90x90 = 8100
3 - 91x45 = 4095 
4 - 43x21 = 903
Dataset 1 : the original data , 90 rows stand for 90 different brain areas, 130 columns stand for 130 sample at different moment, the sampling period is about 10+ms 
Dataset 2: compute the correlation matrix from the dataset 1, Aij belongs to [-1,1], which means the correlation coefficient between ith area and jth area. If Aij close to 1, it means when  area i’s blood-oxygen-level dependent(BOLD) increase, the area j’s BOLD also tend to increase with linear relation with area i’s.   
Dataset 3 : Since the correlation matrix is a symmetric matrix, I delete the duplicated symmetry entry from dataset 2, which reduce input’s dimension.
Dataset 4 : Select 42 sub-area in whole brain network to reduce input’s dimension. 


The codes of softmax regression for FMRI data are contained in 'fmri_softmax_exercise' folder.
The codes of Stacked Autoencoder for FMRI data are contained in 'fmri_data_classification' folder. 

If you have any questions, feel free to contact yusongtju@gmail.com
Yusong Shen
