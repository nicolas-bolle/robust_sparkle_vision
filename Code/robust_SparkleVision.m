%% robust_SparkleVision()
% Uses gradient descent to solve the SparkleVision problem, but with
%  Sinkhorn used in the objective for robustness
% Make sure there is some noise on all of the X, Y samples, to avoid
%  division by zero issues

%% Inputs
% X: (D x N) N reference samples in R^D, unscrambled
% Y: (D x N) N samples in R^D, with components scrambled (by linear trans)
% C: (D x D) cost matrix
% lambda: for Sinkhorn
% iter_sink: iterations of Sinkhorn to do
% iter_grad: iterations of gradient descent to do
% rho: influence of the L1 regularization term
% eta: scaling for the gradient for updating A
% A: (D x D) initial value for A
% k: batch size for stochastic gradients

% Throughout, A will be rounded to a nonnegative matrix with column sums 1

%% Outputs
% c: (iter_grad x 1) vector of the costs at the start of each iteration
% A: (D x D) of the matrix A after the final iteration
% G: (D x D) of the gradient in the final iteration

function [c, A, G] = robust_SparkleVision(X, Y, C, lambda, iter_sink, iter_grad, rho, eta, A, k)

%% Basics
% Sizes
[D, N] = size(X);

% Round A just in case
A = max(A,0);
A = A ./ sum(A);

% For Sinkhorn
K = exp(-lambda * C);
U = K .* C;

% Misc variables
c = zeros(iter_grad,1);    % For holding the cost for each iter


%% Gradient descent
for iter = 1 : iter_grad

    tic

    % Stochastic gradient batch choice
    I = randperm(N,k);

    % Sinkhorn to compute costs and gradient vectors
    % s is (1 x k), g is (d x k)
    [s, g] = Dsinkhorn(A * Y(:,I), X(:,I), lambda, K, U, iter_sink);
    
    % The (stochastic) gradient for this iteration
    G = (1/k) * g * Y(:,I)' + rho * sign(A);

    % If the gradient vector has NaNs, do nothing this iteration
    % And alert the user
    if any(any(isnan(G)))
        G = zeros(D,D);
        fprintf('NaN in gradient on iteration %d\n',iter)
    end
    
    % Update A, with some "rounding" (nonnegative, column sums 1)
    A = A - eta * G;
    A = max(A,0);
    A = A ./ sum(A,1);
    
    % Record the cost
    c(iter) = mean(s);
    
    toc
    
end