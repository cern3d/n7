% function ACP (pour exercice_2.m)

function [C,bornes_C,coefficients_RVG2gris] = ACP(X)

    taille = size(X,1);
    X_bar = mean(X,1);
    N=(X- X_bar);
    sigma = 1/taille * N'*N;

    [W,D] = eig(sigma);

    [ col_vp , i ] = sort(diag(D) , 'descend');
    W = W(:,i)

    C = W*X';

    bornes_C = [min(C(:)) max(C(:))];

    coefficients_RVG2gris = W(:,1)/norm(W(:,1))

end
