function [theta, P] = idrar1(nn, yk, theta, P, gamma, met, l) 
    % Algorithme des moindres carr�s ordinaires r�cursifs (MCOR) 
    % pour l'identification en ligne d'un syst�me AR.
    % 
    % Arguments:
    %    nn : vecteur sp�cifiant la structure du mod�le [na]
    %    yk : vecteur de sortie actuelles et pass�es
    % theta : vector of current parameter estimates
    %     P : covariance matrix
    % gamma : param�tre gamma utilis�e pour l'estimation robuste
    %   met : m�thode de gestion du facteur d'oubli
    %         (1 : algorithme � gain d�croissant,
    %          2 : algorithme � facteur d'oubli fixe,
    %          3 : algorithme � trace constante)
    %     l : param�tre utilis� pour la gestion du facteur d'oubli
    %         si met = 2, l = lambda (facteur d'oubli)
    %         si met = 3, l = alpha (param�tre d�finissant le seuil de la trace)

    % ARX model structure
    na = nn(1); assert(length(yk) == (na+1))

    % Construct regressor vector from past data
    phi = [-yk(2:end)];

    % Covariance matrix update
    if met == 1
        % Algorithme � gain d�croissant
        P = P - (P*(phi*phi')*P)/(1 + phi'*P*phi);
    elseif met == 2
        % Algorithme � facteur d'oubli fixe
        lambda = l;
        P = (P - (P*(phi*phi')*P)/(l + phi'*P*phi)) / lambda;
    elseif met == 3
        % Algorithme � trace constante
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