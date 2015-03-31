
% cmu core fmri dataset - introductort=y tutorial
% load the data (assume you're using version 7 of Matlab.  If you're using
% version 6, load the -v6.mat file instead)
   load('data-starplus-04847-v7.mat')  

% examine the variables info, data, and meta, and read their description in
% section 2 below.
   % meta
   % info
   % data

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
% that require the subject to make a decision, then plot that mean activation.

   alltrials= 1:meta.ntrials;
   ts= [info.actionAnswer]==0;
   trialsOfInterest=alltrials(ts);
   [i,d,m]=transformIDM_avgTrials(info,data,meta,trialsOfInterest);
   plotVoxel(i,d,m,36,62,8);
   animate16Trial(i,d,m,1);

% create training examples consisting of 8 second (16 image) windows of data,
% labeled by whether the subject is viewing a picture or a sentence.  Label 1
% means they are reading a sentence, label=2 means they are viewing a picture.
% "examples" is a NxM array, where N is the number of training examples, and M is
% the number of features per training example (in this case, one feature per voxel
% at each of 16 time points).

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
% validation, of course, to obtain an estimate of its true error).  The returned
% array 'predictions' is an array where predictions(k,j) = log P(example_k |
% class_j).