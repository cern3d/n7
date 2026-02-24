%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Calcul scientifique
% TP2 - Factorisation LU
% descente.m
%---------------------------------------------------------------------------

function x = descente(L,p,b)
%---------------------------------------------------------------------------
% Resoudre L x = Pb avec 
% L triangulaire inferieure avec diagonale de 1, b second membre,
% et p vecteur des indices de permutation des lignes.
%---------------------------------------------------------------------------
       
     %Initialisation
     [n, ~] = size(L);
     b = p*b;
     x=b;
     for i = 1:n
        x(i) = b(i) - L(i, 1:i-1) * x(1:i-1);
     end
end
