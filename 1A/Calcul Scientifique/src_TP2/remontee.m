%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Calcul scientifique
% TP2 - Factorisation LU
% remontee.m
%---------------------------------------------------------------------------

function x = remontee(U,b)
%---------------------------------------------------------------------------
% Resoudre U x = b avec 
% U triangulaire superieure, b second membre.
%---------------------------------------------------------------------------
       
     %Initialisation
     [n, ~] = size(U);
     x=b;
     for i = n:-1:1
        x(i) = (b(i) - U(i, i+1:n) * x(i+1:n)) / U(i, i);
     end
end
