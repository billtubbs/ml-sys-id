
function theta = solve_ols(phi,Y)
    % Estimate parameters using ordinary least squares
    % theta = inv(phi' * phi) * phi' * Y
    theta = (phi' * phi) \ (phi' * Y);
end