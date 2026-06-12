% PPC
% Donnees et but pour le TP2
% Nicolas Barnier

data(1, 3, [2,1,1,1,1,1]).
data(2, 19, [10,9,7,6,4,4,3,3,3,3,3,2,2,2,1,1,1,1,1,1]).
data(3, 112, [50,42,37,35,33,29,27,25,24,19,18,17,16,15,11,9,8,7,6,4,2]).
data(4, 175, [81,64,56,55,51,43,39,38,35,33,31,30,29,20,18,16,14,9,8,5,4,3,2,1]).

printall([], [], [], _).
printall([X|Xs], [Y|Ys], [T|Ts], S):-
	XT is X+T,
	YT is Y+T,
	format(S, "%d %d\n%d %d\n%d %d\n%d %d\n%d %d\n\n", [X,Y,XT,Y,XT,YT,X,YT,X,Y]),
        printall(Xs, Ys, Ts, S).

printsol(Sink, Xs, Ys, Ts):-
	open(Sink, write, S),
	printall(Xs, Ys, Ts, S),
	close(S).

indomain(X):-
        non_fd_var(X), !.
indomain(X):-
        fd_min(X, MinX),
        (X #= MinX; (g_inc(bt), X #\= MinX, indomain(X))).

assign(X):-
        non_fd_var(X), !.
assign(X):-
        fd_min(X, MinX),
        (X #= MinX; (g_inc(bt), X #\= MinX)).

labeling1([], _, _):- !.
labeling1(Vars, Goal, Criterion):-
        skipcst(Vars, Unks),
        Unks = [_|_] ->
        (mincrit(Unks, Criterion, Best, Rest),
	G =.. [Goal, Best],
	call(G),
        labeling1([Best|Rest], Goal, Criterion));
        true.

labeling(Xs, Ys, Goal, Criterion, B, NbSol):-
	g_assign(bt, 0),
	g_assign(nbsol, 0),
	labeling1(Xs, Goal, Criterion),
	labeling1(Ys, Goal, Criterion),
	g_inc(nbsol, NbSol),
	g_read(bt, B).

skipcst([], []).
skipcst([X|Xs], Vars):-
	non_fd_var(X), !,
	skipcst(Xs, Vars).
skipcst([X|Xs], [X|Vs]):-
	skipcst(Xs, Vs).

mincritrec([], _, _, Best, Rest, Best, Rest).
mincritrec([X|Xs], Criterion, BC, BX, Rest, B, R):-
        non_fd_var(X), !,
        mincritrec(Xs, Criterion, BC, BX, Rest, B, R).
mincritrec([X|Xs], Criterion, BC, BX, Rest, B, R):-
        GC =.. [Criterion,X,C],
        call(GC),
        C @< BC -> mincritrec(Xs, Criterion, C, X, [BX|Rest], B, R);
        mincritrec(Xs, Criterion, BC, BX, [X|Rest], B, R).


mincrit([X|Xs], Criterion, Best, Rest):-
	GC =.. [Criterion,X,C],
	call(GC),
        mincritrec(Xs, Criterion, C, X, [], Best, Rest).

default(_, 1).

minsize(V, S):-
    fd_size(V, S).

minsizemin(V, [S, M]):-
    fd_size(V, S),
    fd_min(V, M).

minmin(V, M):-
        fd_min(V, M).






% =========================================================
% 1. Contraintes de non-chevauchement (No-Overlap)
% =========================================================
no_overlap([],[],[]).
no_overlap([L|LT],[X|Xs],[Y|Ys]):-
    safe(L,X,Y,LT,Xs,Ys),
    no_overlap(LT,Xs,Ys).

safe(_,_,_,[],[],[]).
safe(CL,CX,CY,[L|LT],[X|Xs],[Y|Ys]):-
    (CX + CL #=< X) #\/ (X + L #=< CX) #\/
    (CY + CL #=< Y) #\/ (Y + L #=< CY),
    safe(CL,CX,CY,LT,Xs,Ys).

% =========================================================
% 2. Contraintes de frontières (Inside main square)
% =========================================================
inside_bounds([], [], [], _).
inside_bounds([L|LT], [X|Xs], [Y|Ys], T) :-
    X + L #=< T,
    Y + L #=< T,
    inside_bounds(LT, Xs, Ys, T).

% =========================================================
% 3. Contraintes Redondantes Géométriques (Sections)
% =========================================================

% Génère la liste des indices de 0 à T-1
gen_indices(T, T, []) :- !.
gen_indices(I, T, [I|Rs]) :-
    I < T,
    I1 is I + 1,
    gen_indices(I1, T, Rs).

% Applique la contrainte de coupe pour TOUTES les lignes/colonnes
apply_cuts([], _, _, _, _).
apply_cuts([V|Vs], Coords, LT, T, Mode) :-
    build_cut_expr(Coords, LT, V, Expr_List),
    sum_expr(Expr_List, Total_Expr),
    Total_Expr #= T, % La somme des tailles doit être EXACTEMENT égale à T
    apply_cuts(Vs, Coords, LT, T, Mode).

% Construit la liste des termes réifiés : Taille * (Coord_i <= V /\ V < Coord_i + Taille_i)
build_cut_expr([], [], _, []).
build_cut_expr([C|Cs], [L|Ls], V, [L * B | Rs]) :-
    % B vaut 1 si la ligne V coupe le carré, 0 sinon
    B #<=> (C #=< V #/\ V #< C + L),
    build_cut_expr(Cs, Ls, V, Rs).

% Somme linéaire des expressions de type Arbre Syntaxique
sum_expr([], 0).
sum_expr([X|Xs], X + S) :-
    sum_expr(Xs, S).

% =========================================================
% Résolution Principale
% =========================================================
solve(Num, Xs, Ys) :-
    data(Num, T, LT),

    length(LT, N),
    length(Xs, N),
    length(Ys, N),

    fd_domain(Xs, 0, T),
    fd_domain(Ys, 0, T),

    % Base du problème
    no_overlap(LT, Xs, Ys),
    inside_bounds(LT, Xs, Ys, T),

    % Génération des coordonnées fixes pour les coupes de v = 0 à T-1

    % Application de la contrainte redondante sur les verticales (Xs)
    apply_cuts(Indices, Xs, LT, T, v),

    % Application de la contrainte redondante sur les horizontales (Ys)
    apply_cuts(Indices, Ys, LT, T, h),

    append(Xs, Ys, Vars),
    
    % Utilisation de First-Fail (ff) pour maximiser l'efficacité de la propagation
    fd_labeling(Vars).