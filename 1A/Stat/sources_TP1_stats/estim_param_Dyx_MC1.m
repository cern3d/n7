% Fonction estim_param_Dyx_MC1 (exercice_2.m)

function [a_Dyx,b_Dyx,coeff_R2] = ...
                   estim_param_Dyx_MC1(x_donnees_bruitees,y_donnees_bruitees)
   [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);

    A = [x_donnees_bruitees_centrees,ones(length(x_donnees_bruitees_centrees),1)];
    B = y_donnees_bruitees_centrees;

    X = inv(A'*A)*(A'*B);

    a_Dyx = X(1);
    b_Dyx = X(2);

   coeff_R2 = sqrt(1-(sum((y_donnees_bruitees_centrees-a_Dyx*x_donnees_bruitees_centrees-b_Dyx).^2))/sum((y_donnees_bruitees_centrees-y_G).^2))
    
end