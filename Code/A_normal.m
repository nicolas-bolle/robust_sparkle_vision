%% A_normal()
% Forms a planted A matrix as Gaussian noise

%% Inputs
% D: number of pixels in the input images X

%% Outputs
% A: (D x D) matrix A

function A = A_normal(D)

A = abs(randn(D,D));
A = A ./ sum(A,1);