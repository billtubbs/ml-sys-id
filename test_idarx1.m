% Test function idarx1.m

% Example from README.md file
load('data/TP04_Q3.mat')

assert(isequal(size(u), [75 1]))
assert(isequal(size(y), [75 1]))

na = 2; nb = 2; nk = 3;
p = idarx1([na nb nk],u,y);

assert(max(abs(p - [
    -1.786574
    0.810195
    -0.384260
    0.407383
])) < 0.5e-6)
