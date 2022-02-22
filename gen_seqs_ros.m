function seqs = gen_seqs_ros(epsilon, settle_period, init_period, ...
    id_period, final_period, seed, n_seq)
% seqs = gen_seqs_ros(epsilon, settle_period, init_period, ...
%     id_period, final_period, seed, n_seq)
% Generate input excitation signal consisting of randomly-
% occurring steps for system identification.
%
% Generates a cell array of sequences containing integer values
% with the following meanings:
% 0 : initial value - the initial input value
% 1 : step level 1
% 2 : step level 2
%
% Example
% >> seqs = gen_seqs_ros(0.5, 3, 2, 10, 2);
% >> seqs
% 
% seqs =
% 
%   1×1 cell array
% 
%     {17×1 double}
% 
% >> seqs{1}'
% 
% ans =
% 
%   0  0  0  0  0  2  2  1  1  1  2  2  2  1  1  0  0
%

    if nargin < 7
        n_seq = 1;
    end
    if nargin < 6
        seed = 0;
    end

    % Reset random number generator
    rng(seed, 'twister')

    % Length of sequence
    nT = settle_period + init_period + id_period + final_period;

    % Sample times
    k = (0:nT-1);

    seqs = cell(1, n_seq);
    for i = 1:n_seq

        % Input vector
        seq = nan(nT, 1);
        k_id_start = settle_period + init_period;
        k_id_end = settle_period + init_period + id_period;
        seq(k < k_id_start) = 0;
        seq(k >= k_id_end) = 0;
        k1 = k_id_start;
        i_level = 2;
        k2 = k1;
        while k2 < k_id_end
            % Increment k by sampling from geometric distribution
            % with probability of shock, epsilon:
            k2 = min(k1 + geornd(epsilon), k_id_end);
            seq((k >= k1) & (k < k2)) = i_level;
            k1 = k2;
            i_level = mod(i_level, 2) + 1;
        end
        assert(isequal(size(seq), [nT 1]))
        seqs{i} = seq;
    end

end
