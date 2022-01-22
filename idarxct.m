% Function to perform a constrained ordinary least squares
% identification of the parameters of a dynamic ARX model
% from time series data.
%
% The linear constraint is defined by the following relationship
% between the model parameters:
%
%     F * p = G
%
% It is solved using the method of Lagrange multipliers.
%
% Arguments:
% nn : [na nb nk] structure of the model to be estimated
%  u : size(m, 1) input time series
%  y : size(m, 1) output time series
%  F : size(1, na+nb) constraint equation coefficients
%  G : size(na+nb, 1) constraint equation constants


function p = idarxct1(nn,u,y,F,G)

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
    % with explicit constraints (Lagrangian)
    p = phi' * phi \ (phi' * Y) - phi' * phi \ (...
        F' * ((F * ((phi' * phi) \ F')) \ (F * ((phi' * phi) \ (phi' * Y)) - G)) ...
    );
    
end
