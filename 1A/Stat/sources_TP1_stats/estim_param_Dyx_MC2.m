% Fonction estim_param_Dyx_MC2 (exercice_2bis.m)

function [a_Dyx,b_Dyx,coeff_r2] = ...
                   estim_param_Dyx_MC2(x_donnees_bruitees,y_donnees_bruitees)
[x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);
    
    r = (cov(x_donnees_bruitees_centrees,y_donnees_bruitees_centrees))/(sqrt(var(y_donnees_bruitees_centrees))*sqrt(var(x_donnees_bruitees_centrees)))
    
	a_Dyx = r*sqrt(var(x_donnees_bruitees_centrees)/var(y_donnees_bruitees_centrees));
    b_Dyx = y_G - a_Dyx*x_G;

    
end