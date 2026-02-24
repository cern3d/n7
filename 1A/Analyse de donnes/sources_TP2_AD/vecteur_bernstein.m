% fonction vecteur_bernstein (pour exercice_1.m
function resultat = vecteur_bernstein(x,d,k)

    resultat = nchoosek(d,k) * (x.^k).*((ones(size(x))-x).^(d-k));

end



