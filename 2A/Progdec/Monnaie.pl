% =========================================================
% 1. Toutes les possibilités (max 3 pièces identiques)
% =========================================================

% rendre_monnaie(Vars) :-
%     % Vars représente le nombre de pièces de [2€, 1€, 50c, 20c, 10c, 5c, 2c, 1c]
%     Vars = [P200, P100, P50, P20, P10, P5, P2, P1],
    
%     % Contrainte : on utilise au maximum 3 fois la même pièce
%     fd_domain(Vars, 0, 3),
    
%     % Contrainte : la somme totale doit être de 271 centimes
%     200*P200 + 100*P100 + 50*P50 + 20*P20 + 10*P10 + 5*P5 + 2*P2 + 1*P1 #= 271,
    
%     % Recherche des solutions
%     fd_labeling(Vars).


% % =========================================================
% % 2. Prédicat sum(L, S) et construction de la variable Cost
% % =========================================================

% % Construit l'expression récursivement : X1 + X2 + ... + 0
% sum([], 0).
% sum([X|L], X + S) :-
%     sum(L, S).


% % =========================================================
% % 3. Minimisation avec fd_minimize(Goal, Cost)
% % =========================================================

% rendre_monnaie_opt(Vars, Cost) :-
%     Vars = [P200, P100, P50, P20, P10, P5, P2, P1],
%     fd_domain(Vars, 0, 3),
%     200*P200 + 100*P100 + 50*P50 + 20*P20 + 10*P10 + 5*P5 + 2*P2 + 1*P1 #= 271,
    
%     % Question 2 : Utilisation de sum/2 pour construire l'expression
%     sum(Vars, S),
    
%     % Question 2 : Définition de la variable Cost contrainte à cette expression
%     Cost #= S,
    
%     % Question 3 : Minimisation du nombre total de pièces
%     fd_minimize(fd_labeling(Vars), Cost).



sum([],0).
sum([L|RL],L+S):-
    sum(RL,S).

dg(Vars):-
    Vars = [A,B,C,D,E,F,G],

    fd_domain(Vars,0,3),

    1*A +
    2*B +
    5*C +
    10*D +
    20*E +
    50*F +
    100*G
    #= 271.

monnaie(Vars,Cost) :-
    dg(Vars),
    
    % Question 2 : Utilisation de sum/2 pour construire l'expression
    sum(Vars, S),

    Cost#=S,
        
    % Question 3 : Minimisation du nombre total de pièces
    fd_minimize(fd_labeling(Vars), Cost).
    