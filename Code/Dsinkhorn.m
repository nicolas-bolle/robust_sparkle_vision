%% Dsinkhorn()
% Computes the cost and regularized gradient of Sinkhorn

%% Inputs
% X: (d x 1) histogram in R^d, that we'll take the gradient in terms of
%    or (d x N), and we'll do N different problems
% Y: (d x N) M reference samples in R^d
% lambda: used in Sinkhorn
% K: (d x d) exp(-lambda * C)
% U: (d x d) K .* C
% iter_sink: iterations of Sinkhorn to do

%% Outputs
% s: (1 x N) the Sinkhorn transport values
% G: (d x N) each column the gradient of the corresponding Sinkhorn

function [s, G] = Dsinkhorn(X, Y, lambda, K, U, iter_sink)

% Sinkhorn
[s,u,~] = sinkhorn(X, Y, K, U, iter_sink);

% Gradients in terms of x
G = log(u);
G = (G - mean(G,1)) / lambda;