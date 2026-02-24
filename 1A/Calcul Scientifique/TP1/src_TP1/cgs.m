%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Calcul scientifique
% TP1 - Orthogonalisation de Gram-Schmidt
% cgs.m
%--------------------------------------------------------------------------

function Q = cgs(A)

    % Recuperation du nombre de colonnes de A
    [~, m] = size(A);
    
    % Initialisation de la matrice Q avec la matrice A
    Q = A;
    
    %------------------------------------------------
    % A remplir
    % Algorithme de Gram-Schmidt classique
    %------------------------------------------------
    Q(:,1) = A(:,1)/norm(A(:,1),2);
        for i=2:m
            p=A(:,1)*0
            for j=1:i-1
                p = p + (A(:,i)'*Q(:,j))*Q(:,j);
            end
            Q(:,i) = Q(:,i)-p;
            Q(:,i) = Q(:,i)/norm(Q(:,i),2);
        end

end