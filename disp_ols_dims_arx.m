function [Y, Phi, Theta] = disp_ols_dims_arx(nn, m)
% [Y, Phi, Theta] = disp_ols_dims_arx(nn, m)
% Displays the dimensions and organisation of the ordinary
% least-squares problem for identifying an ARX model from
% data.
% 
% ARX model:
%   y(k) = (B(q^-1) / A(q^-1)) u(k-nk) + (1 / A(q^-1)) e(k)
% where
%   A(q^-1) = 1 + a1*q^-1 + a2*q^-2 + ... + a_na*q^-na
%   B(q^-1) = b1 + b2*q^-1 + b3*q^-2 + ... + b_nb*q^(-nb+1)
%
% Arguments:
% nn : [na nb nk] structure of the model to be estimated
%     where na, nb, and nk are the order of numerator, 
%     denominator and delay.
%  m : Number of input data points.
%

    assert(m <= 500, "ValueError: m is too large.")

    % ARX model structure
    na = nn(1); assert(na > 0)
    nb = nn(2); assert(nb > 0)
    nk = nn(3); assert(nk >= 0)

    % Create symbolic arrays to represent data
    u = sym('u',[m 1]);
    y = sym('y',[m 1]);
    
    % Display parameters
    fprintf("m = %d\nna = %d\nnb = %d\nnk = %d\n", m, na, nb, nk)

    % Create symbolic array to represent parameters
    Theta = [sym('a',[na 1]); sym('b',[nb 1])];

    % Construct data matrices
    U_past = hankel(u(1:nb),u(nb:end)).';
    U_past = flip(U_past(1:m-nb+1,:),2);
    Y_past = hankel(y(1:na),y(na:end)).';
    Y_past = flip(Y_past(1:m-na+1,:),2);
    %fprintf("size(Y_past): [%d %d]\n", size(Y_past))
    %fprintf("size(U_past): [%d %d]\n", size(U_past))

    % Phi matrix
    n = m - max(na, nb + nk - 1);
    fprintf("n = m - max(na, nb + nk - 1) = %d\n", n)
    Phi = [-Y_past(end-n:end-1,:) U_past(end-n-nk+1:end-nk,:)];
    Y = y(end-n+1:end);
    fprintf("size(Y): [%d %d]\n", size(Y))
    fprintf("size(Phi): [%d %d]\n", size(Phi))
    fprintf("size(Theta): [%d %d]\n", size(Theta))

end