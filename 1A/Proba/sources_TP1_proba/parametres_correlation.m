% Fonction parametres_correlation (exercice_1.m)

function [r,a,b] = parametres_correlation(Vd,Vg)
    l = size(Vd,1);
    col1 = ones(size(Vd));
    moyd = sum(Vd)/l;
    moyg = sum(Vg)/l;
    tooletd = Vd - moyd*col1(1);
    tooletg = Vg - moyg*col1(1);
    ecarttyped = sum(sqrt(tooletd.*tooletd/l));
    ecarttypeg = sum(sqrt(tooletg.*tooletg/l));
    cosigma = (tooletg.*tooletd)/l;
    r=cosigma/(ecarttypeg*ecarttyped);
    a=cosigma/(ecarttyped^2);
    b=cosigma/(ecarttyped^2)*moyd + moyg;
end