%% threshold()
% Keeps only the largest entries in each column of a matrix

%% Inputs
% A: (D x Dp) matrix to threshold
% n: how many entries to keep from each column

%% Outputs
% A: thresholded version of A, with column sums 1

function A = threshold(A,n)

for i = 1 : size(A,2)
    v = A(:,i);
    s = sort(v);
    t = s(end-n);
    A(:,i) = v .* (v > t);
end
A = A ./ sum(A,1);