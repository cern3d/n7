data(1, 3, [2,1,1,1,1,1]).
data(2, 19, [10,9,7,6,4,4,3,3,3,3,3,2,2,2,1,1,1,1,1,1]).
data(3, 112, [50,42,37,35,33,29,27,25,24,19,18,17,16,15,11,9,8,7,6,4,2]).
data(4, 175, [81,64,56,55,51,43,39,38,35,33,31,30,29,20,18,16,14,9,8,5,4,3,2,1]).

% 1. Non-overlapping constraints
no_overlap([],[],[]).
no_overlap([L|LT],[X|Xs],[Y|Ys]):-
    safe(L,X,Y,LT,Xs,Ys),
    no_overlap(LT,Xs,Ys).

safe(_,_,_,[],[],[]).
safe(CL,CX,CY,[L|LT],[X|Xs],[Y|Ys]):-
    % FIXED: Corrected the CY/Y variables here
    (CX + CL #=< X) #\/ (X + L #=< CX) #\/
    (CY + CL #=< Y) #\/ (Y + L #=< CY),
    safe(CL,CX,CY,LT,Xs,Ys).

% 2. Bounding Box constraints (keeps everything inside T)
inside_bounds([], [], [], _).
inside_bounds([L|LT], [X|Xs], [Y|Ys], T) :-
    X + L #=< T,
    Y + L #=< T,
    inside_bounds(LT, Xs, Ys, T).

condition_cut([],[],[],[]).
condition_cut([X|Xs],[L|Lts],[V|Vs],[(X#=< V) #/\ (V#< X+ L)|R]):-
    condition_cut(Xs,Lts,Vs,R).

% Génère la liste des indices de 0 à T-1
gen_indices(T, T, []) :- !.
gen_indices(I, T, [I|Rs]) :-
    I < T,
    I1 is I + 1,
    gen_indices(I1, T, Rs).

vertical([],_,_,_ ).
vertical([V|Vs],Xs,Lt,T):-
    condition_cut(X,Lt,V,Cut),
    produit(Lt,X,Cut),
    sum(Cut,N),
    N#=<T,
    vertical(V,Xs,Lt,T).

solve(Num,Xs,Ys):-
    data(Num,T,LT),


    length(LT,N),
    length(Xs,N),
    length(Ys,N),

    fd_domain(Xs,0,T),
    fd_domain(Ys,0,T),

    no_overlap(LT,Xs,Ys),
    
    % Constrain the squares so they don't stick out of the main container
    inside_bounds(LT, Xs, Ys, T),

    gen_indices(0, T, Indices),
    vertical(Indices,Xs,Lt,T),

    append(Xs,Ys,Vars),
    
    % 'ff' (first-fail) heuristic is vital for problems 2, 3, and 4 to finish quickly
    fd_labeling(Vars, [variable_method(ff)]).