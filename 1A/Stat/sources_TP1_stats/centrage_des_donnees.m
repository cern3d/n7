% Fonction centrage_des_donnees (exercice_1.m)

function [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees)
    n=size(x_donnees_bruitees,1);
    x_G = sum(x_donnees_bruitees)/n;
    y_G = sum(y_donnees_bruitees)/n;
    x_donnees_bruitees_centrees = x_donnees_bruitees - x_G;
    y_donnees_bruitees_centrees = y_donnees_bruitees - y_G;
     
end