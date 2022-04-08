%% data_process_CIFAR
% Here I create a .mat file with the CIFAR-10 data
% Standard data from https://www.cs.toronto.edu/~kriz/cifar.html

% Make sure there is a folder cifar-10-batches-mat in Data, which is the result of running untar() on the uncompressed MATLAB data from the website

% Paths
file_info = fullfile('..\Data\cifar-10-batches-mat', 'batches.meta.mat');
files{1}  = fullfile('..\Data\cifar-10-batches-mat', 'data_batch_1.mat');
files{2}  = fullfile('..\Data\cifar-10-batches-mat', 'data_batch_2.mat');
files{3}  = fullfile('..\Data\cifar-10-batches-mat', 'data_batch_3.mat');
files{4}  = fullfile('..\Data\cifar-10-batches-mat', 'data_batch_4.mat');
files{5}  = fullfile('..\Data\cifar-10-batches-mat', 'data_batch_5.mat');
files{6}  = fullfile('..\Data\cifar-10-batches-mat', 'test_batch.mat');

% Load info
load(file_info)

% Load data and concatenate it
Rvec = [];
Gvec = [];
Bvec = [];
labels_full = [];
n = 32^2;
for i = 1 : 6
    file = files{i};
    load(file)
    Rvec = [Rvec, data(:,1:n)'];
    Gvec = [Gvec, data(:,n+1:2*n)'];
    Bvec = [Bvec, data(:,2*n+1:3*n)'];
    labels_full = [labels_full; labels];
end

% Process to be a bit nicer
% R, G, B will be (32 x 32 x 60000) arrays giving R/G/B channels
% labels will be a (60000 x 1) vector of labels
% Transpose because the reshape is in column-major order, and normalize
R = permute(double(reshape(Rvec,32,32,60000)) / 256, [2,1,3]);
clear Rvec
G = permute(double(reshape(Gvec,32,32,60000)) / 256, [2,1,3]);
clear Gvec
B = permute(double(reshape(Bvec,32,32,60000)) / 256, [2,1,3]);
clear Bvec
labels = labels_full;

% Plot an image
i=200;
RGB = zeros(32,32,3);
RGB(:,:,1) = R(:,:,i);
RGB(:,:,2) = G(:,:,i);
RGB(:,:,3) = B(:,:,i);
figure
imshow(RGB, 'InitialMagnification', 1000)

% Save this
save('..\Data\CIFAR','R','G','B','labels')

% Clear variables
clear R G B batch_label data file file_info files G i label_names labels labels_full n RGB