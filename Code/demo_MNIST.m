%% demo_MNIST
% Runs SparkleVision and the robust version on MNIST data


%% Load data
% This is where you choose which dataset you want to use
disp(' ')
disp('Loading data...')
data_load_MNIST
disp('Data loaded')


%% Transformations A and B
% Come up with a planted value for A, and use B = inv(A) to find Y

% The transformation
Aplant = A_permutation(D);

% And linearly transform things
% This is Y = inv(A) * X
Y = Aplant \ X;
Ytest = Aplant \ Xtest;


%% Add shifts to X

% Standard deviation of pixel shifts
eps = 1;

% Using a helper function shift()
for n = 1 : N
    v = eps * randn(1,2);
    x = reshape(X(:,n),d1,d2);
    x = shift(x,v);
    X(:,n) = reshape(x,D,1);
end
clear n v x


%% Add noise for Sinkhorn

% Amount of noise to add: noise = 1 means the image will be 50% noise
noise = 0.1;

Xnoise = X + noise / D;
Xnoise = Xnoise ./ sum(Xnoise,1);
Ynoise = Y + noise / D;
Ynoise = Ynoise ./ sum(Ynoise,1);


%% Solve it with SparkleVision
disp(' ')
disp('Solving with SparkleVision...')
Asparkle = SparkleVision(X, Y);
disp('Done with SparkleVision')


%% Prepare to solve the robust way

% Cost matrix for Sinkhorn
C = Csinkhorn(d1,d2,5);

% Initial guess for A
A = ones(D,D) / D;

% For storing cost, A, and gradients across iterations of gradient descent
c  = [];
cA = [];
cG = [];


%% Gradient descent
% Re-run this block with different parameters if you want to keep iterating

% Sinkhorn parameters
lambda = 10;
iter_sink = 100;

% Gradient descent parameters
iter_grad = 100;
rho = 0.01;
eta = 0.01;
k = 100;

% Run
[cc, ccA, ccG] = robust_SparkleVision(Xnoise, Ynoise, C, lambda, iter_sink, iter_grad, rho, eta, A, k);

% Store results
c  = cat(1,c,cc);
cA = cat(3,cA,ccA);
cG = cat(3,cG,ccG);

% Update the guess for A
A = cA(:,:,end);


%% Done iterating? Plot the results!

% Save the final guess for A
Arobust = A;

% Cost
figure
plot(c)
title('MNIST cost')
xlabel('Iteration')
ylabel('Cost')

% A
plot_A
sgtitle('MNIST A recovery')

% Thresholdings
Arobust_t  = threshold(Arobust,5);
Asparkle_t = threshold(Asparkle,5);

% Now some image plots
plot_test_images
sgtitle('MNIST digit recovery')