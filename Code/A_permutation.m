%% A_permutation()
% Forms a planted A matrix based on a random permutation

%% Inputs
% D: number of pixels in the input images X

%% Outputs
% A: (D x D) matrix A

function A = A_permutation(D)

A = sparse(D,D);
pi = randperm(D);
for i = 1 : D
    A(i,pi(i)) = 1;
end