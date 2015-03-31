This file is the primary documentation for users of the fMRI Matlab software on
/afs/cs/project/theo-72/fmri_core_new.  The software on this directory is a
self-contained core set of functions intended to be easily used on a variety of
fMRI data sets.  For example, the following commands in an interactive Matlab
session will load the data for one subject in an fMRI experiment, display the
fMRI data as an animated movie, then train a Naive Bayes classifier and test its
accuracy over the training data.

 load data-starplus-04847-v7.mat;
 animateTrial(info,data,meta,3,6);                                  %see movie
 [i,d,m]=transformIDM_selectTrials(info,data,meta,find([info.cond]~=0)); % seletct non-noisey trials
 [examples,labels,expInfo] = idmToExamples_condLabel(i,d,m);  %create training data
 [classifier] = trainClassifier(examples,labels,'nbayes');   %train classifier
 [predictions] = applyClassifier(examples,classifier,'nbayes');       %test it
 [result,predictedLabels,trace] = summarizePredictions(predictions,classifier,'averageRank',labels);
 1-result{1}  % rank accuracy

This documentation has the following sections:

1. An introductory tutorial

2. Description of the key data structures used by this software.

3. Documentation on user functions

This software is the result of several people's efforts.  The first version is
due to Francisco Pereira.  Other contributors include Tom Mitchell, Stefan
Niculescu, Xuerui Wang, Indra Rustandi, Rebecca Hutchinson, Jay Pujara.  

WARNING: Some of the utilities assume your Matlab includes the statistics
toolbox and the optimization toolbox.


=======================================
1. Introductory tutorial.  

Below is a sample session illustrating some of the most basic functions
available.  It is STRONGLY recommended that you type the commands in this
tutorial into your Matlab window, to understand the functions and to examine the
data structures and see the visualizations of the data.

% load the data (assume you're using version 7 of Matlab.  If you're using
% version 6, load the -v6.mat file instead)
   load('data-starplus-04847-v7.mat')  

% examine the variables info, data, and meta, and read their description in
% section 2 below.
   meta
   info
   data

% draw a picture of activation for the z=4 slice of the brain for trial 4, at time 8
   plotSnapshot(info,data,meta,4,4,8,0,0);

% do the same as above, but for all slices of the brain
   plotSnapshot3D(info,data,meta,4,8,0,0);

% play a movie showing the activity over time for trial 4
   M=animate16Trial(info,data,meta,4);
   movie(M,2,.5)  % play it again, twice, at .5 frames/second

% plot the time course for a single voxel at coord <36,62,8>
   plotVoxel(info,data,meta,36,62,8)

% plot the time course for just trials 3 and 4 of voxel <36,62,8>
   [i,d,m]=transformIDM_selectTrials(info,data,meta,[3,4]);
   plotVoxel(i,d,m,36,62,8);

% create an info,data,meta containing just the mean activitation over the trials
that require the subject to make a decision, then plot that mean activation.

   alltrials= 1:meta.ntrials
   ts= [info.actionAnswer]==0
   trialsOfInterest=alltrials(ts)
   [i,d,m]=transformIDM_avgTrials(info,data,meta,trialsOfInterest);
   plotVoxel(i,d,m,36,62,8);
   animate16Trial(i,d,m,1);

