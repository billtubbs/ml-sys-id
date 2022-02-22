% Test idinput_from_seq, gen_seqs_rbs and gen_seqs_ros

% Normal operating points
op_pts = struct( ...
    'ore_feed', 120, ...   % changed from 108 to increase effects
    'SAG_speed', 0.77, ...
    'mill_level', 19.2, ...
    'mill_power', 1812, ...
    'ore_hardness', 1, ...
    'ore_density', 2.9, ...
    'mix_factor', 0.2283, ...
    'feed_water_ratio',  0.3410 ...
);

data_dir = 'data';


%% Test gen_seqs_rbs

% Example 1 from docstring
step_length = 2;
settle_period = 3;
init_period = 2;
id_period = 10;
final_period = 2;
seqs = gen_seqs_rbs(step_length, settle_period, init_period, ...
    id_period, final_period);

assert(isequal(seqs{1}', [0 0 0 0 0 2 2 1 1 1 1 2 2 1 1 0 0]))

% Example 2 from docstring
seqs = gen_seqs_rbs(3, 5, 3, 12, 2, 0, 3);
assert(isequal(seqs{1}', [0 0 0 0 0 0 0 0 2 2 2 2 2 2 1 1 1 2 2 2 0 0]))
assert(isequal(seqs{2}', [0 0 0 0 0 0 0 0 2 2 2 1 1 1 2 2 2 1 1 1 0 0]))
assert(isequal(seqs{3}', [0 0 0 0 0 0 0 0 2 2 2 2 2 2 1 1 1 2 2 2 0 0]))

% Check sequences 1:2 the same
seqs = gen_seqs_rbs(3, 5, 3, 12, 2, 0, 2);
assert(isequal(seqs{1}', [0 0 0 0 0 0 0 0 2 2 2 2 2 2 1 1 1 2 2 2 0 0]))
assert(isequal(seqs{2}', [0 0 0 0 0 0 0 0 2 2 2 1 1 1 2 2 2 1 1 1 0 0]))

% Check different with different seed
seqs = gen_seqs_rbs(3, 5, 3, 12, 2, 1, 4);
assert(isequal(seqs{1}', [0 0 0 0 0 0 0 0 2 2 2 1 1 1 2 2 2 1 1 1 0 0]))
assert(isequal(seqs{2}', [0 0 0 0 0 0 0 0 2 2 2 2 2 2 1 1 1 1 1 1 0 0]))
assert(isequal(seqs{3}', [0 0 0 0 0 0 0 0 2 2 2 1 1 1 1 1 1 1 1 1 0 0]))
assert(isequal(seqs{4}', [0 0 0 0 0 0 0 0 2 2 2 2 2 2 1 1 1 2 2 2 0 0]))
% Note: the first step should always be 2

% Check without settle period and step length 1
seqs = gen_seqs_rbs(1, 0, 2, 12, 3);
assert(isequal(seqs{1}', [0 0 2 2 2 1 2 1 2 1 1 1 1 2 0 0 0]))


%% Test gen_seqs_ros

% Example 1 from docstring
epsilon = 0.5;
settle_period = 3;
init_period = 2;
id_period = 10;
final_period = 2;
seqs = gen_seqs_ros(epsilon, settle_period, init_period, ...
    id_period, final_period);

assert(isequal(seqs{1}', [0 0 0 0 0 2 2 1 1 1 2 2 2 1 1 0 0]))

% Multiple sequences
seqs = gen_seqs_ros(0.5, 3, 2, 10, 2, 0, 3);
assert(isequal(seqs{1}', [0 0 0 0 0 2 2 1 1 1 2 2 2 1 1 0 0]))
assert(isequal(seqs{2}', [0 0 0 0 0 2 1 1 1 1 1 1 1 1 1 0 0]))
assert(isequal(seqs{3}', [0 0 0 0 0 2 1 1 1 1 2 2 2 1 1 0 0]))


%% Test idinput_from_seq

nop = op_pts.('mix_factor');

% Step input used in IFAC paper (seq. #1)
id_period = 12;
step_length = 1;
settle_period = 6;
init_period = 3;
final_period = 3;
init_value = nop;
step_levels = [nop 0.5];
Ts = 1/60;
seed = 0;

seq = gen_seqs_rbs(step_length/Ts, settle_period/Ts, init_period/Ts, ...
    id_period/Ts, final_period/Ts, seed);
[u, t] = idinput_from_seq(seq{1}, init_value, step_levels, Ts);

%[t u]
%figure(3); clf
%stairs(t, u)

filename = 'id_input_rbs_mix_factor_1_1440.csv';
iddata_test = csvread(fullfile(data_dir, filename));
assert(max(abs(t - iddata_test(:, 1))) < 3.4e-4)
assert(max(abs(u - iddata_test(:, 2))) < 1e-4)
