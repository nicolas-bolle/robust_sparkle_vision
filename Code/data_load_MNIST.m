%% data_load_MNIST
% Load in the MNIST data .mat file and pick out some data for testing
% Sets d1, d2, D, N, Ntest, X, Xtest, M (size of total data), I (indices of N imgs used)


%% Parameters
d1 = 20;
d2 = 20;
D = d1 * d2;
N = 1000; % This is a healthy amount bigger than D
Ntest = 30; % The size of the test set


%% Basic stuff
% Load MNIST data
load('..\Data\MNIST')
M = size(images_train,3);

% Reshape images into vectors
Xall = reshape(images_train, D, M);

% Pick out a limited batch of data
I = randperm(M,N+Ntest);
X = Xall(:,I);

% Train/test
Xtest = X(:,N+1:end);
X = X(:,1:N);

% Normalize train data
X = X ./ sum(X,1);


%% Delete variables to save memory
clear Xall labels_train labels_test images_train images_test