% create training examples consisting of 8 second (16 image) windows of data,
labeled by whether the subject is viewing a picture or a sentence.  Label 1
means they are reading a sentence, label=2 means they are viewing a picture.
"examples" is a NxM array, where N is the number of training examples, and M is
the number of features per training example (in this case, one feature per voxel
at each of 16 time points).

    % collect the non-noise and non-fixation trials
    trials=find([info.cond]>1); 
    [info1,data1,meta1]=transformIDM_selectTrials(info,data,meta,trials);
    % seperate P1st and S1st trials
    [infoP1,dataP1,metaP1]=transformIDM_selectTrials(info1,data1,meta1,find([info1.firstStimulus]=='P'));
    [infoS1,dataS1,metaS1]=transformIDM_selectTrials(info1,data1,meta1,find([info1.firstStimulus]=='S'));
 
    % seperate reading P vs S
    [infoP2,dataP2,metaP2]=transformIDM_selectTimewindow(infoP1,dataP1,metaP1,[1:16]);
    [infoP3,dataP3,metaP3]=transformIDM_selectTimewindow(infoS1,dataS1,metaS1,[17:32]);
    [infoS2,dataS2,metaS2]=transformIDM_selectTimewindow(infoP1,dataP1,metaP1,[17:32]);
    [infoS3,dataS3,metaS3]=transformIDM_selectTimewindow(infoS1,dataS1,metaS1,[1:16]);

    % convert to examples
    [examplesP2,labelsP2,exInfoP2]=idmToExamples_condLabel(infoP2,dataP2,metaP2);
    [examplesP3,labelsP3,exInfoP3]=idmToExamples_condLabel(infoP3,dataP3,metaP3);
    [examplesS2,labelsS2,exInfoS2]=idmToExamples_condLabel(infoS2,dataS2,metaS2);
    [examplesS3,labelsS3,exInfoS3]=idmToExamples_condLabel(infoS3,dataS3,metaS3);

    % combine examples and create labels.  Label 'picture' 1, label 'sentence' 2.
    examplesP=[examplesP2;examplesP3];
    examplesS=[examplesS2;examplesS3];
    labelsP=ones(size(examplesP,1),1);
    labelsS=ones(size(examplesS,1),1)+1;
    examples=[examplesP;examplesS];
    labels=[labelsP;labelsS];


% train a Naive Bayes classifier
   [classifier] = trainClassifier(examples,labels,'nbayes');   %train classifier

% apply the Naive Bayes classifier to the training data (it's best to use cross
validation, of course, to obtain an estimate of its true error).  The returned
array 'predictions' is an array where predictions(k,j) = log P(example_k |
class_j).

   [predictions] = applyClassifier(examples,classifier);       %test it

% summarize the results of the above predictions.   

 [result,predictedLabels,trace] = summarizePredictions(predictions,classifier,'averageRank',labels);
 1-result{1}  % rank accuracy


=======================================
2. DATA STRUCTURES

see the file README-data-documentation.tex


================================================
3. LIST OF USER FUNCTIONS

This is BRIEF documentation.  For more detail on function <f>, type 'help
<f>' in Matlab, or see the comments at the beginning of the <f>.m file.

===================== 
Functions on IDM's: (IDM is short for Info,Data,Meta - see above documentation
on data structures)

transformIDM_selectTrials(info,data,meta,trials) 
 Returns a copy of info,data,meta containing only the specified trials.  The
 input parameter 'trials' is an array listing the indices of trials to be
 included.
 Example:  select just trials 3 and 5
 [info2,data2,meta2] = transformIDM_selectTrials(info,data,meta,[3,5]) 

transformIDM_selectTimewindow(info,data,meta,snapshots) 
 Returns a copy of info,data,meta containing only the specified snapshots in
 time within each trial.  The input parameter 'snapshots' is an array
 listing the indices of snapshots to be included, assuming the index of the
 first snapshot of each trial is 1.
 Example:  select just time snapshots 3, 4, and 7 from each trial
  [info2,data2,meta2] = transformIDM_selectTimewindow(info,data,meta,[3,4,7]) 

transformIDM_selectVoxelSubset(info,data,meta,<list of voxels>)
 Returns an IDM containing only the voxels selected in the list that is passed.
 Example:  select voxels 3 and 5
  [info2,data2,meta2] = transformIDM_selectVoxelSubset(info,data,meta,[3,5]) 

transformIDM_selectROIVoxels(info,data,meta,ROIlist) 
Returns a copy of info,data, and meta, selecting only voxels that belong to
ROIs found on ROIlist.
Example:  
  [info2,data2,meta2] = transformIDM_selectROIVoxels(info,data,meta,{'CALC' 'LIT'})
   returns an IDM where the data contains just the voxels belonging to
   CALC and LIT

transformIDM_mergeTrials(info,data,meta) 
 Transforms info, data, and meta by concatenating all trials into a single
 trial.  The returned info has info(1).cond=-1 to indicate there is no single 
 condition for the merged trial.  It also contains info(1).snapshotCond(i) set 
 to the condition of the trial from which the i-th snapshot was taken.  The 
 returned Meta contains meta.startsOfFormerTrials, an array listing the 
 snapshot indices in the returned Data that correspond to the beginning 
 snapshots of the original trials.
 Example: 
  [info2,data2,meta2] = transformIDM_mergeTrials(info,data,meta) 

