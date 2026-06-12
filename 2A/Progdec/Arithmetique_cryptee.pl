digits2nb_rec([], _, 0).

digits2nb_rec([X|Xs], I, K*X + R) :-
    K is truncate(10**I),
    I1 is I - 1,
    digits2nb_rec(Xs, I1, R).

digits2nb(L, Nb) :-
    length(L, N),
    N1 is N - 1,
    digits2nb_rec(L, N1, Nb).


% DONALD + GERALD = ROBERT

dg(Vars) :-
    Vars = [D,O,N,A,L,G,E,R,B,T],

    fd_domain(Vars, 0, 9),

    D #\= 0,
    G #\= 0,
    R #\= 0,

    fd_all_different(Vars),

    digits2nb([D,O,N,A,L,D], DE),
    digits2nb([G,E,R,A,L,D], GE),
    digits2nb([R,O,B,E,R,T], RE),

    DE + GE #= RE,

    fd_labeling(Vars).