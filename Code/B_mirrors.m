%% B_mirrors()
% Forms a planted A matrix based on a surface of tiny mirrors

%% Inputs
% d1: unscrambled images are (d1 x d2), reshaped to vectors
% d2:
% alpha: the mirrors will move things by N(0, alpha^2 I)

%% Outputs
% B: (D' x D) matrix B for scrambling

function B = B_mirrors(d1,d2,alpha)

% Sizes
% The output image will be (d1p x d2p) with d1p ~ d1 + 6alpha, d2p similar
D = d1 * d2;
beta = ceil(alpha);
d1p = d1 + 6 * beta;
d2p = d2 + 6 * beta;
Dp = d1p * d2p;

% Make some lookup tables for (d1 x d2) -> D coordinates, so I don't think
L  = reshape(1:D,d1,d2);
Lp = reshape(1:Dp,d1p,d2p);

% Transform the (i,j) coordinates of the original image to find where they
%  should end up in the final image
% Make sure to include the border of width beta
I = (1:d1)' * ones(1,d2);
J = ones(d1,1) * (1:d2);
I = I + 3 * beta + alpha * randn(d1,d2);
J = J + 3 * beta + alpha * randn(d1,d2);

% Now convert the previous step into a transformation B
B = sparse(Dp,D);
for i = 1 : d1
    for j = 1 : d2

        % Target coordinates (fractional!)
        ip = I(i,j);
        jp = J(i,j);

        % Deal with it being fractional
        ip_int  = floor(ip);
        ip_frac = ip - ip_int;
        jp_int  = floor(jp);
        jp_frac = jp - jp_int;
        if ip_int > 0 && jp_int > 0
            B(Lp(ip_int,jp_int),     L(i,j)) = (1-ip_frac) * (1-jp_frac);
        end
        if ip_int < d1p && jp_int > 0
            B(Lp(ip_int+1,jp_int),   L(i,j)) =    ip_frac  * (1-jp_frac);
        end
        if ip_int > 0 && jp_int < d2p
            B(Lp(ip_int,jp_int+1),   L(i,j)) = (1-ip_frac) *    jp_frac ;
        end
        if ip_int < d1p && jp_int < d2p
            B(Lp(ip_int+1,jp_int+1), L(i,j)) =    ip_frac  *    jp_frac ;
        end

    end
end
