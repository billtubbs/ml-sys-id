% Test function idarxct1.m

%% Main function to generate tests
function tests = test_idarxct1
    tests = functiontests(localfunctions);
end


%% Example 1 - from exercise 3.13

function test_idarxct1_ex1(testCase)
    
    u = [1 1 -1 -1 1]';
    y = [0.1 0.8 1.3 0.3 -0.6];

    F = [-3 2; 2 0];
    G = [3; -1];

    na = 1; nb = 1; nk = 1;

    % Should raise a value error because F is wrong shape
    verifyError(testCase, @() idarxct1([na nb nk],u,y,F,G), 'MATLAB:innerdim');

end


%% Example 2 - from homework 4 Q3 of course

function test_idarxct1_ex2(testCase)

    % Sub-directories
    data_dir = 'data';

    % Test with data from course homework
    filename = 'TP04_Q3.mat';
    load(fullfile(data_dir, filename))

    assert(all(size(u == [75 1])));
    assert(all(size(y == [75 1])));

    na = 2; nb = 2; nk = 3;
    F = [1.7 1.7 1 1];
    G = -1.7;

    p = idarxct1([na nb nk],u,y,F,G);
    assert(isequal(round(p, 4), [-1.7888; 0.8088; -0.3864; 0.3524]))

end
