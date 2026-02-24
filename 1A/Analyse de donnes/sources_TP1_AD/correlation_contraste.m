% function correlation_contraste (pour exercice_1.m)

function [correlation,contraste] = correlation_contraste(X)
    taille = size(X,1);
    X_bar = mean(X,1);
    sigma = 1/taille * transpose((X- X_bar))*(X- X_bar);
    correlation = zeros(3,3);
    variance = sum(var(X));
    contraste = diag(sigma)/trace(sigma);
    for i=1:3
        for j=1:3
            correlation(i,j) = sigma(i,j)/(sqrt(sigma(i,i)*sigma(j,j)));
        end
    end
    
end
