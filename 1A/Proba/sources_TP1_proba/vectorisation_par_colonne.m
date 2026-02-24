% Fonction vectorisation_par_colonne (exercice_1.m)

function [Vd,Vg] = vectorisation_par_colonne(I)
    Vd = I(:,1:(size(I,2)-1));
    Vd = Vd(:);
    Vg = I(:,2:size(I,2));
    Vg = Vg(:);
end