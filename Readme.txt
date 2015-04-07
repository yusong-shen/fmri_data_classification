=====FMRI data classification=====
This folder contain the code of exercise of ufldl(Unsupervised Feature Learning and Deep Learning)
its original repository came from
https://github.com/zellyn/deeplearning-class-2011/tree/master/ufldl

The original data comes from ADNI:
http://adni.loni.usc.edu/data-samples/access-data/
We use DPABI ( http://rfmri.org/dpabi) to preprocess these Data

Mar 23rd, 2015:
the original data can be found on 'trainingData100, testData50, strange_data' these three folder.
all the common functions are put in 'library' folder.
the data folder contains the better formated data which is suitable for the input of algorithms.
the function that transform the original data to better formatted data can be found on library folder.


Apr 3rd, 2015:
Todo : Rewrite the code to a more readable version, add the document to each function
All the codes are diveided into 5 parts : 
1) Data : load dataset, data wrangling, shuffle data etc.
2) Algorithm : Training and prediction of Softmax regression, Stacked Autoencoder
3) Validation : run cross validation for above algorithm
4) Analysis : plot the accuracy figure, visualize weights
5) Demo : a script organized 1)-4) parts

for the fmri data:
164 fmri data : 87 AD, 77 Normal Control
Number of Patients :  38 AD,  20 Normal Control

Datasetnum
Number of feature
1 - 90x130 = 11700
2 - 90x90 = 8100
3 - 81x45 = 4005 
4 - 41x21 = 861
Dataset 1 : the original data , 90 rows stand for 90 different brain areas, 130 columns stand for 130 sample at different moment, the sampling period is about 10+ms 
Dataset 2: compute the correlation matrix from the dataset 1, Aij belongs to [-1,1], which means the correlation coefficient between ith area and jth area. If Aij close to 1, it means when  area i’s blood-oxygen-level dependent(BOLD) increase, the area j’s BOLD also tend to increase with linear relation with area i’s.   
Dataset 3 : Since the correlation matrix is a symmetric matrix, I delete the duplicated symmetry entry from dataset 2, which reduce input’s dimension.
Dataset 4 : Select 43 sub-area in whole brain network to reduce input’s dimension. 


If you have any questions, feel free to contact yusongtju@gmail.com
Yusong Shen
