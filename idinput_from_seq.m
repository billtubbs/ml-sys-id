function [u, t] = idinput_from_seq(seq, init_value, step_levels, Ts)
% [u, t] = idinput_from_seq(seq, init_value, step_levels, Ts)
% Generate input excitation signals for system identification
% based on the given coded input sequence. 
%
% seq is a vector of sequences containing integer values
% with the following meanings:
% 0 : initial value - input value during initial period
% 1 : step level 1
% 2 : step level 2
% ...etc (may have any number of step levels)
%
% See functions gen_seqs_rbs and gen_seqs_ros for examples
% of how to generate a sequence.
%
% Arguments
%  seq : vector of integer indicator values. 
%  init_value : input value during initial conditions (seq(i) == 0)
%  step_levels : vector of input values during steps, size (1, n)
%  Ts : sampling period
%
% Returns
%  u : Input sequence size (nT+1, 1) where nT = size(seq, 1)
%  t : Time sequence size (nT+1, 1)
%

    nT = size(seq, 1);

    % Time vector
    t = Ts*(0:nT)';

    % Input vector
    u = nan(nT+1, 1);
    u(seq == 0) = init_value;
    for l = 1:numel(step_levels)
        u(seq == l) = step_levels(l);
    end
    % Provide one extra value for nT+1 timestep
    u(end, :) = u(end-1, :);
    assert(~any(isnan(u)))

end