%%  Application de la SVD : compression d'images

clear all
close all

% Lecture de l'image
I = imread('BD_Spirou_1.jpg');
I = rgb2gray(I);
I = double(I);

[q, p] = size(I)

% Décomposition par SVD
fprintf('Décomposition en valeurs singulières\n')
tic
[U, S, V] = svd(I);
toc

l = min(p,q);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% On choisit de ne considérer que 200 vecteurs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 200 vecteurs utilisés pour la reconstruction et on affiche l'image tous les 40 vecteurs (pas)
inter = 1:40:(200+40);
inter(end) = 200;

% vecteur pour stocker la différence entre l'image et l'image reconstruite

differenceSVD = zeros(size(inter,2), 1);

% images reconstruites en utilisant de 1 à 200 vecteurs
ti = 0;
td = 0;
for k = inter

    % Calcul de l'image de rang k
    Im_k = U(:, 1:k)*S(1:k, 1:k)*V(:, 1:k)';

    % Affichage de l'image reconstruite
    ti = ti+1;
    figure(ti)
    colormap('gray')
    imagesc(Im_k), axis equal

    % Calcul de la différence entre les 2 images (RMSE : Root Mean Square Error)
    td = td + 1;
    differenceSVD(td) = sqrt(sum(sum((I-Im_k).^2)))
    pause
end

% Figure des différences entre l'image réelle et les images reconstruites
ti = ti+1;
figure(ti)
hold on 
plot(inter, differenceSVD, 'rx')
ylabel('RMSE')
xlabel('rank k')
%pause
    

% Plugger les différentes méthodes : eig, puissance itérée et les 4 versions de la "subspace iteration method" 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QUELQUES VALEURS PAR DÉFAUT DE PARAMÈTRES, 
% VALEURS QUE VOUS DEVEZ FAIRE ÉVOLUER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%tolerance
eps = 1e-9;

% nombre d'itérations max pour atteindre la convergence
maxit = 10000;
 
% taille de l'espace de recherche (m)
search_space = 400;
 
% pourcentage que l'on se fixe
percentage = 0.996;
 
% p pour les versions 2 et 3 (attention p déjà utilisé comme taille)
puiss = 1;

%%%%%%%%%%%%%
% À COMPLÉTER
%%%%%%%%%%%%%

if l == p
    M = I'*I;
else
    M = I*I';
end

%%
% calcul des couples propres
%%


for i=0:5

methode = i;
tic
switch methode
    case 0
        [Veig, SIGeig] = eig(M);
        k = 200;
    case 1
        [Veig, SIGeig] = subspace_iter_v0(M, k, eps, maxit);
        k = 200;
    case 2
        [Veig, SIGeig,k] = subspace_iter_v1(M, k, percentage, eps, maxit);
    case 3
        [Veig, SIGeig,k] = subspace_iter_v2(M, k, percentage, puiss, eps, maxit);
    case 4
        [Veig, SIGeig,k] = subspace_iter_v3(M, k, percentage, puiss, eps, maxit);
    case 5
        [Veig, SIGeig,k] = power_v12(M, k, percentage, eps, maxit);
end
toc


%%
% calcul des valeurs singulières
%%
    
[d,ind] = sort(diag(SIGeig),'descend');
SIGeig = sqrt(diag(d));
SIGeig = S(1:k,1:k);
Veig = Veig(:,ind(1:k));
%%
% calcul de l'autre ensemble de vecteurs
%%

U = zeros(p,k);
V = zeros(p,k);

if l == p
    V = zeros(q,k);
    U = Veig;
    for i=1:k
        V(:,i)=I*Veig(:,i)/S(i,i);
    end
else
    U = zeros(p,k);
    V = Veig;
    for i=1:k
        U(:,i)=I'*Veig(:,i)/S(i,i);
    end
end

%%
% calcul des meilleures approximations de rang faible
%%

td = 0;

inter = 1:40:(k+40);
inter(end) = k;
differenceSVD_2 = zeros(1, floor(k/40))
for k = inter
 
    % Calcul de l'image de rang k
    Im_k = U(:, 1:k)*S(1:k, 1:k)*V(:, 1:k)';

    if  size(Im_k) ~= size(I)
        Im_k = Im_k';
    end
 
    % Affichage de l'image reconstruite
    ti = ti+1;
    figure(ti)
    colormap('gray')
 
    imagesc(Im_k)
    % Calcul de la différence entre les 2 images
    td = td + 1;
    differenceSVD_2(td) = sqrt(sum(sum((I-Im_k).^2)))
    pause
end
 
% Figure des différences entre image réelle et image reconstruite
ti = ti+1;  
figure(ti)
hold on 
plot(inter, differenceSVD_2, 'rx')
title("difference between I and Ik ")
ylabel('RMSE')
xlabel('rank k')
pause


end

