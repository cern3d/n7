:- include(libmagic).

check_domain(_,[],_,_).
check_domain(N,[L|M],LB,UB):-
    length(L,N),
    fd_domain(L,LB,UB),
    check_domain(N,M,LB,UB).


smatrix(N,LB,UB,[L|M]):-
    length(L,N),
    length([L|M],N),
    fd_domain(L,LB,UB),
    check_domain(N,M,LB,UB).


normale(M):-
    flatten(M,MF),
    fd_all_different(MF).

sum([], 0).
sum([X|L], X + S) :-
    sum(L, S).
% sum([], 0).
% sum([X|L], S) :-
%     sum(L, S1),
%     S #= X + S1.


sum_lines([], _).
sum_lines([L1|M],S):-
    sum(L1,SL),
    SL #= S,
    sum_lines(M,S).
    

sum_col(M,S):-
    transpose(M,MT),
    sum_lines(MT,S).


sum_diag(M,S):-
    diag1(M,D1),
    diag2(M,D2),
    sum(D1,S),
    sum(D2,S).

solve(M,N,B):-
    Nc is N*N,
    smatrix(N,0,Nc,M),
    normale(M),
    sum_lines(M,S),
    sum_col(M,S),
    sum_diag(M,S),
    flatten(M,MF),
    user_time(T0),
    T is T0,
    printsol(M,B,T),
    append(B,MF,Vars),
    fd_labeling(Vars,[backtracks(B),variable_method(smallest)]).
