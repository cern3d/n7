% fonction modelisation_vraisemblance (pour l'exercice 1)

function modele_V = modelisation_vraisemblance(X,mu,Sigma)
    n = size(X,1);
    fract = 2*pi*sqrt(det(Sigma));
    Xc = X - repmat(mu,n,1);
    modele_V = zeros(n , 1);
    for i = 1:n
        modele_V(i) = exp(-(Xc(i,:))*(Sigma\(Xc(i,:)')/2);
    end

    modele_V = modele_V/fract;

end