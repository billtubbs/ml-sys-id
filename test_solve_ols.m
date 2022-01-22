% Test functions solve_ols.m and solve_ols_properties.m

clear all; clc; close all

% Sub-directories
data_dir = 'data';

% Test with data from course homework
filename = 'TP03_Q1.mat';
load(fullfile(data_dir, filename))
u = u1; y = y1;

%fprintf("u1: (%d, %d)\n", size(u1))
%fprintf("y1: (%d, %d)\n", size(y1))

% Identify ARX model:
% y(k) = B(q^-1)/A(q^-1)*u(k-nk) + e(k)/A(q^-1)
% A(q^-1) = 1 + a1*q^-1 + a2*q^-2 + ... + a_na*q^-na
% B(q^-1) = b1 + b2*q^-1 + b3*q^-2 + ... + b_nb*q^-nb+1

% Choose order of numerator and denominator
na = 3;  % na > 0
nb = 1;  % nb > 0
nk = 1;  % nk >= 0
%fprintf("na = %d\nnb = %d\nnk = %d\n", na, nb, nk)
nn = [na nb nk];

[p1, covp1, Vres1] = idarx1(nn,u,y);

% ARX model structure
na = nn(1); assert(na > 0)
nb = nn(2); assert(nb > 0)
nk = nn(3); assert(nk >= 0)
m = length(u);
assert(length(y) == m)

% Construct data matrices
U = hankel(u(1:nb),u(nb:end)).';
U = flip(U(1:m-nb+1,:),2);
Y = hankel(y(1:na),y(na:end)).';
Y = flip(Y(1:m-na+1,:),2);

% Phi, Y matrices
n = m - max(na, nb + nk - 1);
phi = [-Y(end-n:end-1,:) U(end-n-nk+1:end-nk,:)];
Y = y(end-n+1:end);

p2 = solve_ols(phi,Y);
assert(all(abs(p1./p2 - 1) < 1e-10))

[p3, Vres3, var_e3, covp3] = solve_ols_properties(phi,Y);
assert(all(abs(p1./p3 - 1) < 1e-10))
assert(all(all(abs(covp1 - covp3) < 1e-8)))
assert(all(abs(Vres1 - Vres3) < 1e-8))
