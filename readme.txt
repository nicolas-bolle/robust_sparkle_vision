For a quick demo, run the demo_MNIST, demo_CIFAR, or demo_veggies scripts in the Code folder. See the write-up for details on the algorithm and results of the numerics.

System reqs: a modern CPU (I have an i7) and at least 4 GB RAM available to MATLAB to run all 3 demo files. If you process the original data, you'll need more memory.


Code descriptions:
- demo_veggies_*.m: the demo files mentioned above
- data_load_*.m: load the data from .mat files, for use in the demos
- SparkleVision.m: runs the SparkleVision algorithm
- robust_SparkleVision.m: runs the robust SparkleVision algorithm
- D_sinkhorn.m: computes Sinkhorn (sharp) costs and (regularized) gradients
- D_sinkhorn_sharp.m: (unused) computes Sinkhorn (sharp) costs and (sharp) gradients
- sinkhorn.m: my no-frills Sinkhorn implementation
- sinkhornTransport.m: (unused) Marco Cuturi's Sinkhorn implementation from https://marcocuturi.net/SI.html
- A_permutation.m: randomly generates the planted matrix A
- Csinkhorn.m: calculates the Sinkhorn cost matrix
- shift.m: shift an image by a vector in R^2, including fractional shifts
- threshold.m: "thresholds" a matrix to only keep the largest entries in each column
- plot_*.m: helper scripts for the plotting in the demos
- data_process_*.m: code used in generating the .mat data files
- readMNIST.m: code using in data_process_MNIST.m from https://www.mathworks.com/matlabcentral/fileexchange/27675-read-digits-and-labels-from-mnist-database


Data descriptions:
- The original data is from http://yann.lecun.com/exdb/mnist/, https://www.cs.toronto.edu/~kriz/cifar.html, https://www.kaggle.com/datasets/misrakahmed/vegetable-image-dataset
- The .mat files were generated with the data_process_*.m scripts to avoid needing the bulky original data, and hold the data used by the demo files
- If you'd like to re-run the data_process_*.m scripts, you'll need to 3 new folders in the Data folder:
1. MNIST: holds the 4 uncompressed MNIST files
2. cifar-10-batches-mat: the result of running MATLAB's untar() on the uncompressed CIFAR data
3. Veggies: the "train" folder of the vegetable data (with Bean, ..., Tomato subfolders), renamed to "Veggies"