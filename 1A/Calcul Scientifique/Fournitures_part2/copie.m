%%  Application de la SVD : compression d'images
 
clear all
close all
 
% Lecture de l'image
I = imread('BD_Asterix_1.png');
I = rgb2gray(I);
I = double(I);
 
 
[q, p] = size(I);
 
% Décomposition par SVD
fprintf('Décomposition en valeurs singulières\n')
tic
[U, S, V] = svd(I);
toc
 
l = min(p,q);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% On choisit de ne considérer que 200 vecteurs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% vecteur pour stocker la différence entre l'image et l'image reconstuite
inter = 1:40:(200+40);
inter(end) = 200;
differenceSVD = zeros(size(inter,2), 1);
 
% images reconstruites en utilisant de 1 à 200 vecteurs (avec un pas de 40)
ti = 0;
td = 0;
for k = inter
 
    % Calcul de l'image de rang k
    Im_k = U(:, 1:k)*S(1:k, 1:k)*V(:, 1:k)';
 
    % Affichage de l'image reconstruite
    ti = ti+1;
    figure(ti)
    colormap('gray')
    imagesc(Im_k)
 
    % Calcul de la différence entre les 2 images
    td = td + 1;
    differenceSVD(td) = sqrt(sum(sum((I-Im_k).^2)));
    pause
end
 
% Figure des différences entre image réelle et image reconstruite
ti = ti+1;
figure(ti)
hold on 
plot(inter, differenceSVD, 'rx')
ylabel('RMSE')
xlabel('rank k')
pause
hold off
 
 
%Plugger les différentes méthodes : eig, puissance itérée et les 4 versions de la "subspace iteration method" 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%QUELQUES VALEURS PAR DÉFAUT DE PARAMÈTRES, 
%VALEURS QUE VOUS POUVEZ/DEVEZ FAIRE ÉVOLUER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% tolérance
eps = 1e-8;
% nombre d'itérations max pour atteindre la convergence
maxit = 10000;
 
% taille de l'espace de recherche (m)
search_space = 200;
 
% pourcentage que l'on se fixe
percentage = 0.996;
 
% p pour les versions 2 et 3 (attention p déjà utilisé comme taille)
puiss = 1;
 

fprintf('Décomposition en valeurs singulières avec la "subspace iteration method v3"\n')
tic
%%
% calcul des couples propres
%%
if q<p 
    M = I'*I;
    U = zeros(q);
 
    W = zeros(p);
    ValP_Desc = zeros(1,p);
else
    M = I*I';
    V = zeros(p);
 
    W = zeros(q);
    ValP_Desc = zeros(1,q);
end
 
 
[W2, D, n_ev, ~, ~, ~ ] = subspace_iter_v3(M, search_space, percentage,puiss, eps, maxit );
ValP_Desc(1:n_ev) = diag(D);
W(:,1:n_ev) = W2;
 
 
if q<p
    V = W;
else
    U = W;
end
 
%%
% calcul des valeurs singulières
%%
Sigma = zeros(q,p);
for i = 1:min(q,p)
    Sigma(i,i) = sqrt(ValP_Desc(i));
end
S= Sigma;
 
%%
% calcul de l'autre ensemble de vecteurs
%
if q<p
    U = (I*V(:,1:q))*diag(1./diag(S));
else
    V = (I'*U(:,1:p))*diag(1./diag(S));
end
toc
%%
% calcul des meilleures approximations de rang faible
%%
l = min(p,q);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% On choisit de ne considérer que 200 vecteurs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% vecteur pour stocker la différence entre l'image et l'image reconstuite
inter = 1:40:(200+40);
inter(end) = 200;
differenceSVD_2 = zeros(size(inter,2), 1);
 
% images reconstruites en utilisant de 1 à 200 vecteurs (avec un pas de 40)
td = 0;
for k = inter
 
    % Calcul de l'image de rang k
    Im_k = U(:, 1:k)*S(1:k, 1:k)*V(:, 1:k)';
 
    % Affichage de l'image reconstruite
    ti = ti+1;
    figure(ti)
    colormap('gray')
 
    imagesc(Im_k)
    title("subspace iteration method v3")
    % Calcul de la différence entre les 2 images
    td = td + 1;
    differenceSVD_2(td) = sqrt(sum(sum((I-Im_k).^2)));
    pause
end
 
% Figure des différences entre image réelle et image reconstruite
ti = ti+1;
figure(ti)
hold on 
plot(inter, differenceSVD_2, 'rx')
title("difference between I and Ik (subspace iteration method v3)")
ylabel('RMSE')
xlabel('rank k')
pause