%% Dsinkhorn()
% Computes the cost and sharp gradient of Sinkhorn

%% Inputs
% X: (d x 1) histogram in R^d, that we'll take the gradient in terms of
%    or (d x N), and we'll do N different problems
% Y: (d x N) M reference samples in R^d
% C: (d x d) Sinkhorn cost matrix
% K: (d x d) exp(-lambda * C)
% U: (d x d) K .* C
% iter_sink: iterations of Sinkhorn to do

%% Outputs
% s: (1 x N) the Sinkhorn transport values
% G: (d x N) each column the gradient of the corresponding Sinkhorn

function [s, G] = Dsinkhorn_sharp(X, Y, C, K, U, iter_sink)

%% Sinkhorn

% Prep
[d,N] = size(Y);

% Run it
%[s,~,u,v] = sinkhornTransport(X, Y, K, U, lambda, 'marginalDifference', inf, 0, iter_sink, 0);
[s,u,v] = sinkhorn(X, Y, K, U, iter_sink);


%% Gradients in terms of x

% Variable
G = zeros(d,N);

% Iterate over the Sinkhorn problems done
for n = 1 : N

    % This is basically the code from the Differential Properties of
    %  Sinkhorn Approximation paper, modified to fix small issues

    % T
    T = u(:,n) .* K .* v(:,n)';
    Tbar = T(:,1:d-1);
    
    % L
    L = T .* C;
    Lbar = L(:,1:d-1);

    % Term I'll use twice
    t = sum(Tbar,1).^-1;

    % Linear system stuff
    cK = diag(sum(T,2)) - (Tbar .* t) * Tbar';
    f = sum(L,2) - Tbar * (t .* sum(Lbar,1))';
    
    % Solve the relevant system, and record the gradient
    G(:,n) = cK \ f;

end