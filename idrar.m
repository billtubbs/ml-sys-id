function [theta, P] = idrar1(nn, yk, theta, P, gamma, met, l) 
    % Algorithme des moindres carrés ordinaires récursifs (MCOR) 
    % pour l'identification en ligne d'un système AR.
    % 
    % Arguments:
    %    nn : vecteur spécifiant la structure du modèle [na]
    %    yk : vecteur de sortie actuelles et passées
    % theta : vector of current parameter estimates
    %     P : covariance matrix
    % gamma : paramètre gamma utilisée pour l'estimation robuste
    %   met : méthode de gestion du facteur d'oubli
    %         (1 : algorithme à gain décroissant,
    %          2 : algorithme à facteur d'oubli fixe,
    %          3 : algorithme à trace constante)
    %     l : paramètre utilisé pour la gestion du facteur d'oubli
    %         si met = 2, l = lambda (facteur d'oubli)
    %         si met = 3, l = alpha (paramètre définissant le seuil de la trace)

    % ARX model structure
    na = nn(1); assert(length(yk) == (na+1))

    % Construct regressor vector from past data
    phi = [-yk(2:end)];

    % Covariance matrix update
    if met == 1
        % Algorithme à gain décroissant
        P = P - (P*(phi*phi')*P)/(1 + phi'*P*phi);
    elseif met == 2
        % Algorithme à facteur d'oubli fixe
        lambda = l;
        P = (P - (P*(phi*phi')*P)/(l + phi'*P*phi)) / lambda;
    elseif met == 3
        % Algorithme à trace constante
        alpha = l;
        A = P - (P*(phi*phi')*P)/(1 + phi'*P*phi);
        p = na+nb;  % number of model parameters
        lambda = trace(A) / (p*alpha);
        P = A / lambda;
    else
        error('met: Value error')
    end

    % Correction gain
    K = P*phi;

    % Update parameter estimates
    ek = yk(1) - phi'*theta;
    theta = theta + K*ek / (1 + gamma*abs(ek));

end