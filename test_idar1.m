% Test isar1.m

clear all

% Example 1 - exercise 3.7 (a) from course

na = 1; nb = 1; nc = 1;
y = [0.73 0.18 -0.36 0.92 1.12]';
[p, covp, Vres] = idar1([na nb nc], y);

assert(round(p, 3) == -0.497)
