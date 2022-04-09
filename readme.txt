Run the scrip main.m under Code for a demo.
The Data folder has .mat files that hold the various data in MATLAB variables.
The main functions are robust_SparkleVision and DSinkhorn, which together compute the Sinkhorn gradients and convert them to gradients for the robust Sparkle Vision program.

In terms of computer specs, make sure things are run on a reasonably modern CPU with a good amount of RAM. MATLAB will need roughly 1 GB of RAM.

The unused data_process....m files are what I used for parsing the original MNIST, CIFAR-10, and vegetable data, and puting them into the .mat files.