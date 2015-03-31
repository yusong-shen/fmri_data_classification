Data file and data structure documentation for the fMRI starplus study.

Tom Mitchell

March, 2005

fMRI data is available for a number of human subjects.  For each subject the
full data set is stored on a file containing the subject number (e.g., the data
for subject 04799 is on data-starplus-04799-v7.mat).  If you are using version 7
of Matlab, load the files ending with 'v7'; if you have version 6 then use the
files ending with 'v6.'

After you load a file, you will find three variables defined: info, data, and
meta.  The variable 'data' contains the actual image intensity data values.  The
variable 'meta' contains general information about the dataset.  The full time
series of images in the data is partitioned into temporally continguous segments
called 'trials'.  The variable 'info' describes information about each of these
trials.

Detailed documentation for each variable is provided below:

===========================================
META

meta: This variable provides information about the data set. Relevant fields are
shown in the following example:

meta = 
 study: 'data-starplus'
 subject: '05710'
 ntrials: 54
 nsnapshots: 2800
 nvoxels: 4634
 dimx: 64
 dimy: 64
 dimz: 8
 colToCoord: [4634x3 double]
 coordToCol: [64x64x8 double]
 rois: [1x25 struct]
 colToROI: {4634x1 cell}

meta.study gives the name of the fMRI study

meta.subject gives the identifier for the human subject

meta.ntrials gives the number of trials in this dataset

meta.nsnapshots gives the total number of images in the dataset

meta.nvoxels gives the number of voxels (3D pixels) in each image

meta.dimx gives the maximum x coordinate in the brain image. The minimum x
coordinate is x=1.  meta.dimy and meta.dimz give the same information for the y
and z coordinates.

meta.colToCoord(v,:) gives the geometric coordinate (x,y,z) of the voxel
corresponding to column v in the data

meta.coordToCol(x,y,z) gives the column index (within the data) of the voxel
whose coordinate is (x,y,z)

meta.rois is a struct array defining a few dozen anatomically defined Regions Of
Interest (ROIs) in the brain.  Each element of the struct array defines on of
the ROIs, and has three fields: "name" which gives the ROI name (e.g., 'LIFG'),
"coords" which gives the xyz coordinates of each voxel in that ROI, and
"columns" which gives the column index of each voxel in that ROI.

meta.colToROI{v} gives the ROI of the voxel corresponding to column v in the
data.  


===========================================
INFO

info: This variable defines the experiment in terms of a sequence of 'trials'.
'info' is a 1x54 struct array, describing the 54 time intervals, or trials.
Most of these time intervals correspond to trials during which the subject views
a single picture and a single sentence, and presses a button to indicate whether
the sentence correctly describes the picture.  Other time intervals correspond
to rest periods.  The relevant fields of info are illustrated in the following
example:

info(18)
 mint: 894
 maxt: 948
 cond: 2       
 firstStimulus: 'P'
 sentence: ''It is true that the star is below the plus.''
 sentenceRel: 'below'
 sentenceSym1: 'star'
 sentenceSym2: 'plus'
 img: sap
 actionAnswer: 0
 actionRT: 3613

info.mint gives the time of the first image in the interval (the minimum time)

info.maxt gives the time of the last image in the interval (the maximum time)

info.cond has possible values 0,1,2,3.  Cond=0 indicates the data in this
segment should be ignored. Cond=1 indicates the segment is a rest, or fixation
interval.  Cond=2 indicates the interval is a sentence/picture trial in which
the sentence is not negated.  Cond=3 indicates the interval is a
sentence/picture trial in which the sentence is negated.

info.firstStimulus: is either 'P' or 'S' indicating whether this trail was
obtained during the session is which Pictures were presented before sentences,
or during the session in which Sentences were presented before pictures.  The
first 27 trials have firstStimulus='P', the remained have firstStimulus='S'.
Note this value is present even for trials that are rest trials.  You can pick
out the trials for which sentences and pictures were presented by selecting just
the trials trials with info.cond=2 or info.cond=3.

info.sentence gives the sentence presented during this trial.  If none, the
value is '' (the empty string).  The fields info.sentenceSym1,
info.sentenceSym2, and info.sentenceRel describe the two symbols mentioned in
the sentence, and the relation between them.

info.img describes the image presented during this trial.  For example, 'sap'
means the image contained a 'star above plus'.  Each image has two tokens, where
one is above the other.  The possible tokens are star (s), plus (p), and dollar
(d).

info.actionAnswer: has values -1 or 0.  A value of 0 indicates the subject is
expected to press the answer button during this trial (either the 'yes' or 'no'
button to indicate whether the sentence correctly describes the picture).  A
value of -1 indicates it is inappropriate for the subject to press the answer
button during this trial (i.e., it is a rest, or fixation trial).

info.actionRT: gives the reaction time of the subject, measured as the time at
which they pressed the answer button, minus the time at which the second
stimulus was presented.  Time is in milliseconds.  If the subject did not press
the button at all, the value is 0.


===========================================
DATA

data: This variable contains the raw observed data.  The fMRI data is a sequence
of images collected over time, one image each 500 msec.  The data structure
'data' is a [54x1] cell array, with one cell per 'trial' in the experiment.
Each element in this cell array is an NxV array of observed fMRI activations.
The element data{x}(t,v) gives the fMRI observation at voxel v, at time t within
trial x.  Here t is the within-trial time, ranging from 1 to info(x).len.  The
full image at time t within trial x is given by data{x}(t,:).

Note the absolute time for the first image within trial x is given by info(x).mint.
