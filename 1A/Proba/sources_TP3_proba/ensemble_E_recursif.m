% Fonction ensemble_E_recursif (exercie_1.m)

function [E,contour,G_somme] = ensemble_E_recursif(E,contour,G_somme,i,j,...
                                                   voisins,G_x,G_y,card_max,cos_alpha)
    if size(E,1) > card_max
        return
    end

    % Mise à 0 de la valeur contour du pixel courant pour ne pas retourner dessus
    contour(i,j) = 0;
    % Nombre de voisins (ici 8)
    nb_voisins = size(voisins,1);
    % Initialisation du comptage des 8 voisins a parcourir
    k = 1;
    % A COMPLETER
    while k<=nb_voisins
        i_voisin = i + voisins(k,1);
        j_voisin = j + voisins(k,2);
        if contour(i_voisin,j_voisin)==1
            if norm([G_x(i_voisin,j_voisin) , G_y(i_voisin,j_voisin)])*norm(G_somme) >0  
                if dot([G_x(i_voisin,j_voisin) , G_y(i_voisin,j_voisin)] , G_somme) / (norm([G_x(i_voisin,j_voisin) , G_y(i_voisin,j_voisin)]) * norm(G_somme)) >= cos_alpha
                    E = [E; i_voisin,j_voisin];
                    G_somme = G_somme + [G_x(i_voisin,j_voisin) , G_y(i_voisin,j_voisin)];
                    [E,contour,G_somme] = ensemble_E_recursif(E,contour,G_somme,i_voisin,j_voisin,...
                                                   voisins,G_x,G_y,card_max,cos_alpha);

                end
            end
        end
        k=k+1;
    end
end