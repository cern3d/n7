% Fonction estim_param_Dyx_MV (exercice_1.m)

function [a_Dyx,b_Dyx,residus_Dyx] = ...
           estim_param_Dyx_MV(x_donnees_bruitees,y_donnees_bruitees,tirages_psi)
[x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);

    valeur = zeros(length(tirages_psi),1);
    for i = 1:length(tirages_psi)
        valeur(i) = sum((y_donnees_bruitees_centrees-tan(tirages_psi(i))*x_donnees_bruitees_centrees).*(y_donnees_bruitees_centrees-tan(tirages_psi(i))*x_donnees_bruitees_centrees));
    end
    [m, ind_min] = min(valeur)
    a_Dyx=tan(tirages_psi(ind_min));
    b_Dyx = y_G - a_Dyx*x_G;
    residus_Dyx = y_donnees_bruitees_centrees-a_Dyx*x_donnees_bruitees_centrees-b_Dyx;
end