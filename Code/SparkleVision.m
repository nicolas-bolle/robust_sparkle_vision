%% SparkleVision()
% The basic Sparkle Vision solution to the Sparkle Vision problem

%% Inputs
% X: (D x N) N reference samples in R^D, unscrambled
% Y: (D x N) N samples in R^D, with components scrambled (by linear trans)

%% Outputs
% A: (D x D) estimate for the A such that AY = X

function A = SparkleVision(X, Y)
A =  X * pinv(Y);

