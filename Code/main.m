%% main
% Loads a data set and runs SparkleVision and Sinkhorn


%% Load data
% This is where you choose which dataset you want to use
disp(' ')
disp('Loading data...')
data_load_MNIST
%data_load_CIFAR
%data_load_veggies
disp('Data loaded')


%% Transformation A
% Come up with a planted value for A, and use B = inv(A) to find Y

% The transformation
Aplant = sparse(zeros(D,D));
pi = randperm(D);
%pi = flip(1:D);
for i = 1 : D
    Aplant(i,pi(i)) = 1;
end

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
noise = 0.05;

Xnoise = X + noise / D;
Xnoise = Xnoise ./ sum(Xnoise,1);
Ynoise = Y + noise / D;
Ynoise = Ynoise ./ sum(Ynoise,1);


%% Solve it with SparkleVision
disp(' ')
disp('Solving with SparkleVision...')
Asparkle = SparkleVision(X, Y);
disp('Done with SparkleVision')


%% Prepare to solve

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
iter_grad = 200;
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

% Permutation recovery
pip = zeros(1,D);
for i = 1 : D
    [~,pip(i)] = max(Arobust(:,i));
end
figure
scatter(1:D,pip,10,'r','.')
hold on
scatter(1:D,pi,20,'k','.')
legend('Recovered','Planted')
title('Permutation recovery')

% Make the permutation a matrix
Api = sparse(zeros(D,D));
for i = 1 : D
    Api(pip(i),i) = 1;
end

% Thresholded A
p = 0.01;
Athresh = Arobust;
j = round((1-p)*D);
for i = 1 : D
    v = Athresh(:,i);
    s = sort(v);
    t = s(j);
    Athresh(:,i) = v .* (v > t);
end
Athresh = Athresh ./ sum(Athresh,1);
clear i j v s t


%% Now some image plots

% Figure out if we should be plotting RGB images, i.e. not MNIST data
rgbQ = (D > 400);

% If doing RGB, this is the number of images we have to work with
if rgbQ
    Np = floor(Ntest / 3);
else
    Np = Ntest;
end

% Pick 4 images
I = randi(Np,4,1);

% Plot the results of applying Aplant, Asparkle, Arobust, Athresh, and Api to it
figure

if rgbQ % FIXME
    % ???
else
    % Aplant
    for i = 1 : 4
        subplot(5,4,i)
        imagesc(reshape(Xtest(:,i),d1,d2))
    end
    
    % Asparkle
    for i = 1 : 4
        subplot(5,4,i+4)
        imagesc(reshape(Asparkle * Ytest(:,i),d1,d2))
    end

    % Arobust
    for i = 1 : 4
        subplot(5,4,i+8)
        imagesc(reshape(Arobust * Ytest(:,i),d1,d2))
    end

    % Athresh
    for i = 1 : 4
        subplot(5,4,i+12)
        imagesc(reshape(Athresh * Ytest(:,i),d1,d2))
    end

    % Api
    for i = 1 : 4
        subplot(5,4,i+16)
        imagesc(reshape(Api * Ytest(:,i),d1,d2))
    end
    
    % Titles
    subplot(5,4,1)
    title('A planted')
    subplot(5,4,5)
    title('A sparkle')
    subplot(5,4,9)
    title('A robust')
    subplot(5,4,13)
    title('A thresholded')
    subplot(5,4,17)
    title('A permutation')
end



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