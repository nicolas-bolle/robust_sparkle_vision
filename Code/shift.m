%% shift()
% Shifts an image by a vector

%% Inputs
% X: (m x n) image to shift
% v: length 2 vector giving the shift for each axis

%% Outputs
% Y: the shifted image

% The basic observation is that we can right shift a vector x by a + alpha,
%  where alpha \in [0,1) by computing
%          conv(x,[0_a,1-alpha,alpha])(1:length(x))
% There's a similar formula for left shifts, but the indexing changes
% So I do both at once with a matrix convolution, and make sure to take
%  care in the final indexing

function Y = shift(X,v)

%% Basics
[m,n] = size(X);

% Figure out the directions of shifts for each dimension
% True = right, False = left
v1 = v(1);
d1 = (v1 >= 0);
v2 = v(2);
d2 = (v2 >= 0);


%% Shift vectors and indices
% Form the shift vectors for each dimension,
%  and the indices for indexing later

% 1
if d1
    % Right shift
    a = floor(v1);
    alpha = v1 - a;
    s1 = [zeros(1,a), 1-alpha, alpha];
    I1 = 1 : m;
else
    % Left shift
    v1 = -v1;
    a = floor(v1);
    alpha = v1 - a;
    s1 = [alpha, 1-alpha, zeros(1,a)];
    I1 = 2+a : m+1+a;
end

% 2
if d2
    % Right shift
    a = floor(v2);
    alpha = v2 - a;
    s2 = [zeros(1,a), 1-alpha, alpha];
    I2 = 1 : n;
else
    % Left shift
    v2 = -v2;
    a = floor(v2);
    alpha = v2 - a;
    s2 = [alpha, 1-alpha, zeros(1,a)];
    I2 = 2+a : n+1+a;
end


%% Perform the shift

% Shift matrix
S = s1' * s2;

% Convolve
Z = conv2(X,S);

% Index
Y = Z(I1,I2);


