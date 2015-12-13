addpath classifiers/liblinear-1.5-dense/matlab;
addpath classifiers/libsvm-mat-2.84-1-fast.v3;
addpath feat-code;
addpath io;
addpath training;

global config;

data_dir = 'data';

config.C           = 10;               % C parameter for SVM  
config.LIBLINEAR_B = 10;               % LIBLINEAR (-B)
config.LIBSVM_d    = 5;                % LIBSVM poly degree
config.LIBSVM_r    = 1;                % LIBSVM r (coefficient)
config.LIBSVM_g    = 1;                % LIBSVM gamma for rbf kernel  
config.BLOCKS      = [14 7 4; 14 7 4]; % block sizes for histogramming
config.DO_OVERLAP  = true;             % have overlapping blocks
config.NORI        = 12;               % number of orientations  
config.PATCH_W     = 28;               % patch width (do not change)
config.PATCH_H     = 28;               % patch height (do not change)
config.NORM_TYPE   = 'l2';             % or l1 (total pixels are normalized)
config.GRAD_TYPE   = 2;                % 0 - tap, 1-sobel, 2 - gaussian filters 
config.GRAD_SIGMA  = 2;                % sigma of the gaussian filter

ntrain = 60000;
sphogdemo
