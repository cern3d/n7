% fonction estim_param_MC_paire (pour exercice_2.m)

function parametres = estim_param_MC_paire(d,x,y_inf,y_sup)

    p = size(x,1);
    A1 = zeros(p,d);
    for i = 1:d 
        A1(:,i)=vecteur_bernstein(x,d,i);
    end
    b1 = y_sup - y_sup(1)*vecteur_bernstein(x,d,0);
    b2 = y_inf - y_inf(1)*vecteur_bernstein(x,d,0);

    b=[b1(1:p-1) ;  b2];
    A=[A1(:,1:d-1) , zeros(p,d);
       zeros(p,d-1) , A1];
    size(b)
    size(A)
    parametres = A\b;

end
