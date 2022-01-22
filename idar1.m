% Function to estimate the parameters of a dynamic AR model
% from time series data.  Also computes the covariance matrix
% (covp) and the sum of the squared residuals (Vres).
%
% Arguments:
% nn : [na] structure of the model to be estimated
%  y : size(m, 1) output time series
%
% The reason for the '1' in the function name is to distinguish
% this function from the MATLAB equivalent.
%

function [p, covp, Vres] = idar1(nn, y)

    % AR model structure
    na = nn(1); assert(na > 0)
    m = length(y);

    % Construct data matrices
    Y = hankel(y(1:na), y(na:end)).';
    Y = flip(Y(1:m-na+1,:), 2);
    
    % Phi, Y matrices
    n = m - na;
    phi = -Y(end-n:end-1, :);
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
