% Function to estimate the parameters of a dynamic ARX model
% from time series data.  Also computes the covariance matrix
% (covp) and the sum of the squared residuals (Vres).
%
% Arguments:
% nn : [na nb nk] structure of the model to be estimated
%  u : size(m, 1) input time series
%  y : size(m, 1) output time series
%
% The reason for the '1' in the function name is to distinguish
% this function from the MATLAB equivalent.
%

function [p, covp, Vres] = idarx1(nn,u,y)

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
    
    % Estimate parameters using ordinary least squares
    % p = inv(phi' * phi) * phi' * Y
    p = (phi' * phi) \ (phi' * Y);
    
    % Residuals
    errors = Y - phi * p;

    % Sum-squared of residuals (minimization criterion)
    Vres = errors'*errors;
    
    % Estimate of the white noise variance
    var_e = 1/(n-length(p))*Vres;

    % Covariance matrix of parameter estimates
    covp = var_e * inv(phi'*phi);

end
