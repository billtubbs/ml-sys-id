function seqs = gen_seqs_rbs(step_length, settle_period, init_period, ...
    id_period, final_period, seed, n_seq)
% seqs = gen_seqs_prbs(step_length, settle_period, init_period, ...
%     id_period, final_period, seed, n_seq)
% Generate PRBS input excitation signals for system identification.
%
% Generates a cell array of sequences containing integer values
% with the following meanings:
% 0 : initial value - the initial input value
% 1 : step level 1 (the 
% 2 : step level 2
%
% Example
% seqs = gen_seqs_rbs(2, 3, 2, 10, 2);
% seqs
% 
% seqs =
% 
%   1×1 cell array
% 
%     {17×1 double}
% 
% seqs{1}'
% 
% ans =
% 
%   0  0  0  0  0  2  2  1  1  1  1  2  2  1  1  0  0
% 

    if nargin < 7
        n_seq = 1;
    end
    if nargin < 6
        seed = 0;
    end

    % Reset random number generator
    rng(seed, 'twister')

    assert(mod(id_period, step_length) == 0, ...
        "ValueError: step_length must be a divisor of id_period")
    n_steps = ceil(id_period / step_length);

    % Length of sequence
    nT = settle_period + init_period + id_period + final_period;

    seqs = cell(1, n_seq);
    for i = 1:n_seq

        % Make a random binary sequence of 0, 1 values
        rbs_seq = idinput(n_steps);
        if rbs_seq(1) == -1
            % Ensure it starts with a 1
            rbs_seq = -rbs_seq;
        end

        % Input excitation sequence symbols
        seq = cell(1, 3+n_steps);
        seq{1} = zeros(1, settle_period);
        seq{2} = zeros(1, init_period);
        for j = 1:n_steps
            switch rbs_seq(j)
                case -1
                    seq{2+j} = ones(1, step_length);
                case 1
                    seq{2+j} = 2*ones(1, step_length);
            end
        end
        seq{3+n_steps} = zeros(1, final_period);
        seq = cell2mat(seq);
        assert(isequal(size(seq), [1 nT]))
        seqs{i} = seq';
    end

end
