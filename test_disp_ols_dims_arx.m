% Test disp_ols_dims_arx.m function

clear all;

% Example 1

% Number of input data points
m = 20;

% Order of numerator, denominator and delay
na = 2;  % na > 0
nb = 3;  % nb > 0
nk = 4;  % nk >= 0
[Y, Phi, Theta] = disp_ols_dims_arx([na nb nk], m);

% Display output:
% m = 20
% na = 2
% nb = 3
% nk = 4
% n = m - max(na, nb + nk - 1) = 14
% size(Y): [14 1]
% size(Phi): [14 5]
% size(Theta): [5 1]

% Phi =
%  
% [  -y6,  -y5,  u3,  u2,  u1]
% [  -y7,  -y6,  u4,  u3,  u2]
% [  -y8,  -y7,  u5,  u4,  u3]
% [  -y9,  -y8,  u6,  u5,  u4]
% [ -y10,  -y9,  u7,  u6,  u5]
% [ -y11, -y10,  u8,  u7,  u6]
% [ -y12, -y11,  u9,  u8,  u7]
% [ -y13, -y12, u10,  u9,  u8]
% [ -y14, -y13, u11, u10,  u9]
% [ -y15, -y14, u12, u11, u10]
% [ -y16, -y15, u13, u12, u11]
% [ -y17, -y16, u14, u13, u12]
% [ -y18, -y17, u15, u14, u13]
% [ -y19, -y18, u16, u15, u14]
%  
assert(all(size(Y) == [14 1]))
assert(all(size(Phi) == [14 5]))
assert(all(size(Theta) == [5 1]))


% Example 2 - from exercise 3.2 (a) of course

na = 3;
nb = 1;
nk = 5;
[Y, Phi, Theta] = disp_ols_dims_arx([na nb nk], 500);
assert(all(size(Y) == [495 1]))
assert(all(size(Phi) == [495 4]))
assert(all(size(Theta) == [4 1]))


% Example 3 - from exercise 3.4 (a)

na = 4; nb = 3; nk = 3;
m = 460;
[Y, Phi, Theta] = disp_ols_dims_arx([na nb nk], m);
assert(all(size(Y) == [455 1]))
assert(all(size(Phi) == [455 7]))
assert(all(size(Theta) == [7 1]))
