%% data_process_MNIST
% Here I create a .mat file with the MNIST data
% Standard data from http://yann.lecun.com/exdb/mnist/
% Helper function is https://www.mathworks.com/matlabcentral/fileexchange/27675-read-digits-and-labels-from-mnist-database

% Make sure there is a folder MNIST in Data containing the 4 uncompressed MNIST data files from the website

filenameImagesTrain = '..\Data\MNIST\train-images-idx3-ubyte';
filenameLabelsTrain = '..\Data\MNIST\train-labels-idx1-ubyte';
filenameImagesTest  = '..\Data\MNIST\t10k-images-idx3-ubyte';
filenameLabelsTest  = '..\Data\MNIST\t10k-labels-idx1-ubyte';

[images_train, labels_train] = readMNIST(filenameImagesTrain, filenameLabelsTrain, 60000, 0);
[images_test,  labels_test]  = readMNIST(filenameImagesTrain, filenameLabelsTrain, 10000, 0);

save('..\Data\MNIST','images_train','labels_train','images_test','labels_test')

clear filenameImagesTrain filenameLabelsTrain filenameImagesTest filenameLabelsTest images_test images_train labels_test labels_train