%% sinkhorn()
% No-frills version of the Sinkhorn algorithm

%% Inputs
% X: (d x 1) histogram in R^d, that we'll take the gradient in terms of
%    or (d x N), and we'll do N different problems
% Y: (d x N) M reference samples in R^d
% K: (d x d) exp(-lambda * C)
% U: (d x d) K .* C
% iter: iterations of the algorithm to run

%% Outputs
% s: (1 x N) the (sharp) Sinkhorn distance for each problem
% u: (d x N) with columns giving the u for each problem
% v: (d x N) with columns giving the v for each problem

function [s,u,v] = sinkhorn(X, Y, K, U, iters)

% Setup
[d,N] = size(Y);
u = ones(d,N);

% Iterate for u
for iter = 1 : iters
    u = X .* (1 ./ (K * (Y .* (1 ./ (K' * u)))));
end

% And set v
v = Y .* (1 ./ (K' * u));

% Now compute the costs
s = sum(u .* (U * v), 1);