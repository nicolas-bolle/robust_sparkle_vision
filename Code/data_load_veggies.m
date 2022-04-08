%% data_load_veggies
% Load in the veggies data .mat file and pick out some data for testing
% Sets d1, d2, D, N, Ntest, X, Xtest, M (size of total data), I (indices of N imgs used)


%% Parameters
d1 = 56;
d2 = 56;
D = d1 * d2;
N = 6000; % This is a healthy amount bigger than D
% N should be a multiple of 3, since we'll take RGB channels
Ntest = 30; % The size of the test set


%% Basic stuff
% Load Pokemon data
load('..\Data\veggies')
M = size(R,3);

% Reshape images into vectors
Rall = reshape(R,D,M);
Gall = reshape(G,D,M);
Ball = reshape(B,D,M);

% Pick out a limited batch of data
% The R/G/B channels will come in sets of 3, so Y(:,1:3) gives the RGB of
%  the first image
I = randperm(M,(N+Ntest)/3);
R = Rall(:,I);
G = Gall(:,I);
B = Ball(:,I);
X = zeros(D,N);
X(:,1:3:N+Ntest) = R;
X(:,2:3:N+Ntest) = G;
X(:,3:3:N+Ntest) = B;

% Plot an image
i=1;
RGB = zeros(d1,d2,3);
RGB(:,:,1) = reshape(X(:,3*(i-1)+1),d1,d2);
RGB(:,:,2) = reshape(X(:,3*(i-1)+2),d1,d2);
RGB(:,:,3) = reshape(X(:,3*(i-1)+3),d1,d2);
figure
imshow(RGB, 'InitialMagnification', 1000)

% Normalize
X = X ./ sum(X,1);

% Train/test
Xtest = X(:,N+1:end);
X = X(:,1:N);


%% Delete variables to save memory
clear Rall Gall Ball R G B i RGB