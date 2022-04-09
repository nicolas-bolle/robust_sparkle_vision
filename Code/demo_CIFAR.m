%% demo_CIFAR
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
eps = 2;

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


%% Done iterating? Plot the results and calculate some stuff

% Save the final guess for A
Arobust = A;

% Cost
figure
plot(c)
title('Cost')

% The last 6 iterations for A
offset = iter_grad - 6;
figure
for iter = 1 : 6
    subplot(2,3,iter)
    imagesc(cA(:,:,offset+iter))
    colorbar
    title(string(offset+iter))
end
sgtitle('Last few iterations for A')
clear offset

% Thresholdings
Arobust_t  = threshold(Arobust,5);
Asparkle_t = threshold(Asparkle,5);


%% Now some image plots

% Pick 4 images
I = randi(Ntest,4,1);

% Plot the results of applying Aplant, Asparkle, Asparkle_t, Arobust, Arobust_t to it
figure

% Aplant
for i = 1 : 4
    subplot(4,4,i)
    imagesc(reshape(Xtest(:,i),d1,d2))
end

% Asparkle
for i = 1 : 4
    subplot(4,4,i+4)
    imagesc(reshape(Asparkle * Ytest(:,i),d1,d2))
end

% Arobust
for i = 1 : 4
    subplot(4,4,i+8)
    imagesc(reshape(Arobust * Ytest(:,i),d1,d2))
end

% Athresh
for i = 1 : 4
    subplot(4,4,i+12)
    imagesc(reshape(Athresh * Ytest(:,i),d1,d2))
end

% Titles
subplot(4,4,1)
title('A planted')
subplot(4,4,5)
title('A sparkle')
subplot(4,4,9)
title('A robust')
subplot(4,4,13)
title('A thresholded')



% Plot several
for j = 1 : 5

    i = start - 1 + j;

    % Get the image
    RGBact = zeros(d1,d2,3);
    RGBact(:,:,1) = reshape(Y(:,3*(i-1)+1),d1,d2);
    RGBact(:,:,2) = reshape(Y(:,3*(i-1)+2),d1,d2);
    RGBact(:,:,3) = reshape(Y(:,3*(i-1)+3),d1,d2);
    RGBscr = zeros(d1,d2,3);
    RGBscr(:,:,1) = reshape(X(:,3*(i-1)+1),d1,d2);
    RGBscr(:,:,2) = reshape(X(:,3*(i-1)+2),d1,d2);
    RGBscr(:,:,3) = reshape(X(:,3*(i-1)+3),d1,d2);
    RGBrec = zeros(d1,d2,3);
    RGBrec(:,:,1) = reshape(Api * X(:,3*(i-1)+1),d1,d2);
    RGBrec(:,:,2) = reshape(Api * X(:,3*(i-1)+2),d1,d2);
    RGBrec(:,:,3) = reshape(Api * X(:,3*(i-1)+3),d1,d2);
    
    % Scale
    s = max(max(max(RGBact)));
    RGBact = RGBact / s;
    RGBscr = RGBscr / s;
    RGBrec = max(RGBrec, 0) / s;
    
    % Plot
    offset = 3*(j-1);
    subplot(5,3,offset+1)
    imshow(RGBact, 'InitialMagnification', 2000)
    title('Actual')
    subplot(5,3,offset+2)
    imshow(RGBscr, 'InitialMagnification', 2000)
    title('Scrambled')
    subplot(5,3,offset+3)
    imshow(RGBrec, 'InitialMagnification', 2000)
    title('Recovered')

end