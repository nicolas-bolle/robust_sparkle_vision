%% Csinkhorn()
% Computes the cost matrix for Sinkhorn on images

%% Inputs
% d1: the width of the (d1 x d2) image, which is represented as a (d1*d2)-vector
% d2: the other part
% cap: the maximum value for entries in C; infinity by default

%% Outputs
% C: (D x D) cost matrix, where D = d1*d2

function C = Csinkhorn(d1,d2,cap)

% Default value for cap
if nargin < 3
    cap = Inf;
end

% I'm doing it a safe and lame way so I don't think too hard

% The x/y coords could be backwards, but it doesn't matter
x_coords = ones(d1,1) * (1:d2);
y_coords = (1:d1)' * ones(1,d2);

D = d1 * d2;
x_coords = reshape(x_coords,D,1);
y_coords = reshape(y_coords,D,1);

C = zeros(D,D);

for i = 1 : D
    for j = 1 : D
        C(i,j) = sqrt((x_coords(i) - x_coords(j))^2 + (y_coords(i) - y_coords(j))^2);
    end
end

C = min(C,cap);