transformIDM_pairwiseAvg(info,data,meta)
 Returns a copy of info,data, and meta, replacing each snapshot(t) by the
 average of shapshot(t) and snapshot(t+1).  Note this shortens the length of
 each trial by one snapshot. Info and data are updated accordingly.
 Example:  
  [info2,data2,meta2] = transformIDM_pairwiseAvg(info,data,meta);

transformIDM_selectActiveVoxact(info,data,meta,nToKeep,[conditions to consider])
 Returns an IDM containing only the <nToKeep> most active voxels across
 [conditions], using t-test of these conditions against condition 1 (by
 convention, this is 'fixation').
 Conceptually, this works by taking the per condition rankings
 Cond  2   ... last condition being considered
       v(1)    v(1)
       v(2)    v(2)
 and  -------------- sliding a window down until the number left
 above is the # to keep.
 Note that some voxels may be near the top of several of the rankings. They will
 get picked only once.
 Example:   This will t-test condition 2 versus condition1, and condition 3 vs. 1,
then combine selected voxels from each test
  [info2,data2,meta2] = transformIDM_selectActiveVoxact(info,data,meta,20,[2,3]);

transformIDM_selectActiveVoxels(info,data,meta,nToKeep)
 Returns an IDM containing only the <nToKeep> most active voxels from each
 condition.  Thus, it keeps at most (#ROIS * #conditions * #nToKeep) voxels.
 Example:  
  [info2,data2,meta2] = transformIDM_selectActiveVoxels(info,data,meta,20);

transformIDM_avgTrials(info,data,meta,trials)
 Returns a copy of info,data, and meta, containing a single trial which is
 the average of all trials specified by the input.  The input 'trials' is an
 array listing the indices of trials to be included in the average.  If
 trials are of different length, prints a warning message and uses the
 length of the shortest trial.
 Example:  
  [info2,data2,meta2] = transformIDM_avgTrials(info,data,meta,[3,6]);
   returns an IDM containing one trial which is the average of trials 3 and 6

transformIDM_avgTrialCondition( info,data,meta )
 Returns an IDM containing one trial per condition, where the trial is the average
 of all the trials with that condition (with as many time points as the shortest
 of them).
 Example:  
  [avginfo,avgdata,avgmeta] = transformIDM_avgTrialCondition(info,data,meta);

transformIDM_avgVoxels(info,data,meta,superVoxels,<absoluteVal>)
 Returns a copy of info,data, and meta, with data defined in terms of the
 specified 'superVoxels'.  The input superVoxels is a cell array of
 arrays, each of which specifies a set of voxels to be combined into one
 superVoxel.  The ith supervoxel is assigned a pseudo-coordinate of
 x=i,y=1,z=1. The optional argument 'absoluteVal' determines whether to
 average the voxel values, or their absolute values.  Set it to 1 if
 you wish to average the absolute values -- it defaults to 0, which specifies
 averaging the actual, signed values.
 Example:  
  [info,data,meta] = transformIDM_avgVoxels(info,data,meta,{[3,4,5],[10,12]});
   returns an IDM where the data contains just two voxels, one containing
   the average of voxels 3,4 and 5, and the second the avg of voxels 10
   and 12.

transformIDM_avgROIVoxels(info,data,meta,<ROIs>)
 Returns a copy of info,data, and meta, with each ROI replaced by a single
 'superVoxel', whose activation is the mean activation of voxels in that ROI.
 ROIs is a cell array specifying the text names of the ROIs to include, and the 
 sequence of the ROIs given determines the sequence of the supervoxel columns 
 in the returned Data.   If ROIs  is not given, then all ROIs in meta.rois are used. 
 The ith ROI supervoxel is assigned a pseudo-coordinate of x=i,y=1,z=1.  
 (implemented using transformIDM_avgVoxels).  
 **NOTE: this function assumes you have run createColToROI beforehand ***
 Example:  
  [info2,data2,meta2] = transformIDM_avgROIVoxels(info,data,meta,{'LT' 'RB'});
   returns an IDM where data contains just two voxels, the first giving the spatial
   average of voxels in LT, the second giving the mean activity of voxels in RB.
 
transformIDM_avgVoxelSubset(info,data,meta,[voxel list,[weight list]])
 Averages a selected subset of the voxels into a new IDM. The arguments are
 are an array with the voxel numbers to average (default all) and an array
 with the same size with the averaging weight (default equal for all).
 Example:  
  [info2,data2,meta2] = transformIDM_avgVoxelSubset(info,data,meta,[3,4,5]);
   returns an IDM where the data contains one voxel, the average of voxels
   3,4 and 5.

transformIDM_unfold(info,data,meta)
 Returns an IDM where each trial gets turned into |trial| one-time point
 trials with the same condition.  E.g. a trial with condition 3 and length
 20 becomes a succession of 20 trials with condition 3 and length 1.
 Info,data and meta are updated accordingly.
 This is used in block studies to turn each time point in a block into
 a trial, and then each trial into an example.
 Example:  
  [info2,data2,meta2] = transformIDM_unfold(info,data,meta); 

transformIDM_separateBlocks(info,data,meta)
 Returns an IDM where each trial with a given condition number acquires
 a different condition number. For instance, the sequence of conditions
 in a study with 6 conditions
 2,3,2,4,3,5,6,3
 would become
 2,3,7,4,8,5,6,9
 Info is updated accordingly.
 One application of this was to transform 6 into 12 categories in the
 data from the Categories study.
 Example:
   [info2,data2,meta2] = transformIDM_separateBlocks(info,data,meta);

transformIDM_normalizeTrials(info,data,meta) 
 Returns a copy of info,data,meta in which each trial is normalized.
 Normalization is done separtely for each trial, and for each voxel within
 each trial.  Normalization consists for each voxel of calculating its mean
 activity over the trial, then subtracting its mean from its activity at
 each time point within the trial.  The net effect is to reset the mean to
 zero, while preserving the signal variation of the voxel over time during
 the trial.  May be useful for comparing trials, because it can remove the
 effect of long-term drift in signal magnitude.
 Example: 
   [info2,data2,meta2] = transformIDM_normalizeTrials(info,data,meta) 

transformIDM_smoothingKR(info,data,meta)
  Smooths the IDM temporally by performing Kernel Regression with
  gaussian kernels, on a trial by trial basis.

  WARNING: for many voxels, the residuals after smoothing
  (data - smoothed data) are strongly correlated (i.e. they
  do not look like a sample from a mean 0 gaussian). This leads
  to a few voxels being undersmoothed, as fitting the noise in
  points around the one being left out will lead to a good fit
  there as well. It's not a major issue, in that most voxels
  seem appropriately smooth, and the worse that can happen
  is that a voxel will be undersmoothed, rather than
  oversmoothed (which could destroy information).
 
  Example:
    [info2,data2,meta2] = transformIDM_smoothingKR(info,data,meta,[conditions])
  where the optional argument is a list of conditions to smooth (defaults to all).
 

=====================
Functions on Examples:

idmToExamples_fixation(info,data,meta)
 Produces array of examples from the info,data,meta, labeling examples as
 either the fixation condition or some other condition.

 Example:
 [examples,labels,expInfo] = idmToExamples_fixation(info,data,meta);

idmToExamples_condLabel(info,data,meta)
 Convert info, data, meta structure to example, lables structure, labeling 
 examples as the condition numbers from info.
 Exampels:
 [examples,labels,expInfo] = idmToExamples_condLabel(info,data,meta);


mergeExamples(examples1, labels1, expInfo1, examples2, labels2, expInfo2)
 Merge two example sets into a large one, and update the experiment 
 information.
 Example:
 [examples, labels, expInfo] = mergeExamples(examples1, labels1, expInfo1, examples2, labels2, expInfo2)

=====================
Functions on Classifiers:

trainClassifier(Examples,Labels,classifierType)
  Trains on a set of examples, producing as output a classifier.
  For now, use this only to train a NaiveBayes classifier, by using the 
  value 'nbayes' for classifierType.   
  Example:
  classifier = trainClassifier(examples, labels, 'nbayes');

applyClassifier(Examples,classifier)
  Use a learned classifier (from trainClassifier) to label new examples.
  For nbayes classifier, outputs an array with one row per example, and 
  one column per class.  The columns are ordered in increasing order with the
  class label.  The value of predictions(k,j) is log P(class_j | example_k).
  Example:
  [predictions] = applyClassifier(examples,classifier);
   
summarizePredictions(predictions,classifier,'averageRank', truelabels)
  Given a set of examples, a classifier returned by trainClassifier, the
  predictions returned by applyClassifier, and a column vector of truelabels,
  returns a summary of the predictions.  The most useful part of this is
  predictedLabels.  The value of predictedLabels(k) is the label predicted for
  example k.

  Example:
  [result,predictedLabels,trace] = summarizePredictions(scores,trainedClassifier,'averageRank',testLabels)

===================== 
Displaying data:

HINT: new plots reuse the existing Matlab plot window.  To preserve existing
plots and create a new one, give the Matlab command 'figure' before calling
the function.

plotVoxel(i,d,m,x,y,z)
 Display the entire time series for voxel <x,y,z>, and the series of trial
 conditions, concatenating all trials in i,d,m.  The voxel activation is plotted in blue.
 In addition, the condition number of the trial (info.cond) is plotted in red.
 Example:
  plotVoxel(i,d,m,46,54,10) % plot timecourse for voxel <46,54,10> and conditions

plotSnapshot(i,d,m,trialNum,z,n,minActiv,maxActiv)
 Plot an image showing slice z of the n-th snapshot of trial numbered
 trialNum. If you want to pass in the maximum and minimum activities (i.e.,
 the activity levels that will display as color intensities 1 and 128), then
 set maxActiv, minActiv accordingly.  If you set these both to zero, they
 will be computed from the data.
 Example: display slice z=3 of snapshot 4 of trial 2
  plotSnapshot(i,d,m,2,3,4,0,0)

plotSnapshot3D(i,d,m,trialNum,n,minActiv,maxActiv)
 Same as plotSnapshot, but displays up to 16 z slice images at once.
 Z slices are laid out by z values in  the following arrangement: 
   1  2  3  4 
   5  6  7  8 
   9 10 11 12
  13 14 15 16
 Example: display first snapshot of second trial. 
  img = plotSnapshot3D(i,d,m,2,1,0,0);  

plotTrial(i,d,m,trialNum,<titlestring><interactive?>) 
 Plot the voxel time courses for trial number trialNum, one z slice at
 a time, for the given i,d,m.  Lays out voxel plots showing their
 geometric relationship.
 Example:
  viewTrial(i,d,m,12)  % plots time courses for trial number 12

animateTrial(i,d,m,trialNum,z)
 Create a movie of brain activity for one z slice of trial trialNum of the
 IDM, and display it.  Returns the movie matrix.
 Example: Show and return a movie for trial 3, brain slice z=7
   M=animateTrial(i,d,m,3,7);  
   movie(M,3,2);     % replay it 3 times, at 2 frames/second
 
animate6Trial(i,d,m,trialNum,z)
  Just like animateTrial, but simultaneously display six z slices (z through
  z+5)
  Example: Show and return a movie for trial 3, brain slices z= 9 - 14
   M=animate6Trial(i,d,m,3,9);  
   movie(M,3,2);     % replay it 3 times, at 2 frames/second
 
animate16Trial(i,d,m,trialNum)
  Just like animateTrial, but simultaneously display all 16 z slices
  Z slices are laid out in the following format:
    1  2  3  4
    5  6  7  8
    9 10 11 12
   13 14 15 16
  Example:  Show and return a movie for trial 3, all brain slices
   M=animate16Trial(i,d,m,3);  
   movie(M,3,2);     % replay it 3 times, at 2 frames/second

=====================
Utility functions:

getVoxelTimecourse(info,data,meta,x,y,z)
 Returns a column vector containing the entire time course of voxel
 throughout the IDM

getConditionTimecourse(info,data,meta) 
 Returns a column vector containing the condition numbers at each time
 instant throughout the IDM

getROI(meta,roiNameString)
Returns the struct from meta.rois that corresponds to 'roiNameString'
 Example: getROI(meta,'LT')
