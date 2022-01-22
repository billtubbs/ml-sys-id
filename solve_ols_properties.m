function [theta, Vres, var_e, covp] = solve_ols_properties(phi,Y)
    % Estimate parameters using ordinary least squares and
    % compute the sum of the squared residuals, white
    % noise variance and covariance matrix.
    
    % theta = inv(phi' * phi) * phi' * Y
    theta = (phi' * phi) \ (phi' * Y);

    % Residuals
    errors = Y - phi * theta;

    % Sum-squared of residuals (minimization criterion)
    Vres = errors'*errors;

    % Estimate of the white noise variance
    n = size(Y,1);
    var_e = 1 / (n - length(theta)) * Vres;

    % Covariance matrix of parameter estimates
    covp = var_e .* inv(phi' * phi);

end